//
//  QXThumbnail.m
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/11.
//

#import "QXThumbnail.h"

@implementation QXThumbnail

+ (instancetype)thumbilWithImage:(UIImage *)image time:(CMTime)time
{
    return [[self alloc] initWithImage:image time:time];
}

- (instancetype)initWithImage:(UIImage *)image time:(CMTime)time
{
    self = [super init];
    if (self) {
        _image = image;
        _time = time;
    }
    return self;
}
@end
