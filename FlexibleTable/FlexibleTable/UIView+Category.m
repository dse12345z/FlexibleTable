//
//  UIView+Category.m
//  FlexibleTable
//
//  Created by daisuke on 2016/1/21.
//  Copyright © 2016年 dse12345z. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (void)addWidthAutoLayoutFrom:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    // value
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    NSString *widthLayout = [NSString stringWithFormat:@"H:|-0-[view(>=%f)]-0-|", width];
    NSString *heightLayout = [NSString stringWithFormat:@"V:|-0-[view(==%f)]-(>=%f)-|", height, viewHeight - height];
    
    // add autolayout
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthLayout options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"view" : self }]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightLayout options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"view" : self }]];
}

- (void)addAutoLayoutFrom:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *widthLayout = [NSString stringWithFormat:@"H:|-0-[view(>=%f)]-0-|", CGRectGetWidth(self.frame)];
    NSString *heightLayout = [NSString stringWithFormat:@"V:|-(>=%f)-[view(==%f)]-(>=%f)-|", CGRectGetMinX(self.frame), CGRectGetHeight(self.frame), CGRectGetHeight(view.frame) - CGRectGetMaxY(self.frame)];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthLayout options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"view" : self }]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightLayout options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"view" : self }]];
}

@end
