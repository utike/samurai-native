//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "UITextField+Html.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlRenderObject.h"
#import "Samurai_HtmlUserAgent.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UITextField(Html)

+ (HtmlRenderModel)html_defaultRenderModel
{
	return HtmlRenderModel_Element;
}

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
	
	NSString * placeholder = [dom.domAttributes objectForKey:@"placeholder"];
	
	self.text = [[dom computeInnerText] normalize];
	
	if ( placeholder )
	{
		self.placeholder = [placeholder normalize];
	}
	else
	{
		self.placeholder = nil;
	}

	NSString * autoCapitalize = [dom.domAttributes objectForKey:@"auto-capitalization"];
	NSString * autoCorrection = [dom.domAttributes objectForKey:@"auto-correction"];
	NSString * autoClears = [dom.domAttributes objectForKey:@"auto-clears"];
	NSString * spellChecking = [dom.domAttributes objectForKey:@"spell-checking"];

	if ( autoClears )
	{
		self.clearsOnBeginEditing = YES;
	}
	else
	{
		self.clearsOnBeginEditing = NO;
	}
	
	if ( autoCapitalize )
	{
		self.autocapitalizationType = UITextAutocapitalizationTypeWords;
	}
	else
	{
		self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	}

	if ( autoCorrection )
	{
		self.autocorrectionType = UITextAutocorrectionTypeYes;
	}
	else
	{
		self.autocorrectionType = UITextAutocorrectionTypeNo;
	}

	if ( spellChecking )
	{
		self.spellCheckingType = UITextSpellCheckingTypeYes;
	}
	else
	{
		self.spellCheckingType = UITextSpellCheckingTypeNo;
	}
	
	NSString * keyboardType = [dom.domAttributes objectForKey:@"keyboard-type"];

	if ( [keyboardType isEqualToString:@"ascii"] )
	{
		self.keyboardType = UIKeyboardTypeASCIICapable;
	}
	else if ( [keyboardType isEqualToString:@"numbers-punctuation"] )
	{
		self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	}
	else if ( [keyboardType isEqualToString:@"url"] )
	{
		self.keyboardType = UIKeyboardTypeURL;
	}
	else if ( [keyboardType isEqualToString:@"number"] )
	{
		self.keyboardType = UIKeyboardTypeNumberPad;
	}
	else if ( [keyboardType isEqualToString:@"phone"] )
	{
		self.keyboardType = UIKeyboardTypePhonePad;
	}
	else if ( [keyboardType isEqualToString:@"name-phone"] )
	{
		self.keyboardType = UIKeyboardTypeNamePhonePad;
	}
	else if ( [keyboardType isEqualToString:@"email"] )
	{
		self.keyboardType = UIKeyboardTypeEmailAddress;
	}
	else if ( [keyboardType isEqualToString:@"decimal"] )
	{
		self.keyboardType = UIKeyboardTypeDecimalPad;
	}
	else if ( [keyboardType isEqualToString:@"twitter"] )
	{
		self.keyboardType = UIKeyboardTypeTwitter;
	}
	else if ( [keyboardType isEqualToString:@"web-search"] )
	{
		self.keyboardType = UIKeyboardTypeWebSearch;
	}
	else
	{
		self.keyboardType = UIKeyboardTypeDefault;
	}
	
	NSString * keyboardAppearance = [dom.domAttributes objectForKey:@"keyboard-appearance"];

	if ( [keyboardAppearance isEqualToString:@"dark"] )
	{
		self.keyboardAppearance = UIKeyboardAppearanceDark;
	}
	else if ( [keyboardAppearance isEqualToString:@"light"] )
	{
		self.keyboardAppearance = UIKeyboardAppearanceLight;
	}
	else
	{
		self.keyboardAppearance = UIKeyboardAppearanceDefault;
	}

	NSString * returnKeyType = [dom.domAttributes objectForKey:@"return-key-type"];

	if ( [returnKeyType isEqualToString:@"go"] )
	{
		self.returnKeyType = UIReturnKeyGo;
	}
	else if ( [returnKeyType isEqualToString:@"google"] )
	{
		self.returnKeyType = UIReturnKeyGoogle;
	}
	else if ( [returnKeyType isEqualToString:@"join"] )
	{
		self.returnKeyType = UIReturnKeyJoin;
	}
	else if ( [returnKeyType isEqualToString:@"next"] )
	{
		self.returnKeyType = UIReturnKeyNext;
	}
	else if ( [returnKeyType isEqualToString:@"route"] )
	{
		self.returnKeyType = UIReturnKeyRoute;
	}
	else if ( [returnKeyType isEqualToString:@"search"] )
	{
		self.returnKeyType = UIReturnKeySearch;
	}
	else if ( [returnKeyType isEqualToString:@"send"] )
	{
		self.returnKeyType = UIReturnKeySend;
	}
	else if ( [returnKeyType isEqualToString:@"yahoo"] )
	{
		self.returnKeyType = UIReturnKeyYahoo;
	}
	else if ( [returnKeyType isEqualToString:@"done"] )
	{
		self.returnKeyType = UIReturnKeyDone;
	}
	else if ( [returnKeyType isEqualToString:@"emergency-call"] )
	{
		self.returnKeyType = UIReturnKeyEmergencyCall;
	}
	else
	{
		self.returnKeyType = UIReturnKeyDefault;
	}
	
	self.enablesReturnKeyAutomatically = NO;
	
	NSString * isSecure = [dom.domAttributes objectForKey:@"is-secure"];
	
	if ( isSecure )
	{
		self.secureTextEntry = YES;
	}
	else
	{
		self.secureTextEntry = NO;
	}
}

- (void)html_applyStyle:(SamuraiHtmlStyle *)style
{
	[super html_applyStyle:style];

	self.font = [style computeFont:[SamuraiHtmlUserAgent sharedInstance].defaultFont];
	self.textColor = [style computeColor:self.textColor];
	self.textAlignment = [style computeTextAlignment:self.textAlignment];
//	self.baselineAdjustment = [style computeBaselineAdjustment:self.baselineAdjustment];
//	self.lineBreakMode = [style computeLineBreakMode:self.lineBreakMode];
//	self.numberOfLines = 0;

	self.borderStyle = UITextBorderStyleNone;
	self.adjustsFontSizeToFitWidth = NO;
	self.minimumFontSize = 12.0f;
	self.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.clearsOnInsertion = NO;
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UITextField_Html )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
