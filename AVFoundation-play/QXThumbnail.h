//
//  QXThumbnail.h
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
NS_ASSUME_NONNULL_BEGIN

@interface QXThumbnail : NSObject

+ (instancetype)thumbilWithImage:(UIImage *)image time:(CMTime)time;

@property (nonatomic, strong, readonly) UIImage *image;

@property (nonatomic, assign, readonly) CMTime time;
@end

NS_ASSUME_NONNULL_END
