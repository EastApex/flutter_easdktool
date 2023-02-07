package com.example.easdktool;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.alibaba.fastjson.JSONObject;
import com.apex.bluetooth.callback.OtaCallback;
import com.apex.bluetooth.core.EABleManager;
import com.apex.bluetooth.model.EABleOta;
import com.apex.bluetooth.utils.LogUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class OTAFunction {
    private MethodChannel channel;
    final String kProgress = "Progress";
    private final String TAG = this.getClass().getSimpleName();

    public OTAFunction(MethodChannel channel) {
        this.channel = channel;
    }

    private List<EABleOta> getOtaInfo(Map<String, Object> map) {
        List<JSONObject> wArray = (List<JSONObject>) map.get("otas");
        if (wArray != null && !wArray.isEmpty()) {
            List<EABleOta> otaDataList = new ArrayList<>();
            for (int i = 0; i < wArray.size(); i++) {
                JSONObject wMap = wArray.get(i);
                EABleOta tempOtaData = new EABleOta();
                tempOtaData.version = wMap.getString("version");
                int type = wMap.getInteger("firmwareType");
                if (type == 0) {
                    tempOtaData.otaType = EABleOta.OtaType.apollo;
                } else if (type == 1) {
                    tempOtaData.otaType = EABleOta.OtaType.res;
                } else if (type == 2) {
                    tempOtaData.otaType = EABleOta.OtaType.hr;
                } else if (type == 3) {
                    tempOtaData.otaType = EABleOta.OtaType.tp;
                } else if (type == 4) {
                    tempOtaData.otaType = EABleOta.OtaType.user_wf;
                }
                tempOtaData.setFilePath(wMap.getString("binPath"));
                otaDataList.add(tempOtaData);

            }
            return otaDataList;
        }
        return null;
    }

    public void startOta(Map<String, Object> map) {
        List<EABleOta> otaList = getOtaInfo(map);
        if (otaList != null && !otaList.isEmpty()) {
            EABleManager.getInstance().otaUpdate(otaList, new OtaCallback() {
                @Override
                public void success() {
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            if (channel != null) {
                                channel.invokeMethod(kProgress, 100);
                            }
                        }
                    });

                }

                @Override
                public void progress(int i) {
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            LogUtils.i(TAG, "当前进度:" + i);
                            if (channel != null) {
                                channel.invokeMethod(kProgress, i);
                            }
                        }
                    });

                }

                @Override
                public void mutualFail(int i) {
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            if (channel != null) {
                                channel.invokeMethod(kProgress, -1);
                            }
                        }
                    });

                }
            });
        } else {
            if (channel != null) {
                channel.invokeMethod(kProgress, -1);
            }
        }
    }
}
