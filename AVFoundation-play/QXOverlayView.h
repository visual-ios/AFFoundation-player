//
//  QXOverlayView.h
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QXOverlayView;

@protocol QXOverlayViewDelegate <NSObject>

- (void)overlayViewDidBack;

- (void)overlayViewDidPlayVideo:(BOOL)isPlay;

- (void)overlayViewDidDownProgressSlider;

- (void)overlayViewDidChangeProgressSliderWithTime:(NSTimeInterval)time;

- (void)overlayViewDidEndProgressSlider;

- (void)overlayViewDidShowThumbnails:(BOOL)isShow;

- (void)overlayViewDidSelectRate;
@end



@interface QXOverlayView : UIView

@property (nonatomic, assign) BOOL isPlayVideo;

@property (nonatomic, weak) id<QXOverlayViewDelegate>delegate;

- (void)showOverlay;

- (void)dismiss;

- (void)setCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration;

//设置倍速播放
- (void)setVideoRate:(NSString *)rate;
@end

NS_ASSUME_NONNULL_END
