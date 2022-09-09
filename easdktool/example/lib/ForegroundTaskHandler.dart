import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:easdktool/Been/EABeen.dart';
import 'package:easdktool/EACallback.dart';
import 'package:easdktool/easdktool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';

import 'FirstMethodPackageData.dart';

void ForegroundTaskCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

class ForegroundTaskHandler extends TaskHandler {
  int count = 0;
  SendPort? _sendPort;
  ReceivePort _port = ReceivePort();
  ReceivePort _notifPort = ReceivePort();
  EASDKTool easdkTool = new EASDKTool();

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    print("Foreground Service Started");
    initEASDK();

    if (Platform.isAndroid) {
      //The first way is to perform data interaction with the watch
      IsolateNameServer.registerPortWithName(
          _notifPort.sendPort, '_notifications_');
      _notifPort.listen((message) {
        PackageData packageData = message;
        dynamic param = packageData.param;
        if (packageData.action == 3) {
          pushNotification(param);
        } else if (packageData.action == 1) {
          getWatchData(param);
        } else if (packageData.action == 2) {
          int dataType = packageData.dataType;
          setWatchData(dataType, param);
        }
      });
    }

    NotificationsListener.initialize(callbackHandle: _notificationCallback);

    var hasPermission = await NotificationsListener.hasPermission;
    if (!hasPermission!) {
      print("no permission, so open settings");
      NotificationsListener.openPermissionSettings();
      return;
    }
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {}

  @override
  void onButtonPressed(String id) {
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/dashboard");
    _sendPort?.send('onNotificationPressed');
  }

  static void _notificationCallback(NotificationEvent evt) {
    //This is the place we are getting the notification from the device.

    // print("Foreground Notification received: $evt");
    // The first way is to perform data interaction with the watch
    final SendPort? send = IsolateNameServer.lookupPortByName(
        '_notifications_'); //Sending the notification to Foreground Isolate.
    print("获取到通知");
    PackageData packageData = PackageData();
    packageData.action = 3;
    packageData.param = evt;
    send?.send(packageData);
  }

  pushNotification(NotificationEvent event) {
    //This method handles pushing the notification to watch.
    EAPushMessage eapushMessage = EAPushMessage();
    eapushMessage.messageType = EAPushMessageType.whatsApp;
    eapushMessage.messageActionType = EAPushMessageActionType.add;
    eapushMessage.title = event.title.toString();

    DateTime dateTime = DateTime.now();
    eapushMessage.date = dateTime.year.toString() +
        (dateTime.month < 10
            ? "0" + dateTime.month.toString()
            : dateTime.month.toString()) +
        (dateTime.day < 10
            ? "0" + dateTime.day.toString()
            : dateTime.day.toString()) +
        "T" +
        (dateTime.hour < 10
            ? "0" + dateTime.hour.toString()
            : dateTime.hour.toString()) +
        (dateTime.minute < 10
            ? "0" + dateTime.minute.toString()
            : dateTime.minute.toString()) +
        (dateTime.second < 10
            ? "0" + dateTime.second.toString()
            : dateTime.second.toString());
    eapushMessage.content = event.message.toString();
    easdkTool.setWatchData(kEADataInfoTypePushInfo, eapushMessage.toMap(),
        EASetDataCallback(onRespond: ((respond) {
      print('---> ${eapushMessage.messageType}');
      print(respond.respondCodeType);
    })));
  }

  void connectBluetooth() {
    EAConnectParam connectParam = EAConnectParam();
    connectParam.connectAddress =
        "45:41:80:A3:F5:BA"; //"45:41:46:03:F2:A7"; // "45:41:70:97:FC:84"; // andriond need
    connectParam.snNumber = "002006000009999010";
    //"001007220516000001","002006000009999009","001007220719000021","001007220516000001"; //"001001211112000028"; // iOS need
    easdkTool.connectToPeripheral(connectParam);
  }

