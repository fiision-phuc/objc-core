//
//  UIImageView+FwiExtension.h
//  FwiCore
//
//  Created by Phuc, Tran Huu on 4/3/16.
//  Copyright © 2016 Fiision Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FwiCacheFolder.h"


@interface UIImageView (FwiExtension) <FwiCacheFolderDelegate>

/** Download image url. */
- (void)downloadImageURL:(NSString *)imageURL;

@end
