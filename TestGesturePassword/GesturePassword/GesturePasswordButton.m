//
//  GesturePasswordButton.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "GesturePasswordButton.h"

#define bounds self.bounds

@implementation GesturePasswordButton
@synthesize selected;
@synthesize success;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        success=YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (selected) {
        if (success) {
            CGContextSetStrokeColor(context, CGColorGetComponents(kSuccessStrokeColor.CGColor));
            CGContextSetFillColor(context, CGColorGetComponents(kSuccessStrokeColor.CGColor));
        }
        else {
            CGContextSetStrokeColor(context, CGColorGetComponents(kFailureStrokeColor.CGColor));
            CGContextSetFillColor(context, CGColorGetComponents(kFailureStrokeColor.CGColor));
        }
        CGRect frame = CGRectMake(bounds.size.width/2-bounds.size.width/8+1, bounds.size.height/2-bounds.size.height/8, bounds.size.width/4, bounds.size.height/4);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    else{
        CGContextSetStrokeColor(context, CGColorGetComponents(kInitialStrokeColor.CGColor));
    }
    
    CGContextSetLineWidth(context,2);
    CGRect frame = CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    if (success) {
        CGContextSetFillColor(context, CGColorGetComponents(kSuccessFillColor.CGColor));
    }
    else {
        CGContextSetFillColor(context, CGColorGetComponents(kFailureFillColor.CGColor));
    }
    CGContextAddEllipseInRect(context,frame);
    if (selected) {
        CGContextFillPath(context);
    }
}


@end