  void getWatchData(int dataType) {
    easdkTool.getWatchData(
        dataType,
        EAGetDataCallback(
            onSuccess: ((info) {
              final SendPort? sendPort =
                  IsolateNameServer.lookupPortByName("_ui_get_isolate");
              print("将获取到的数据传到UI线程");
              sendPort?.send(info);
              //将数据回传到UI界面
              //int dataType = info["dataType"];
              // Map<String, dynamic> value = info["value"];
              // returnClassValue(dataType, value);
            }),
            onFail: ((info) {})));
  }

  void setWatchData(int dataType, Map map) {
    easdkTool.setWatchData(dataType, map,
        EASetDataCallback(onRespond: ((respond) {
      final SendPort? sendPort =
          IsolateNameServer.lookupPortByName("_ui_set_isolate");
      print("将设置的结果传到UI线程");
      sendPort?.send(respond);
    })));
  }

  static DateTime timestampToDate(int timestamp) {
    DateTime dateTime = DateTime.now();

    ///如果是十三位时间戳返回这个
    if (timestamp.toString().length == 13) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp.toString().length == 16) {
      ///如果是十六位时间戳
      dateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    } else if (timestamp.toString().length == 10) {
      ///如果是十位时间戳
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    }
    return dateTime;
  }

  static String timestampToDateStr(int timestamp, {onlyNeedDate = false}) {
    DateTime dataTime = timestampToDate(timestamp);
    String dateTime = dataTime.toString();

    dateTime = dateTime.substring(0, dateTime.length - 4);
    if (onlyNeedDate) {
      List<String> dataList = dateTime.split(" ");
      dateTime = dataList[0];
    }
    return dateTime;
  }

  void getBigWatchData() {
    easdkTool.getBigWatchData(EAGetBitDataCallback(((info) {
      /// Determine what kind of big data "dataType" is
      ///【判断dataType是属于那种大数据】

      int dataType = info['dataType'];
      List<dynamic> list = info['value'];
      print(dataType);

      if (list.isEmpty) {
        return;
      }
      switch (dataType) {
        case kEADataInfoTypeStepData: //Daily steps【日常步数】

          for (Map<String, dynamic> item in list) {
            EABigDataStep model = EABigDataStep.fromMap(item);
            print(model.timeStamp);
            print('Daily steps date: ' + timestampToDateStr(model.timeStamp));
          }
          break;
        case kEADataInfoTypeSleepData: // sleep
          for (Map<String, dynamic> item in list) {
            EABigDataSleep model = EABigDataSleep.fromMap(item);
            print(model.timeStamp);
          }
          break;
        case kEADataInfoTypeHeartRateData: // heart rate
          for (Map<String, dynamic> item in list) {
            EABigDataHeartRate model = EABigDataHeartRate.fromMap(item);
            print(model.timeStamp);
            print('heart rate date: ' + timestampToDateStr(model.timeStamp));
          }

          break;
        case kEADataInfoTypeGPSData: // gps
          for (Map<String, dynamic> item in list) {
            EABigDataGPS model = EABigDataGPS.fromMap(item);
            print(model.timeStamp);
          }
          break;
        case kEADataInfoTypeSportsData: // sports
          for (Map<String, dynamic> item in list) {
            EABigDataSport model = EABigDataSport.fromMap(item);
            print(model.beginTimeStamp);
            print('beginDate: ' + timestampToDateStr(model.beginTimeStamp));
          }
          break;
        case kEADataInfoTypeBloodOxygenData: // Blood oxygen
          for (Map<String, dynamic> item in list) {
            EABigDataBloodOxygen model = EABigDataBloodOxygen.fromMap(item);
            print(model.timeStamp);
          }
          break;
        case kEADataInfoTypeStressData: // Stress
          for (Map<String, dynamic> item in list) {
            EABigDataStress model = EABigDataStress.fromMap(item);
            print(model.timeStamp);
          }
          break;
        case kEADataInfoTypeStepFreqData: // stride frequency
          for (Map<String, dynamic> item in list) {
            EABigDataStrideFrequency model =
                EABigDataStrideFrequency.fromMap(item);
            print(model.timeStamp);
          }
          break;
        case kEADataInfoTypeStepPaceData: // stride Pace
          for (Map<String, dynamic> item in list) {
            EABigDataStridePace model = EABigDataStridePace.fromMap(item);
            print(model.timeStamp);
          }
          break;
        case kEADataInfoTypeRestingHeartRateData: //resting heart rate
          for (Map<String, dynamic> item in list) {
            EABigDataRestingHeartRate model =
                EABigDataRestingHeartRate.fromMap(item);
            print(model.timeStamp);
          }
          break;
        case EADataInfoTypeHabitTrackerData: // habit tracker
          for (Map<String, dynamic> item in list) {
            EABigDataHabitTracker model = EABigDataHabitTracker.fromMap(item);
            print(model.timeStamp);
          }
          break;

        default:
          break;
      }
    })));
  }

  void initEASDK() async {
    easdkTool.showLog(1);
    EASDKTool.addBleConnectListener(ConnectListener(easdkTool));
    EASDKTool.addOperationPhoneCallback(OperationPhoneCallback((info) {
      operationPhoneListener(info);
    }));
    easdkTool.initChannel();
    connectBluetooth();
  }

  void operationPhoneListener(Map info) {
    ///  Check whether info["opePhoneType"] belongs to EAOpePhoneType and perform the corresponding operation
    /// 【判断 info["opePhoneType"] 是属于EAOpePhoneType的哪一个，做对应的操作】
  }
}

