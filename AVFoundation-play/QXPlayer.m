//
//  QXPlayer.m
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/8.
//

#import "QXPlayer.h"
#import "QXThumbnail.h"

static const NSString *PlayerItemStatusContext;

@interface QXPlayer()
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong, readwrite) AVPlayer *player;
@property (strong, nonatomic) id timeObserver;
@end

@implementation QXPlayer

- (instancetype)initWithURL:(NSURL *)assetURL
{
    self = [super init];
    if (self) {
        _asset = [AVAsset assetWithURL:assetURL];
        _playRate = 1.f;
        [self prepareToPlay];
    }
    return self;
}

- (void)prepareToPlay {
    NSArray *keys = @[
        @"tracks",
        @"duration",
        @"commonMetadata",
        @"availableMediaCharacteristicsWithMediaSelectionOptions"
    ];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
    [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:&PlayerItemStatusContext];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if (context == &PlayerItemStatusContext) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                
                [self addPlayerItemTimeOberver];
                
                CMTime duration = self.playerItem.duration;
                [self.delegate playerDidChangeTime:CMTimeGetSeconds(kCMTimeZero) withAssertDuration:CMTimeGetSeconds(duration)];
                
                [self.player play];
                
                [self generateThumbnails];
            }
        });
    }
}

- (void)setPlayRate:(CGFloat)playRate
{
    _playRate = playRate;
    self.player.rate = playRate;
}

- (void)play
{
    [self.player play];
    self.player.rate = _playRate;
}

- (void)pause
{
    [self.player pause];
}

- (void)stop
{
    [self progressSliderDidStartChange];
    self.player = nil;
}

- (void)progressSliderDidStartChange
{
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
}

- (void)progressSliderSeekToTime:(NSTimeInterval)time
{
    [self.playerItem cancelPendingSeeks];
//    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)progressSliderDidEnd
{
    [self addPlayerItemTimeOberver];
    [self.player play];
    self.player.rate = _playRate;
}

#pragma mark - private methods
- (void)addPlayerItemTimeOberver
{
    CMTime interval = CMTimeMakeWithSeconds(0.5f, NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __weak typeof(self)weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:queue usingBlock:^(CMTime time) {
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        [weakSelf.delegate playerDidChangeTime:currentTime withAssertDuration:duration];
    }];
}

- (void)generateThumbnails
{
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    
    imageGenerator.maximumSize = CGSizeMake(200, 0);
    
    CMTime duration = self.asset.duration;
    
    NSMutableArray *times = [NSMutableArray array];
    
    CMTimeValue increment = duration.value / 20;
    CMTimeValue currentValue = 2.0 * duration.timescale;
    while (currentValue <= duration.value) {
        CMTime time = CMTimeMake(currentValue, duration.timescale);
        [times addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment;
    }
    
    __block NSInteger imageCount = times.count;
    __block NSMutableArray *images = [NSMutableArray array];
    
    //如果是想获取单张可以使用copyCGImageAtTime:(CMTime)requestedTime actualTime:(nullable CMTime *)actualTime error:(NSError * _Nullable * _Nullable)outError
    
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable imageRef, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            QXThumbnail *thumbnail = [QXThumbnail thumbilWithImage:image time:actualTime];
            [images addObject:thumbnail];
        } else {
            NSLog(@"Error:%@",error.localizedDescription);
        }
        if (--imageCount == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate playerDidGenerateThumbnails:[images copy]];
            });
        }
    }];
}
@end
