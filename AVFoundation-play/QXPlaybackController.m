//
//  QXPlaybackController.m
//  AVFoundation-play
//
//  Created by 秦菥 on 2022/4/8.
//

#import "QXPlaybackController.h"
#import "QXPlayerViewController.h"

@interface QXPlaybackController ()
@property (nonatomic, strong) NSURL *localURL;
@property (nonatomic, strong) NSURL *streamingURL;
@end

@implementation QXPlaybackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.streamingURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//    self.streamingURL = [NSURL URLWithString:@"https://v.youku.com/v_show/id_XNTg1NzQyNjMxMg==.html?sharefrom=iphone&sharekey=5f984a7ae0b64df8cc77fe287f7da7e00"];

    [self addGesture];
}

- (void)addGesture
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentPlayerController)];
    [self.view addGestureRecognizer:tapGR];
}
- (void)presentPlayerController
{
    QXPlayerViewController *playerVC = [[QXPlayerViewController alloc] init];
    playerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    playerVC.assetURL = self.streamingURL;
    [self presentViewController:playerVC animated:YES completion:nil];
}


@end
