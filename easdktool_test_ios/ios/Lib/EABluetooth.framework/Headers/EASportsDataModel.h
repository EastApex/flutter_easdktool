//
//  EASportsDataModel.h
//  EABluetooth
//
//  Created by Aye on 2021/3/23.
//

#import <EABluetooth/EABaseBigDataModel.h>

NS_ASSUME_NONNULL_BEGIN


/// 多运动数据
@interface EASportsDataModel : EABaseModel

/// Sport type
/// 运动类型
@property(nonatomic, assign) EASportType eType;

/// begin timestamp
/// 起始时间戳
@property(nonatomic, assign) NSInteger beginTimeStamp;

/// end timestamp
/// 停止时间戳
@property(nonatomic, assign) NSInteger endTimeStamp;

/// steps
/// 步数
@property(nonatomic, assign) NSInteger steps;

/// calorie (cal)
/// 卡路里（单位:小卡)
@property(nonatomic, assign) NSInteger calorie;

/// distance (cm)
/// 距离 （单位:厘米）
@property(nonatomic, assign) NSInteger distance;

/// duration (seconds)
/// 运动时长(单位:秒)
@property(nonatomic, assign) NSInteger duration;


/// Duration of normal heart rate (seconds)
/// 训练效果 正常心率 时长(单位:秒)
@property(nonatomic, assign) NSInteger trainingEffectNormal;

/// Training Effect Warm-up heart rate (seconds)
/// 训练效果 热身心率 时长(单位:秒)
@property(nonatomic, assign) NSInteger trainingEffectWarmUp;

/// Duration of fat consumption for training effect (seconds)
/// 训练效果 消耗脂肪 时长(单位:秒)
@property(nonatomic, assign) NSInteger trainingEffectFatconsumption;

/// Training effect Aerobic heart rate duration (seconds)
/// 训练效果 有氧心率 时长(单位:秒)
@property(nonatomic, assign) NSInteger trainingEffectAerobic;

/// Training effect anaerobic heart rate duration (seconds)
/// 训练效果 无氧心率 时长(单位:秒)
@property(nonatomic, assign) NSInteger trainingEffectAnaerobic;

/// Training effect limit heart rate duration (seconds)
/// 训练效果 极限心率 时长(单位:秒)
@property(nonatomic, assign) NSInteger trainingEffectLimit;

/// average heart rate
/// 平均心率
@property(nonatomic, assign) NSInteger averageHeartRate;

/// Average body temperature (in Celsius)
/// 平均体温（单位：摄氏度）
@property(nonatomic, assign) float averageTemperature;

/// Average speed (unit: KM/H *100 times)
/// 平均速度（单位: KM/H *100倍）
@property(nonatomic, assign) float averageSpeed;

/// Average pace (unit: seconds/km)
/// 平均配速（单位: S/KM）
@property(nonatomic, assign) float averagePace;

/// Average step frequency (in steps per minute)
/// 平均步频（单位: SPM 步每分钟）
@property(nonatomic, assign) float averageStepFreq;

/// Average step distance (unit: cm)
/// 平均步距（单位:厘米）
@property(nonatomic, assign) float averageStride;

/// Average altitude (unit: cm)
/// 平均海拔（单位:厘米）
@property(nonatomic, assign) float averageAltitude;

/// Max heart rate
/// 最大心率
@property(nonatomic, assign) NSInteger averageHeartRateMax;

/// Min heart rate
///最小心率
@property(nonatomic, assign) NSInteger averageHeartRateMin;

/// Number of times [skipping rope]
/// 次数【跳绳】
@property(nonatomic, assign) NSInteger count;

/// ignore：
/// 有效时长【UTE设备特有】
@property (nonatomic,assign) NSInteger validTime;

@end

@interface EAUploadSportsData : EABaseBigDataModel


@property(nonatomic,strong) NSMutableArray<EASportsDataModel*> *sIndexArray;

+ (EAUploadSportsData *)getSportsData:(NSData *)data;


@end

NS_ASSUME_NONNULL_END