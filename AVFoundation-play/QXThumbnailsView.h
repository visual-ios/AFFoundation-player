//
//  QXThumbnailsView.h
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QXThumbnail;

@class QXThumbnailsView;

@protocol QXThumbnailsViewDelegate <NSObject>

- (void)thumbnailsViewSetCurrentTime:(NSTimeInterval)time;

@end


@interface QXThumbnailsView : UIView
@property (nonatomic, weak) id<QXThumbnailsViewDelegate>delegate;

- (void)loadThumbnails:(NSArray <QXThumbnail *>*)thumbnails;

- (void)showView;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
