//
//  DSActivityView.m
//  Dejal Open Source
//
//  Created by David Sinclair on 2009-07-26.
//  Copyright 2009-2011 Dejal Systems, LLC. All rights reserved.
//
//  Redistribution and use in binary and source forms, with or without modification,
//  are permitted for any project, commercial or otherwise, provided that the
//  following conditions are met:
//
//  Redistributions in binary form must display the copyright notice in the About
//  view, website, and/or documentation.
//
//  Redistributions of source code must retain the copyright notice, this list of
//  conditions, and the following disclaimer.
//
//  THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THIS SOFTWARE.
//
//  Credit: inspired by Matt Gallagher's LoadingView blog post:
//  http://cocoawithlove.com/2009/04/showing-message-over-iphone-keyboard.html
//

@import UIKit;


@interface DSActivityView : UIView
{
@protected
	__weak UIView *_originalView;
	UIView *_borderView;
	UIActivityIndicatorView *_activityIndicator;
	UILabel *_activityLabel;
	NSUInteger _labelWidth;
	BOOL _showNetworkActivityIndicator;
	BOOL _isPrivate;
}

// Whether to show the network activity indicator in the status bar.  Set to YES if the activity is network-related.  This can be toggled on and off as desired while the activity view is visible (e.g. have it on while fetching data, then disable it while parsing it).  By default it is not shown:
@property (nonatomic) BOOL showNetworkActivityIndicator;

// Gets and sets the line break mode of the activity label.
@property (nonatomic) NSLineBreakMode activityLabelLineBreakMode;

//  Returns the currently displayed activity view, or nil if there isn't one:
+ (DSActivityView *)currentActivityView;

// Creates and adds an activity view centered within the specified view, using the label "Loading...".  Returns the activity view, already added as a subview of the specified view:
+ (DSActivityView *)newActivityViewForView: (UIView *) addToView;
+ (DSActivityView *)newPrivateActivityViewForView: (UIView *) addToView;

// Creates and adds an activity view centered within the specified view, using the specified label.  Returns the activity view, already added as a subview of the specified view:
+ (DSActivityView *)newActivityViewForView: (UIView *) addToView withLabel: (NSString *) labelText;
+ (DSActivityView *)newPrivateActivityViewForView: (UIView *) addToView withLabel: (NSString *) labelText;

// Creates and adds an activity view centered within the specified view, using the specified label and a fixed label width.  The fixed width is useful if you want to change the label text while the view is visible.  Returns the activity view, already added as a subview of the specified view:
+ (DSActivityView *)newActivityViewForView: (UIView *) addToView withLabel: (NSString *) labelText width: (NSUInteger) labelWidth;
+ (DSActivityView *)newPrivateActivityViewForView: (UIView *) addToView withLabel: (NSString *) labelText width: (NSUInteger) labelWidth;

// Designated initializer.  Configures the activity view using the specified label text and width, and adds as a subview of the specified view:
// if privateToView=NO then the global singleton will be used, else the activity view will be private to the view that instantiates it.
- (DSActivityView *)initForView: (UIView *) addToView withLabel: (NSString *) labelText width: (NSUInteger) labelWidth privateToView:(BOOL)inPrivate;


- (DSActivityView *)initForView: (UIView *) addToView withLabel: (NSString *) labelText width: (NSUInteger) labelWidth;

// Immediately removes and releases the view without any animation:
+ (void)removeView;
- (void)removeView;

// Accessor to set the ActivityLabel text value. This will cause a call to -setNeedsLayout so new text will fit!
- (void) setActivityLabelText: (NSString *) inText;

+(DSActivityView *)currentPrivateActivityViewForView:(UIView *)inView;

+(void)setPrivateActivityView:(DSActivityView *)inActivityView
					  forView:(UIView *)inTargetView;


// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------

// These methods are exposed for subclasses to override to customize the appearance and behavior; see the implementation for details:

- (UIView *)viewForView: (UIView *) view;
- (CGRect)enclosingFrame;
- (void)setupBackground;
- (void)animateShow;
- (void)animateRemove;

@end

// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------

@interface DSWhiteActivityView : DSActivityView
{
}

@end

// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------

@interface DSBezelActivityView : DSActivityView
{
}

// Animates the view out from the superview and releases it, or simply removes and releases it immediately if not animating:
+ (void)removeViewAnimated: (BOOL) animated;

// Accessor to set the ActivityLabel text value. This will cause a call to -setNeedsLayout so new text will fit!
- (void) setActivityLabelText: (NSString *) inText;

@end

// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------

@interface DSKeyboardActivityView : DSBezelActivityView
{
}

// Creates and adds a keyboard-style activity view, using the label "Loading...".  Returns the activity view, already covering the keyboard, or nil if the keyboard isn't currently displayed:
+ (DSKeyboardActivityView *)newActivityView;

// Creates and adds a keyboard-style activity view, using the specified label.  Returns the activity view, already covering the keyboard, or nil if the keyboard isn't currently displayed:
+ (DSKeyboardActivityView *)newActivityViewWithLabel: (NSString *) labelText;

@end

// ----------------------------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------------------------

@interface UIApplication (KeyboardView)

- (UIView *)keyboardView;

@end;


@interface UIView (DSActivityViewSupport)

-(DSActivityView *)currentPrivateActivityView;
-(void)setPrivateActivityView:(DSActivityView *)inActivityView;
-(void)setPrivateActivityView:(DSActivityView *)inNewActivityView
	  ifCurrentActivityViewIs:(DSActivityView *)inOldActivityView;
-(void)removePrivateActivityViewAnimated:(BOOL)inAnimated;

@end