class ConnectListener implements EABleConnectListener {
  EASDKTool? _easdkTool;

  ConnectListener(this._easdkTool);

  @override
  void connectError() {
    print("connectError");
  }

  @override
  void connectTimeOut() {
    print("connectTimeOut");
  }

  @override
  void deviceConnected() {
    print('Device connected');
    _easdkTool?.getWatchData(
        kEADataInfoTypeWatch,
        EAGetDataCallback(
            onSuccess: ((info) async {
              Map<String, dynamic> value = info["value"];
              EABleWatchInfo eaBleWatchInfo = EABleWatchInfo.fromMap(value);

              if (eaBleWatchInfo.userId.isEmpty) {
                /**
                    1st.
                 * get watch infomation,to determine 'isWaitForBinding' the value 【连接成功后，获取手表信息，判断'isWaitForBinding'的值】
                    2nd.
                 * 1.if isWaitForBinding = 0，bindInfo.bindingCommandType need equal 1
                 * 2.if isWaitForBinding = 1，bindInfo.bindingCommandType need equal 0 ,
                    The watch displays a waiting for confirmation binding screen,
                    Wait to click OK or cancel
                 */

                EABindInfo bindInfo = EABindInfo();
                bindInfo.user_id = "1008690";
                // Turn on the daily step interval for 30 minutes
                bindInfo.bindMod = 1;
                if (eaBleWatchInfo.isWaitForBinding == 0) {
                  //Bind command type: End【绑定命令类型：结束】
                  bindInfo.bindingCommandType = 1;
                } else {
                  //Bind command type: Begin【绑定命令类型：开始】
                  bindInfo.bindingCommandType = 0;
                }
                _easdkTool?.bindingWatch(bindInfo,
                    EABindingWatchCallback(onRespond: ((respond) {
                  print(respond.respondCodeType);
                })));
              }
            }),
            onFail: ((info) {})));
  }

  @override
  void deviceDisconnect() {
    print("deviceDisconnect");
  }

  @override
  void deviceNotFind() {
    print("deviceNotFind");
  }

  @override
  void notOpenLocation() {
    print("notOpenLocation");
  }

  @override
  void paramError() {
    print("paramError");
  }

  @override
  void unopenedBluetooth() {
    print("unopenedBluetooth");
  }

  @override
  void unsupportedBLE() {
    print("unsupportedBLE");
  }

  @override
  void iOSRelievePair() {
    print("iOSRelievePair");
  }

  @override
  void iOSUnAuthorized() {
    print("iOSUnAuthorized");
  }
}
