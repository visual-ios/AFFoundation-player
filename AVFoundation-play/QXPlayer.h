//
//  QXPlayer.h
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/8.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class QXPlayer,QXThumbnail;

@protocol QXPlayerDelegate <NSObject>

@optional

/**
 进度发生变化
 time:当前播放时长
 duration:总时长
 */
- (void)playerDidChangeTime:(NSTimeInterval)time withAssertDuration:(NSTimeInterval)duration;

/**
 获取视频的可视化截图（多张）
 */
- (void)playerDidGenerateThumbnails:(NSArray <QXThumbnail *>*)thumbnails;
@end


@interface QXPlayer : NSObject
- (instancetype)initWithURL:(NSURL *)assetURL;

@property (nonatomic, strong, readonly) AVPlayer *player;

@property (nonatomic, weak) id<QXPlayerDelegate>delegate;

@property (nonatomic, assign, readonly) CGFloat playRate;

//开始拖动进度条
- (void)progressSliderDidStartChange;
//跳转到某个进度
- (void)progressSliderSeekToTime:(NSTimeInterval)time;
//结束拖动
- (void)progressSliderDidEnd;

//设置倍速播放
- (void)setPlayRate:(CGFloat)playRate;

- (void)play;
- (void)pause;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
