//
//  DALinedTextView.m
//  DALinedTextView
//
//  Created by Daniel Amitay on 5/12/13.
//  Copyright (c) 2013 Daniel Amitay. All rights reserved.
//

#import "DALinedTextView.h"

#define DEFAULT_HORIZONTAL_COLOR    [UIColor colorWithRed:0.722f green:0.910f blue:0.980f alpha:0.7f]
#define DEFAULT_VERTICAL_COLOR      [UIColor colorWithRed:0.957f green:0.416f blue:0.365f alpha:0.7f]
#define DEFAULT_MARGINS             UIEdgeInsetsMake(10.0f, 10.0f, 0.0f, 10.0f)

@implementation DALinedTextView

+ (void)initialize
{
    if (self == [DALinedTextView class])
    {
        id appearance = [self appearance];
        [appearance setContentMode:UIViewContentModeRedraw];
        [appearance setHorizontalLineColor:DEFAULT_HORIZONTAL_COLOR];
        [appearance setVerticalLineColor:DEFAULT_VERTICAL_COLOR];
        [appearance setMargins:DEFAULT_MARGINS];
    }
}

#pragma mark - Superclass overrides

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        UIFont *font = self.font;
        self.font = nil;
        self.font = font;
        
        self.margins = [self.class.appearance margins];
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize
{
    contentSize = (CGSize) {
        .width = contentSize.width - self.margins.left - self.margins.right,
        .height = MAX(contentSize.height, self.bounds.size.height - self.margins.top)
    };
    [super setContentSize:contentSize];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    
    if (self.horizontalLineColor)
    {
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, self.horizontalLineColor.CGColor);
        CGFloat baseOffset = 8.0f + self.font.descender;
        CGFloat screenScale = [UIScreen mainScreen].scale;
        NSInteger firstVisibleLine = MAX(1, (self.contentOffset.y / self.font.lineHeight));
        NSInteger lastVisibleLine = ceilf((self.contentOffset.y + self.bounds.size.height) / self.font.lineHeight);
        for (NSInteger line = firstVisibleLine; line <= lastVisibleLine; ++line)
        {
            CGFloat linePointY = roundf((baseOffset + (self.font.lineHeight * line)) * screenScale) / screenScale;
            CGContextMoveToPoint(context, self.bounds.origin.x, linePointY);
            CGContextAddLineToPoint(context, self.bounds.size.width, linePointY);
        }
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
    if (self.verticalLineColor)
    {
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, self.verticalLineColor.CGColor);
        CGContextMoveToPoint(context, -1.0f, self.contentOffset.y);
        CGContextAddLineToPoint(context, -1.0f, self.contentOffset.y + self.bounds.size.height);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

#pragma mark - Property methods

- (void)setHorizontalLineColor:(UIColor *)horizontalLineColor
{
    _horizontalLineColor = horizontalLineColor;
    [self setNeedsDisplay];
}

- (void)setVerticalLineColor:(UIColor *)verticalLineColor
{
    _verticalLineColor = verticalLineColor;
    [self setNeedsDisplay];
}

- (void)setMargins:(UIEdgeInsets)margins
{
    _margins = margins;
    self.contentInset = (UIEdgeInsets) {
        .top = self.margins.top,
        .left = self.margins.left,
        .bottom = self.margins.bottom,
        .right = self.margins.right - self.margins.left
    };
    [self setContentSize:self.contentSize];
}

@end
