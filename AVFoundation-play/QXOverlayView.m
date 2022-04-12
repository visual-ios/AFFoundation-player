//
//  QXOverlayView.m
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/11.
//

#import "QXOverlayView.h"

@interface QXOverlayView()
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *showThumbBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTImeLab;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;

@end

@implementation QXOverlayView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.topBar.alpha = 0.f;
    self.bottomBar.alpha = 0.f;
    self.isPlayVideo = YES;
}

- (IBAction)cancelBtnDidClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(overlayViewDidBack)]) {
        [_delegate overlayViewDidBack];
    }
}
- (IBAction)showBtnDidClicked:(UIButton *)sender {
//    sender.selected = !sender.selected;
    if ([_delegate respondsToSelector:@selector(overlayViewDidShowThumbnails:)]) {
        [_delegate overlayViewDidShowThumbnails:YES];
    }
}
- (IBAction)playBtnDidClicked:(UIButton *)sender {
    
    self.isPlayVideo = !_isPlayVideo;
    
    if ([_delegate respondsToSelector:@selector(overlayViewDidPlayVideo:)]) {
        [_delegate overlayViewDidPlayVideo:_isPlayVideo];
    }
}

- (IBAction)progressViewDidDown:(UISlider *)sender {
    if ([_delegate respondsToSelector:@selector(overlayViewDidDownProgressSlider)]) {
        [_delegate overlayViewDidDownProgressSlider];
    }
}

- (IBAction)progressViewDidChanged:(UISlider *)sender {
    if ([_delegate respondsToSelector:@selector(overlayViewDidChangeProgressSliderWithTime:)]) {
        self.startTimeLab.text = [self formatSeconds:sender.value];
        [_delegate overlayViewDidChangeProgressSliderWithTime:sender.value];
    }
}
- (IBAction)progressViewDidEndChange:(UISlider *)sender {
    if ([_delegate respondsToSelector:@selector(overlayViewDidEndProgressSlider)]) {
        [_delegate overlayViewDidEndProgressSlider];
    }
}


- (void)setIsPlayVideo:(BOOL)isPlayVideo
{
    _isPlayVideo = isPlayVideo;
    _playBtn.selected = isPlayVideo;
}

#pragma mark - public methods
- (void)showOverlay
{
    [UIView animateWithDuration:0.3 animations:^{
        self.topBar.alpha = 0.7f;
        self.bottomBar.alpha = 0.7f;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.topBar.alpha = 0.f;
        self.bottomBar.alpha = 0.f;
    }];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    NSInteger currentSeconds = ceilf(currentTime);
    
    self.startTimeLab.text = [self formatSeconds:currentSeconds];
    self.endTImeLab.text = [self formatSeconds:duration];
    
    self.progressSlider.minimumValue = 0.f;
    self.progressSlider.maximumValue = duration;
    self.progressSlider.value = currentTime;
}

- (NSString *)formatSeconds:(NSInteger)value {
    NSInteger seconds = value % 60;
    NSInteger minutes = value / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long) minutes, (long) seconds];
}


- (IBAction)rateBtnDidClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(overlayViewDidSelectRate)]) {
        [_delegate overlayViewDidSelectRate];
    }
}

- (void)setVideoRate:(NSString *)rate
{
    [self.rateBtn setTitle:rate forState:UIControlStateNormal];
    self.isPlayVideo = YES;//设置倍速会自动播放
}

@end
