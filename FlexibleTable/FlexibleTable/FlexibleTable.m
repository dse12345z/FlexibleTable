//
//  FlexibleTable.m
//  FlexibleTable
//
//  Created by daisuke on 2016/1/20.
//  Copyright © 2016年 dse12345z. All rights reserved.
//

#import "FlexibleTable.h"
#import "UIView+Category.h"
#import <objc/runtime.h>

@interface FlexibleTable ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *views;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat maxOffsetY;
@property (nonatomic, assign) CGFloat minOffsetY;

@end

@implementation FlexibleTable
@synthesize minOffsetY = _minOffsetY;

+ (void)initWithScrollView:(UIScrollView *)scrollView views:(NSArray *)views minOffsetY:(CGFloat)minOffsetY {
    [self initWithScrollView:scrollView views:views minOffsetY:minOffsetY flexibleTableHeight:0.0f];
}

+ (void)initWithScrollView:(UIScrollView *)scrollView views:(NSArray *)views minOffsetY:(CGFloat)minOffsetY flexibleTableHeight:(CGFloat)flexibleTableHeight {
    if (!objc_getAssociatedObject(scrollView, _cmd)) {
        // create FlexibleTable
        FlexibleTable *flexibleTable = [FlexibleTable new];
        objc_setAssociatedObject(scrollView, _cmd, flexibleTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // caculate sum height
        __block CGFloat viewsHeight = flexibleTableHeight;
        if (!viewsHeight) {
            [views enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock: ^(UIView *view, NSUInteger index, BOOL *stop) {
                viewsHeight += CGRectGetHeight(view.frame);
            }];
        }
        
        // create backgroundView
        flexibleTable.backgroundView = [UIView new];
        flexibleTable.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(scrollView.frame), viewsHeight);
        flexibleTable.backgroundView.backgroundColor = [UIColor colorWithRed:0.31 green:0.42 blue:0.64 alpha:1];
        flexibleTable.maxOffsetY = 0.0f;
        flexibleTable.minOffsetY = minOffsetY ? : CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        flexibleTable.scrollView = scrollView;
        
        // add views on scrollView superview
        [views enumerateObjectsWithOptions:NSEnumerationReverse usingBlock: ^(UIView *view, NSUInteger index, BOOL *stop) {
            [flexibleTable.backgroundView addSubview:view];
            [view addAutoLayoutFrom:flexibleTable.backgroundView];
        }];
        [scrollView.superview addSubview:flexibleTable.backgroundView];
        [flexibleTable.backgroundView addWidthAutoLayoutFrom:scrollView.superview];
        
        // setup scrollView contentInset with viewsHeight
        scrollView.contentInset = UIEdgeInsetsMake(viewsHeight, 0.0f, 0.0f, 00.0f);
        
        // addObserver scrollView scrolling
        [scrollView addObserver:flexibleTable forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UIScrollView *scrollView = (UIScrollView *)object;
        
        if (!(scrollView.contentOffset.y >= self.minOffsetY)) {
            return;
        }
        
        __weak typeof(self) weakSelf = self;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // init offsetY
            weakSelf.offsetY = scrollView.contentOffset.y;
        });
        
        // change backgroundView origin y
        CGFloat offset = self.offsetY - scrollView.contentOffset.y;
        CGRect newFrame = self.backgroundView.frame;
        BOOL isScrollUp = CGRectGetMinY(self.backgroundView.frame) < 0;
        BOOL isScrollDown = CGRectGetMinY(self.backgroundView.frame) > self.minOffsetY;
        if (isScrollUp && offset > 0) {
            newFrame.origin.y = MIN(0, newFrame.origin.y + offset);
        }
        else if (isScrollDown && offset < 0) {
            newFrame.origin.y = MAX(self.minOffsetY, newFrame.origin.y + offset);
        }
        self.backgroundView.frame = newFrame;
        self.offsetY = scrollView.contentOffset.y;
        
        // self.backgroundView.subviews obj alpha
        for (UIView *view in self.backgroundView.subviews) {
            view.alpha = (self.minOffsetY - self.backgroundView.frame.origin.y) / self.minOffsetY;
        }
    }
}

#pragma mark - setter/getter

- (void)setMinOffsetY:(CGFloat)minOffsetY {
    _minOffsetY = minOffsetY - CGRectGetHeight(self.backgroundView.frame);
}

#pragma mark - life cycle

- (void)dealloc {
    // removeObserver
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
