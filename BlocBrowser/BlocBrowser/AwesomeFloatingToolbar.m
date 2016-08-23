//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Jordan Johnson on 7/21/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"
#import <WebKit/Webkit.h>

#define kWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")


@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
//@property (nonatomic, strong) NSArray *labels;
//@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation AwesomeFloatingToolbar


- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] initWithCapacity:4];
        
        // Make the 4 buttons
        for (NSString *currentTitle in self.currentTitles) {
            
            //create button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = NO;
            button.alpha = 1;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisButton = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisButton = [self.colors objectAtIndex:currentTitleIndex];
            
            //define attributes of button
            
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            //[button setFont:[UIFont systemFontofSize:10]];
            //button.titleLabel.text = titleForThisButton;
            [button setTitle:titleForThisButton forState:UIControlStateNormal];
            //work here for setting text
            [button setBackgroundColor:colorForThisButton];
            //button.backgroundColor = colorForThisButton;
            //button.tintColor = [UIColor whiteColor];
            [button setTintColor:[UIColor whiteColor]];
            
            //define button actions
//            NSString *actionForThisButton = [[NSString alloc] init];
//            if ([button.titleLabel isEqual:kWebBrowserBackString]) {
//                actionForThisButton = [self.webView goBack];
//            } else if ([button.titleLabel isEqual:kWebBrowserForwardString]) {
//                actionForThisButton = [self.webView goForward];
//            } else if ([button.titleLabel isEqual:kWebBrowserStopString]) {
//                actionForThisButton = [self.webView stopLoading];
//            } else if ([button.titleLabel isEqual:kWebBrowserRefreshString]) {
//                actionForThisButton = [self.webView reload];
//            }
            
            //set button action
            [button addTarget:self action:@selector(awesomeFloatingToolbar:didSelectButtonWithTitle:) forControlEvents:UIControlEventTouchUpInside];
            //[button addTarget:self action:@selector(setEnabled:) forControlEvents:UIControlEventTouchUpInside];
 
            //[button addTarget:self action:@selector([self.webView reload]:) forControlEvents:UIControlEventTouchUpInside];
            //[button addTarget:self action:@selector(actionForThisButton:) forControlEvents:UIControlEventTouchUpInside];
            
            
            //add each button to the button array
            [buttonsArray addObject:button];
        }
        
        self.buttons = buttonsArray;
        
        //display buttons
        for (UIButton *thisButton in buttonsArray) {
            [self addSubview:thisButton];
        }
        
        //gesture actions
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    return self;
}

#pragma mark -  Gesture Handling

- (void) tapFired:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];
        
        if ([self.buttons containsObject:tappedView]) {
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UIButton *)tappedView).titleLabel.text];
            }
        }
    }
}

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}


- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = recognizer.scale;
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchWithScale:)]) {
            [self.delegate floatingToolbar:self didTryToPinchWithScale:scale];
        }
    }
}

- (void)setColorsForButtons {
    for (UIButton *button in self.buttons) {
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:button];
        UIColor *colorForThisButton = [self.colors objectAtIndex:currentButtonIndex];
        
        button.backgroundColor = colorForThisButton;
        
    }
}

- (void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
    NSMutableArray *mutableColorArray = [self.colors mutableCopy];

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        //randomize color array
        for (NSInteger i = mutableColorArray.count-1; i > 0; i--) {
            [mutableColorArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(4)];
        }

        self.colors = mutableColorArray;
        [self setColorsForButtons];
    }

}


- (void) layoutSubviews {
    // set the frames for the 4 labels

    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];
        
        CGFloat buttonHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat buttonWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
        
        // adjust labelX and labelY for each label
        if (currentButtonIndex < 2) {
            // 0 or 1, so on top
            buttonY = 0;
        } else {
            // 2 or 3, so on bottom
            buttonY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentButtonIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            buttonX = 0;
        } else {
            // 1 or 3, so on the right
            buttonX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    }
}



#pragma mark - Touch Handling

- (UIButton *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if ([subview isKindOfClass:[UIButton class]]) {
        return (UIButton *)subview;
    } else {
        return nil;
    }
}



#pragma mark - Button Enabling


- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
    }
}


//Button Actions???
- (void) awesomeFloatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)button {
    if ([button.titleLabel isEqual:kWebBrowserBackString]) {
        [self.webView goBack];
    } else if ([button.titleLabel isEqual:kWebBrowserForwardString]) {
        [self.webView goForward];
    } else if ([button.titleLabel isEqual:kWebBrowserStopString]) {
        [self.webView stopLoading];
    } else if ([button.titleLabel isEqual:kWebBrowserRefreshString]) {
        [self.webView reload];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
