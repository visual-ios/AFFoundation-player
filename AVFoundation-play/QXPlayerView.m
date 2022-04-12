//
//  QXPlayerView.m
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/8.
//

#import "QXPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface QXPlayerView()

@end

@implementation QXPlayerView

- (instancetype)initWithPlayer:(AVPlayer *)player
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [(AVPlayerLayer *)[self layer] setPlayer:player];
        
    }
    return self;
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}


@end
