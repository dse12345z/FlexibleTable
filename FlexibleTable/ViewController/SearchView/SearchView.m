//
//  SearchView.m
//  FlexibleTable
//
//  Created by daisuke on 2016/1/22.
//  Copyright © 2016年 dse12345z. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

#pragma mark - life cycle

- (id)initFromXib {
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self = arrayOfViews[0];
    if (self) {
    }
    return self;
}

@end
