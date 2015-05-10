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

#import "UIPageControl+Html.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Samurai_HtmlStyle.h"
#import "Samurai_HtmlRenderObject.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIPageControl(Html)

+ (HtmlRenderModel)html_defaultRenderModel
{
	return HtmlRenderModel_Element;
}

- (void)html_applyDom:(SamuraiHtmlDomNode *)dom
{
	[super html_applyDom:dom];
	
	NSInteger count = [[dom.domAttributes objectForKey:@"pages"] integerValue];
	NSInteger current = [[dom.domAttributes objectForKey:@"current"] integerValue];

	NSString * minCount = [dom.domAttributes objectForKey:@"min-pages"];
	NSString * maxCount = [dom.domAttributes objectForKey:@"max-pages"];

	if ( minCount )
	{
		count = MAX( count, [minCount integerValue] );
	}
	
	if ( maxCount )
	{
		count = MIN( count, [maxCount integerValue] );
	}
	
	count = count ?: 1;

	if ( count )
	{
		if ( current >= count )
		{
			current = count - 1;
		}
	}

	self.numberOfPages = count;
	self.currentPage = current;
}

- (void)html_applyStyle:(SamuraiHtmlStyle *)style
{
	[super html_applyStyle:style];

	UIColor * color = [style computeColor:self.pageIndicatorTintColor];

	self.pageIndicatorTintColor = [color colorWithAlphaComponent:0.5f];
	self.currentPageIndicatorTintColor = color;
}

- (void)html_applyFrame:(CGRect)newFrame
{
	[super html_applyFrame:newFrame];
	
	self.hidesForSinglePage = YES;
	self.defersCurrentPageDisplay = YES;

	[self updateCurrentPageDisplay];
}

#pragma mark -

- (void)html_forView:(UIView *)hostView
{
	if ( [hostView isKindOfClass:[UIScrollView class]] )
	{
		[hostView addObserver:self
				   forKeyPath:@"contentOffset"
					  options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
					  context:(void *)hostView];
	}
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSObject * oldValue = [change objectForKey:@"old"];
	NSObject * newValue = [change objectForKey:@"new"];
	
	if ( newValue )
	{
		UIView * hostView = (__bridge UIView *)(context);
		
		if ( [hostView isKindOfClass:[UIScrollView class]] )
		{
			UIScrollView * scrollView = (UIScrollView *)hostView;
			
			if ( NO == CGSizeEqualToSize( scrollView.contentSize, CGSizeZero ) )
			{
				NSInteger numberOfPages = 0;
				NSInteger currentPage = 0;
				
				CGFloat contentWidth = scrollView.contentSize.width;
				CGFloat contentHeight = scrollView.contentSize.height;
				
				CGFloat frameWidth = scrollView.frame.size.width;
				CGFloat frameHeight = scrollView.frame.size.height;
				
				if ( contentWidth > frameWidth && contentHeight <= frameHeight )
				{
					// horizontal
					
					numberOfPages	= (contentWidth + frameWidth - 1) / frameWidth;
					currentPage		= scrollView.contentOffset.x / frameWidth;
				}
				else if ( contentHeight > frameHeight && contentWidth <= frameWidth )
				{
					// vertical
					
					numberOfPages	= (contentHeight + frameHeight - 1) / frameHeight;
					currentPage		= scrollView.contentOffset.y / frameHeight;
				}
				else
				{
					numberOfPages	= 0;
					currentPage		= 0;
				}
				
				if ( numberOfPages )
				{
					if ( currentPage >= numberOfPages )
					{
						currentPage = numberOfPages - 1;
					}
				}
				
				self.numberOfPages = numberOfPages;
				self.currentPage = currentPage;
			}
			else
			{
				self.numberOfPages = 0;
				self.currentPage = 0;
			}
			
			[self updateCurrentPageDisplay];
			[self setNeedsDisplay];
		}
	}
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIPageControl_Html )

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
