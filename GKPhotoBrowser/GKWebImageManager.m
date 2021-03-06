//
//  GKWebImageManager.m
//  GKPhotoBrowser
//
//  Created by QuintGao on 2017/11/14.
//  Copyright © 2017年 QuintGao. All rights reserved.
//

#import "GKWebImageManager.h"
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

@implementation GKWebImageManager

- (void)setImageWithImageView:(FLAnimatedImageView *)imageView url:(NSURL *)url placeholder:(UIImage *)placeholder progress:(gkWebImageProgressBlock)progress completion:(gkWebImageCompletionBlock)completion {
    
    // 进度block
    SDWebImageDownloaderProgressBlock progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        !progress ? : progress(receivedSize, expectedSize);
    };
    
    // 图片加载完成block
    SDExternalCompletionBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        !completion ? : completion(image, imageURL, !error, error);
    };
    
    // 在主线程中加载图片
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageView sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:progressBlock completed:completionBlock];
    });
}

- (void)cancelImageRequestWithImageView:(UIImageView *)imageView {
    [imageView sd_cancelCurrentImageLoad];
}

- (UIImage *)imageFromMemoryForURL:(NSURL *)url {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.imageCache imageFromCacheForKey:key];
}

@end
