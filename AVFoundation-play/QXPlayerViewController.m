//
//  QXPlayerViewController.m
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/8.
//

#import "QXPlayerViewController.h"
#import "QXPlayerView.h"
#import "QXOverlayView.h"
#import "QXPlayer.h"
#import "QXThumbnailsView.h"
@interface QXPlayerViewController ()<QXOverlayViewDelegate,QXPlayerDelegate,QXThumbnailsViewDelegate>
@property (nonatomic, strong) QXPlayer *player;
@property (nonatomic, strong) QXPlayerView *playerView;
@property (nonatomic, strong) QXOverlayView *overlayView;
@property (nonatomic, strong) QXThumbnailsView *thumbnailsView;
@property (nonatomic, assign) BOOL isShowOverlay;
@property (nonatomic, assign) BOOL isShowThumbnail;
@end

@implementation QXPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.transform = CGAffineTransformMakeRotation(M_PI / 2);

    [self setupUI];
    [self addGesture];
    
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)setupUI
{
    
    _player = [[QXPlayer alloc] initWithURL:self.assetURL];
    _player.delegate = self;
    
    _playerView = [[QXPlayerView alloc] initWithPlayer:_player.player];
    _playerView.frame = self.view.bounds;
    [self.view addSubview:_playerView];
    
    _overlayView = [[NSBundle mainBundle] loadNibNamed:@"QXOverlayView" owner:self options:nil].firstObject;
    _overlayView.frame = self.view.bounds;
    _overlayView.delegate = self;
    [self.view addSubview:_overlayView];
    
    _thumbnailsView = [[QXThumbnailsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    _thumbnailsView.delegate = self;
    [self.view addSubview:_thumbnailsView];
}



#pragma mark - 时长改变
- (void)playerDidChangeTime:(NSTimeInterval)time withAssertDuration:(NSTimeInterval)duration
{
    [_overlayView setCurrentTime:time duration:duration];
}

#pragma mark - 获取可视化截图
- (void)overlayViewDidShowThumbnails:(BOOL)isShow
{
    _isShowThumbnail = YES;
    [_thumbnailsView showView];
}
- (void)playerDidGenerateThumbnails:(NSArray<QXThumbnail *> *)thumbnails
{
    [_thumbnailsView loadThumbnails:thumbnails];
}
- (void)thumbnailsViewSetCurrentTime:(NSTimeInterval)time
{
    [_thumbnailsView dismiss];
    [_player progressSliderSeekToTime:time];
}

#pragma mark - 拖动进度条
- (void)overlayViewDidDownProgressSlider
{
    [_player progressSliderDidStartChange];
}

- (void)overlayViewDidChangeProgressSliderWithTime:(NSTimeInterval)time
{
    [_player progressSliderSeekToTime:time];
}

- (void)overlayViewDidEndProgressSlider
{
    [_player progressSliderDidEnd];
}

#pragma mark - 倍速
- (void)overlayViewDidSelectRate
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择倍速" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *halfAction = [UIAlertAction actionWithTitle:@"0.5" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didChangeRate:action.title];
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"1.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didChangeRate:action.title];
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"2.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didChangeRate:action.title];
    }];
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"3.0" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didChangeRate:action.title];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:halfAction];
    [alertVC addAction:defaultAction];
    [alertVC addAction:secondAction];
    [alertVC addAction:thirdAction];
    [alertVC addAction:cancelAction];
    alertVC.view.transform = self.view.transform;
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)didChangeRate:(NSString *)rate
{
    [_overlayView setVideoRate:rate];
    [_player setPlayRate:[rate floatValue]];
}

- (void)addGesture
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOverlayView)];
    [self.view addGestureRecognizer:tapGR];
}


- (void)showOverlayView
{
    if (_isShowOverlay) {
        [_overlayView dismiss];
    } else {
        [_overlayView showOverlay];
    }
    _isShowOverlay = !_isShowOverlay;
    
    if (_isShowThumbnail) {
        _isShowThumbnail = NO;
        [_thumbnailsView dismiss];
    }
}

- (void)overlayViewDidPlayVideo:(BOOL)isPlay
{
    if (isPlay) {
        [_player play];
    } else {
        [_player pause];
    }
}

- (void)overlayViewDidBack
{
    [self.player stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
