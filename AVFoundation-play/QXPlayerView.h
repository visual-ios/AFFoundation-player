//
//  QXPlayerView.h
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVPlayer;

@interface QXPlayerView : UIView

- (instancetype)initWithPlayer:(AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
