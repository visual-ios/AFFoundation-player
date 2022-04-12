//
//  QXThumbnailsView.m
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/11.
//

#import "QXThumbnailsView.h"
#import "QXThumbnail.h"

@interface QXThumbnailsView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSArray <QXThumbnail *>* thumbnails;
@end

@implementation QXThumbnailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.scrollView];
        
        self.transform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height);
    }
    return self;
}

- (void)loadThumbnails:(NSArray<QXThumbnail *> *)thumbnails
{
    self.thumbnails = thumbnails;
    CGFloat currentX = 0.0f;
    if (thumbnails.count <= 0) return;
    
    QXThumbnail *thumbnail = thumbnails.firstObject;
    CGSize size = thumbnail.image.size;
    // Scale retina image down to appropriate size
    CGFloat imageH = self.frame.size.height;
    CGFloat imageW = size.width * imageH / size.height;
    CGRect imageRect = CGRectMake(currentX, 0, imageW, imageH);

    CGFloat imageWidth = CGRectGetWidth(imageRect) * thumbnails.count;
    self.scrollView.contentSize = CGSizeMake(imageWidth, imageRect.size.height);

    for (NSUInteger i = 0; i < thumbnails.count; i++) {
        QXThumbnail *timedImage = thumbnails[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        [button setBackgroundImage:timedImage.image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(currentX, 0, imageW, imageH);
        button.tag = i;
        [self.scrollView addSubview:button];
        currentX += imageW;
    }
}

- (void)imageButtonTapped:(UIButton *)sender {
    QXThumbnail *image = self.thumbnails[sender.tag];
    if (image && [_delegate respondsToSelector:@selector(thumbnailsViewSetCurrentTime:)]) {
        [_delegate thumbnailsViewSetCurrentTime:CMTimeGetSeconds(image.time)];
    }
}

- (void)showView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height);
    }];
}
@end
