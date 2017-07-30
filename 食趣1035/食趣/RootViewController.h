//
//  RootViewController.h
//  食趣
//
//  Created by 汤汤 on 15/10/18.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
- (void)addTitleView:(NSString *)title;
- (void)addButtonWithText:(NSString *)text andImage:(NSString *)imageName andSelector:(SEL)selector andLocation:(BOOL)isLeft;
@end
