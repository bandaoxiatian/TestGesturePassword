//
//  TentacleView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "TentacleView.h"
#import "GesturePasswordButton.h"

@implementation TentacleView {
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
    NSMutableArray<NSDictionary *> * touchesButtons;
    NSMutableArray<NSString *> * touchedTags;
    BOOL success;
}
@synthesize buttonArray;
@synthesize rerificationDelegate;//验证的代理，手势输入完毕后交给vc判断结果时启用的代理
@synthesize resetDelegate;//重置的代理
@synthesize changeDelegate;//更改手势密码的代理
@synthesize touchBeginDelegate;
@synthesize style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        touchesButtons = [[NSMutableArray alloc]initWithCapacity:0];
        touchedTags = [[NSMutableArray alloc]initWithCapacity:0];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        success = 1;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%s", __FUNCTION__);
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    [touchesButtons removeAllObjects];
    [touchedTags removeAllObjects];
    [touchBeginDelegate gestureTouchBegin];
    success=1;
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i=0; i<buttonArray.count; i++) {
            GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
            [buttonTemp setSuccess:YES];
            [buttonTemp setSelected:NO];
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2);
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y", nil];
                [touchesButtons addObject:dict];
                lineStartPoint = touchPoint;
            }
            [buttonTemp setNeedsDisplay];
        }
        
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%s", __FUNCTION__);
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i=0; i<buttonArray.count; i++) {
            GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                if ([touchedTags containsObject:[NSString stringWithFormat:@"num%d",i]]) {
                    lineEndPoint = touchPoint;
                    [self setNeedsDisplay];
                    return;
                }
                [touchedTags addObject:[NSString stringWithFormat:@"num%d",i]];
                [buttonTemp setSelected:YES];
                [buttonTemp setNeedsDisplay];
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2);
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y",[NSString stringWithFormat:@"%d",i],@"num", nil];
                [touchesButtons addObject:dict];
                break;
            }
        }
        lineEndPoint = touchPoint;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%s", __FUNCTION__);
    NSMutableString * resultString=[NSMutableString string];
    for ( NSDictionary * num in touchesButtons ){
        if(![num objectForKey:@"num"])break;
        [resultString appendString:[num objectForKey:@"num"]];
    }
    NSLog(@"resultString:%@", resultString);
    
    for (int i=0; i<touchesButtons.count; i++) {
        NSInteger selection = [[[touchesButtons objectAtIndex:i] objectForKey:@"num"]intValue];
        GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:selection]);
        [buttonTemp setSuccess:success];
        [buttonTemp setNeedsDisplay];
    }
    [self setNeedsDisplay];
    
    if(style==1){
        success = [rerificationDelegate verification:resultString];
    }
    else if(style == 2) {
        success = [resetDelegate resetPassword:resultString];
    }else{
        success = [changeDelegate changePassword:resultString];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    if (touchesArray.count<2)return;
    for (int i=0; i<touchesButtons.count; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (![[touchesButtons objectAtIndex:i] objectForKey:@"num"]) { //防止过快滑动产生垃圾数据
            [touchesButtons removeObjectAtIndex:i];
            continue;
        }
        if (success) {
            CGContextSetRGBStrokeColor(context, 2/255.f, 174/255.f, 240/255.f, 0.7);//线条颜色
        }
        else {
            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f, 0.7);//红色
        }
        
        CGContextSetLineWidth(context,5);
        CGContextMoveToPoint(context, [[[touchesButtons objectAtIndex:i] objectForKey:@"x"] floatValue], [[[touchesButtons objectAtIndex:i] objectForKey:@"y"] floatValue]);
        if (i<touchesButtons.count-1) {
            CGContextAddLineToPoint(context, [[[touchesButtons objectAtIndex:i+1] objectForKey:@"x"] floatValue],[[[touchesButtons objectAtIndex:i+1] objectForKey:@"y"] floatValue]);
        }
        else{
            if (success) {
                CGContextAddLineToPoint(context, lineEndPoint.x,lineEndPoint.y);
            }
        }
        CGContextStrokePath(context);
    }
}

- (void)enterArgin {
    [touchesButtons removeAllObjects];
    [touchedTags removeAllObjects];
    for (int i=0; i<buttonArray.count; i++) {
        GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
        [buttonTemp setSelected:NO];
        [buttonTemp setSuccess:YES];
        [buttonTemp setNeedsDisplay];
    }
    
    [self setNeedsDisplay];
}

@end
