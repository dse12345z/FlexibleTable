//
//  FlexibleTable.h
//  FlexibleTable
//
//  Created by daisuke on 2016/1/20.
//  Copyright © 2016年 dse12345z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FlexibleTable : NSObject

+ (void)initWithScrollView:(UIScrollView *)scrollView views:(NSArray *)views minOffsetY:(CGFloat)minOffsetY;
+ (void)initWithScrollView:(UIScrollView *)scrollView views:(NSArray *)views minOffsetY:(CGFloat)minOffsetY flexibleTableHeight:(CGFloat)flexibleTableHeight;

@end
