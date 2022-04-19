// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names

part of easdktool.been;

/// 数据类型
/* 手表 */
const int kEADataInfoTypeWatch = 3;
/* 用户 */
const int kEADataInfoTypeUser = 4;
/* 同步时间 */
const int kEADataInfoTypeSyncTime = 5;
/* 绑定手表 */
const int kEADataInfoTypeBingWatch = 6;
/* 屏幕亮度 */
const int kEADataInfoTypeBlacklight = 7;
/* 屏幕自动灭屏时间 */
const int kEADataInfoTypeBlacklightTimeout = 8;
/* 设备电量信息 */
const int kEADataInfoTypeBattery = 9;
/* 设备语言信息 */
const int kEADataInfoTypeLanguage = 10;
/* 统一设备单位 */
const int kEADataInfoTypeUnifiedUnit = 11;
/* 设备操作 */
const int kEADataInfoTypeDeviceOps = 12;
/* 免打扰时间段 */
const int kEADataInfoTypeNotDisturb = 13;
/* 日常目标值设置 */
const int kEADataInfoTypeDailyGoal = 15;
/* 自动睡眠监测 */
const int kEADataInfoTypeAutoCheckSleep = 16;
/* 自动心率监测 */
const int kEADataInfoTypeAutoCheckHeartRate = 17;
/* 久坐监测 */
const int kEADataInfoTypeAutoCheckSedentariness = 18;
/* 通用天气 */
const int kEADataInfoTypeWeather = 20;
/* 社交提醒开关 */
const int kEADataInfoTypeSocialSwitch = 21;
/* 提醒 */
const int kEADataInfoTypeReminder = 22;
/* 距离单位 */
const int kEADataInfoTypeDistanceUnit = 24;
/* 重量单位 */
const int kEADataInfoTypeWeightUnit = 25;
/* 心率报警门限 */
const int kEADataInfoTypeHeartRateWaringSetting = 26;
/* 基础卡路里开关 */
const int kEADataInfoTypeCaloriesSetting = 27;
/* 抬手亮屏开关 */
const int kEADataInfoTypeGesturesSetting = 28;
/* 大数据获取命令 */
const int kEADataInfoTypeGetBigData = 29;
/* 设置组合命令 */
const int kEADataInfoTypeWatchSettingInfo = 30;
/* 一级菜单设置命令 */
const int kEADataInfoTypeHomePage = 31;
/* 经期命令 */
const int kEADataInfoTypeMenstrual = 32;
/* 表盘命令 */
const int kEADataInfoTypeWatchFace = 33;
/* 消息推送开关 */
const int kEADataInfoTypeAppMessage = 34;
/* 血压校准值 （老人表）*/
const int kEADataInfoTypeBloodPressure = 36;
/* 自动监测 心率 血氧 血压 （老人表） */
const int kEADataInfoTypeAutoMonitor = 37;
/* 习惯追踪 */
const int kEADataInfoTypeHabitTracker = 38;
/*习惯追踪回应 */
const int kEADataInfoTypeHabitTrackerRespond = 39;
/* 操作手机命令 */
const int kEADataInfoTypePhoneOps = 2001;
/* MTU */
const int kEADataInfoTypeMTU = 2006;
/* 大数据步数 */
const int kEADataInfoTypeStepData = 3001;
/* 大数据睡眠 */
const int kEADataInfoTypeSleepData = 3002;
/* 大数据心率  */
const int kEADataInfoTypeHeartRateData = 3003;
/* 大数据GPS */
const int kEADataInfoTypeGPSData = 3004;
/* 大数据多运动 */
const int kEADataInfoTypeSportsData = 3005;
/* 大数据血氧 */
const int kEADataInfoTypeBloodOxygenData = 3006;
/* 大数据压力 */
const int kEADataInfoTypeStressData = 3007;
/* 大数据步频 */
const int kEADataInfoTypeStepFreqData = 3008;
/* 大数据配速 */
const int kEADataInfoTypeStepPaceData = 3009;
/* 大数据静息心率 */
const int kEADataInfoTypeRestingHeartRateData = 3010;
/* OTA命令 */
const int kEADataInfoTypeOTARequest = 9001;
/* OTA命令回应 */
const int kEADataInfoTypeOTARespond = 9000;

class EAGetData {
  int type = 0;
  Map<String, dynamic> toJson() => {
        'type': type,
      };
}

class EASetData {
  int type = 0;
  String jsonString = "";
  Map<String, dynamic> toJson() => {
        'type': type,
        'jsonString': jsonString,
      };
}
