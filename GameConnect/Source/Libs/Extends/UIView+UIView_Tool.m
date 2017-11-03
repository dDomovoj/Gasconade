//
//  UIView+UIView_Tool.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "UIView+UIView_Tool.h"
#import "NSObject+NSObject_Xpath.h"
#import "NSArray+NSArray_FastEnum.h"
#import "NSString+NSString_Tool.h"
#import "UIImageViewJA.h"
#import "NSObject+NSObject_Tool.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static const char * const kParentViewControllerKey = "kParentViewControllerKey";
static const char * const kTagObjectiveKey = "kTagObjectiveKey";

@implementation UIView (UIView_Tool)

- (id)parentViewController
{
    return objc_getAssociatedObject(self, kParentViewControllerKey);
}

- (void)setParentViewController:(UIViewController *)controller
{
    objc_setAssociatedObject(self, kParentViewControllerKey, controller, OBJC_ASSOCIATION_ASSIGN);
}

- (id)tagObjective
{
    return objc_getAssociatedObject(self, kTagObjectiveKey);
}

- (void)setTagObjective:(id)obj
{
    objc_setAssociatedObject(self, kTagObjectiveKey, obj, OBJC_ASSOCIATION_ASSIGN);
}

-(void)bouingAppear:(BOOL)appear oncomplete:(void (^)(void))oncomplete{
	if (!appear){
		self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0);
		CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
		bounceAnimation.values = [NSArray arrayWithObjects:
								  [NSNumber numberWithFloat:1.0],
								  [NSNumber numberWithFloat:0.8],
								  [NSNumber numberWithFloat:1.1],
								  [NSNumber numberWithFloat:0.3], nil];
		bounceAnimation.duration = 0.5;
		bounceAnimation.removedOnCompletion = NO;
		[self.layer addAnimation:bounceAnimation forKey:@"bounce"];
		self.layer.transform = CATransform3DIdentity;
		
		[UIView animateWithDuration:0.6 animations:^{
			self.alpha = 0.0;
		} completion:^(BOOL finished) {
            if (oncomplete){
                oncomplete();
            }
		}];
		return;
	}
	self.alpha = 0;
	[UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        if (oncomplete){
            oncomplete();
        }
    }];
	self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	bounceAnimation.values = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:0.3],
							  [NSNumber numberWithFloat:1.1],
							  [NSNumber numberWithFloat:0.8],
							  [NSNumber numberWithFloat:1.0], nil];
	bounceAnimation.duration = 0.5;
	bounceAnimation.removedOnCompletion = NO;
	[self.layer addAnimation:bounceAnimation forKey:@"bounce"];
	self.layer.transform = CATransform3DIdentity;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
    dispatch_async(queue, ^{
        usleep(bounceAnimation.duration *1000);
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (oncomplete){
                oncomplete();
            }
        });
    });
    
}

-(void)highlight:(void (^)(void))oncomplete{
 	self.alpha = 0;
    
	[UIView animateWithDuration:0.7 animations:^{
		self.alpha = 1;
	} completion:^(BOOL finished) {
		if (!finished) return ;
		[UIView animateWithDuration:0.7 animations:^{
			self.alpha = 0.2;
		} completion:^(BOOL finished) {
			if (!finished) return ;
			[UIView animateWithDuration:0.7 animations:^{
				self.alpha = 1;
			} completion:^(BOOL finished) {
				if (!finished) return ;
				[UIView animateWithDuration:0.7 animations:^{
					self.alpha = 0.5;
				} completion:^(BOOL finished) {
					if (!finished) return ;
					[UIView animateWithDuration:0.7 animations:^{
						self.alpha = 1;
					} completion:^(BOOL finished) {
						if (!finished) return ;
						oncomplete();
					}];
				}];
			}];
		}];
	}];
}
-(UIView*)addSubviewToBonce:(UIView*)view{
	return [self addSubviewToBonce:view autoSizing:NO];
}

-(UIView*)addSubviewToBonceWithConstraint:(UIView*)view{
    return [self addSubviewToBonceWithConstraint:view options:0];
}

-(UIView*)addSubviewToBonceWithConstraintWithoutLanguageDirection:(UIView*)view{
    return [self addSubviewToBonceWithConstraint:view options:NSLayoutFormatDirectionLeftToRight];
}

-(UIView*)addSubviewToBonceWithConstraint:(UIView*)view options:(NSLayoutFormatOptions)options{
    if (!view)
        return self;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    id posx = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:options metrics:nil views:NSDictionaryOfVariableBindings(view)];
    id posy = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
    [self addConstraints:posx];
    [self addConstraints:posy];
    return self;
}

-(UIView*)addSubviewToBonce:(UIView*)view autoSizing:(BOOL)autosize{
	if (autosize)
		[view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
	view.frame = self.bounds;
	[self addSubview:view];
	return view;
}

-(UIView*)addSubviewToCenter:(UIView*)view{
	
	CGRect r = self.bounds;
	r.origin.x = (self.bounds.size.width - view.frame.size.width)/2;
	r.origin.y = (self.bounds.size.height - view.frame.size.height)/2;
	r.size = view.frame.size;
	view.frame  = r;
	[self addSubview:view];
	return view;
}
-(void)setCenterJAPaddings:(id)paddings{
	[self renderRelativeSubviewsSetMyContentScroll:NO paddings:paddings];
	CGFloat w = 0;
	for (UIView *v in [self subviews]) {
		if (!v.hidden && (v.frame.origin.x+v.frame.size.width) >= w)
			w = v.frame.origin.x+v.frame.size.width;
	}
	float ww = self.frame.size.width;
	float decalage = (ww-w)/2;
	for (UIView *v in [self subviews]) {
		if (!v.hidden){
			CGRect r = v.frame;
			r.origin.x += decalage;
			v.frame = r;
		}
	}
}

-(CGSize)renderRelatifInlineScroll:(BOOL)scroll align:(NSString*)align{
	CGSize ret = CGSizeZero;
	__block CGFloat w = 0;
	__block CGFloat h = 0;
	
	[self.subviews each:^(NSInteger index, id elt, BOOL last) {
		UIView *e = elt;
		CGRect r = e.frame;
		r.origin.x = w;
		w += r.size.width;
		r.origin.y = 0;
		e.frame = r;
		h = MAX(h, r.size.height);
	}];
	ret.height = h;
	ret.width = w;
	
	if([align isSubString:@"right"]){
		CGFloat diff = self.frame.size.width - w;
		[self.subviews each:^(NSInteger index, id elt, BOOL last) {
			UIView *e = elt;
			CGRect r = e.frame;
			r.origin.x += diff ;
			e.frame = r;
		}];
	}
	if([align isSubString:@"bottom"]){
		[self.subviews each:^(NSInteger index, id elt, BOOL last) {
			UIView *e = elt;
			CGRect r = e.frame;
			r.origin.y = self.frame.size.height - e.frame.size.height;
			e.frame = r;
		}];
	}
	if([align isSubString:@"middle"]){
		[self.subviews each:^(NSInteger index, id elt, BOOL last) {
			UIView *e = elt;
			CGRect r = e.frame;
			r.origin.y = self.frame.size.height/2 - e.frame.size.height/2;
			e.frame = r;
		}];
	}
	if (align && [self isKindOfClass:[UIScrollView class]]){
		UIScrollView *s = (UIScrollView*)self;
		s.contentSize = ret;
	}
	
	return ret;
}
-(void)setCenterJA{
	[self setCenterJAPaddings:nil];
}

-(CGRect)renderRelativeSubviewsSetMyContentScroll:(BOOL)setContent{
	return [self renderRelativeSubviewsSetMyContentScroll:setContent paddings:nil];
}

-(CGRect)renderRelativeSubviewsSetMyContentScrollHorizontal{
    return [self renderRelativeSubviewsSetMyContentScrollHorizontalWithPadding:nil];
}

-(CGRect)renderRelativeSubviewsSetMyContentScrollHorizontalWithPadding:(id)paddings{
    BOOL isShowScollH = NO;
    if ([self isKindOfClass:[UIScrollView class]]){
        UIScrollView *elt  = (UIScrollView *)self;
        isShowScollH = elt.showsHorizontalScrollIndicator;
        [elt setShowsHorizontalScrollIndicator:NO];
    }
    CGRect rectO = self.frame;
    CGRect rectchange = self.frame;
    rectchange.size.width = 50000;
    self.frame = rectchange;
    [self renderRelativeSubviewsSetMyContentScroll:YES paddings:paddings];
    __block CGFloat wm = 0;
    [[self subviews] each:^(NSInteger index, id elt, BOOL last) {
        UIView  *v = elt;
        CGFloat wc = v.frame.origin.x + v.frame.size.width;
        if(wc > wm && !v.hidden)
            wm = wc;
    }];
    if([self isKindOfClass:[UIScrollView class]]){
        UIScrollView *elt  = (UIScrollView *)self;
        [elt setContentSize:CGSizeMake(wm, rectO.size.height)];
        [elt setShowsHorizontalScrollIndicator:isShowScollH];
    }
    self.frame = rectO;
	return CGRectMake(rectO.origin.x, rectO.origin.y, wm, rectO.size.height);
}

-(CGRect)renderRelativeSubviewsSetMyContentScroll:(BOOL)setContent paddings:(id)paddings{
	NSMutableArray *all = [[self subviews] ToMutable];
	
	NSMutableArray *l_frame = [NSMutableArray array];
	CGFloat hall = 0;
	CGRect prev = CGRectZero;
	while ([all count] ) {
		UIView *v = [all objectAtIndex:0];
		if(v.hidden){
			[all removeObjectAtIndex:0];
			continue;
		}
		
		CGFloat top = 0;
		CGFloat bottom = 0;
		CGFloat left = 0;
		CGFloat right = 0;
		NSValue *val = nil ;
		if ([paddings isKindOfClass:[NSDictionary class]]){
			val = [paddings objectForKey:@((NSInteger)v)];
		}
		
		if ([paddings isKindOfClass:[NSValue class]])
			val = (NSValue*)paddings;
		
		if (val){
			CGRect pad = [val CGRectValue];
			left = pad.origin.x;
			top = pad.origin.y;
			right = pad.size.width;
			bottom = pad.size.height;
		}
		
		CGFloat wi = v.frame.size.width + right+left;
		
		CGFloat wframe = self.frame.size.width;
		/*for (int i = [l_frame count] -1; i>0 && i >[l_frame count] -2; i--) {
         NSValue *v = [l_frame objectAtIndex:i];
         CGRect p = [v CGRectValue];
         //prev = p;
         wframe = self.frame.size.width-p.origin.x-p.size.width;
		 
         }*/
		// si place à dorite
		if ([l_frame count]  && prev.origin.x + prev.size.width + wi <= wframe){
			v.frame = CGRectMake(prev.origin.x+prev.size.width +left, prev.origin.y+top, v.frame.size.width,v.frame.size.height);
			// update frame
			if (prev.size.height > v.frame.size.height+top+bottom){
				// add frame
				CGRect r = CGRectMake(v.frame.origin.x-left, v.frame.origin.y+v.frame.size.height+bottom, self.frame.size.width-(v.frame.origin.x-left), v.frame.size.height+top+bottom);
                //				[l_frame addObject:[NSValue valueWithCGRect:r]];
				[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
			}else{
				// change old frame
				NSValue *l = (NSValue *)[l_frame objectAtIndex:0];
				CGRect r = [l CGRectValue];
				r.origin.y = v.frame.origin.y-top + v.frame.size.height+top+bottom;
				[l_frame removeObjectAtIndex:0];
                //				[l_frame addObject:[NSValue valueWithCGRect:r]];
				[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
			}
		}else{// sinon place en dessous
			// caclule de H
			CGFloat yo = prev.origin.y + prev.size.height;
			CGFloat xo = prev.origin.x;
			for (;  [l_frame count]; ) {
				NSValue *l = (NSValue *)[l_frame objectAtIndex:0];
				CGRect r = [l CGRectValue];
				if (yo  >= r.origin.y){
					[l_frame removeObjectAtIndex:0];
					xo = xo > r.origin.x ? r.origin.x : xo;
					
				}else{
					if (self.frame.size.width -xo >= v.frame.size.width+left+right){ // dans cette frame
						//xo = r.origin .x;
						//xo = xo > r.origin.x ? r.origin.x : xo;
						
						r = CGRectMake(xo, yo, self.frame.size.width -xo, 20);
						//[l_frame addObject:[NSValue valueWithCGRect:r]];
						[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
                        
						break;
					}else{
						[l_frame removeObjectAtIndex:0];
						xo = xo > r.origin.x ? r.origin.x : xo;
						yo = r.origin.y >= yo ? r.origin.y : yo;
						r = CGRectMake(xo, yo, self.frame.size.width -xo, 20);
						//[l_frame addObject:[NSValue valueWithCGRect:r]];
						[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
                        
						// pas dans la merde
						//NSLog(@"cas non géré pour le moment");
					}
					
				}
			}
			if (![l_frame count]){
				CGRect r = CGRectMake(xo, yo, self.frame.size.width -xo, 20);
				[l_frame addObject:[NSValue valueWithCGRect:r]];
			}
			// add frame
			NSValue *l = (NSValue *)[l_frame objectAtIndex:0];
			CGRect r = [l CGRectValue];
			v.frame = CGRectMake(r.origin.x	+ left, r.origin.y+top, v.frame.size.width,v.frame.size.height);
			// create frame ???
			r = CGRectMake(v.frame.origin.x-left, v.frame.origin.y+v.frame.size.height+bottom-top, self.frame.size.width -xo, 20);
            //			[l_frame addObject:[NSValue valueWithCGRect:r]];
			//[l_frame removeObjectAtIndex:0];
			[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
			
			
		}// fin si
		prev = v.frame;
		prev.size.width += left+right;
		prev.origin.x -= left;
		prev.origin.y -= top;
		prev.size.height += top + bottom;
		
		hall = prev.size.height + prev.origin.y > hall ? prev.size.height + prev.origin.y  : hall;
		[all removeObjectAtIndex:0];
		//NSLog(@"tab frame:\n%@",[l_frame description]);
	}
	
	if (setContent && [self.superview isKindOfClass:[UIScrollView class]]){
		UIScrollView *p = (UIScrollView *) self.superview;
		[p setContentSize:CGSizeMake(self.frame.size.width, hall)];
	}else if (setContent && [self isKindOfClass:[UIScrollView class]]){
		UIScrollView *p = (UIScrollView *) self;
		[p setContentSize:CGSizeMake(self.frame.size.width, hall)];
	}
	return CGRectMake(0,0,self.frame.size.width, hall);
}

-(CGRect)renderRelativeSubviewsSetMyContentScrollWithoutParent:(BOOL)setContent paddings:(id)paddings{
	NSMutableArray *all = [[self subviews] ToMutable];
	
	NSMutableArray *l_frame = [NSMutableArray array];
	CGFloat hall = 0;
	CGRect prev = CGRectZero;
	while ([all count] ) {
		UIView *v = [all objectAtIndex:0];
		if(v.hidden){
			[all removeObjectAtIndex:0];
			continue;
		}
		
		CGFloat top = 0;
		CGFloat bottom = 0;
		CGFloat left = 0;
		CGFloat right = 0;
		NSValue *val = nil ;
		if ([paddings isKindOfClass:[NSDictionary class]]){
			val = [paddings objectForKey:@((NSInteger)v)];
		}
		
		if ([paddings isKindOfClass:[NSValue class]])
			val = (NSValue*)paddings;
		
		if (val){
			CGRect pad = [val CGRectValue];
			left = pad.origin.x;
			top = pad.origin.y;
			right = pad.size.width;
			bottom = pad.size.height;
		}
		
		CGFloat wi = v.frame.size.width + right+left;
		
		CGFloat wframe = self.frame.size.width;
		/*for (int i = [l_frame count] -1; i>0 && i >[l_frame count] -2; i--) {
         NSValue *v = [l_frame objectAtIndex:i];
         CGRect p = [v CGRectValue];
         //prev = p;
         wframe = self.frame.size.width-p.origin.x-p.size.width;
		 
         }*/
		// si place à dorite
		if ([l_frame count]  && prev.origin.x + prev.size.width + wi <= wframe){
			v.frame = CGRectMake(prev.origin.x+prev.size.width +left, prev.origin.y+top, v.frame.size.width,v.frame.size.height);
			// update frame
			if (prev.size.height > v.frame.size.height+top+bottom){
				// add frame
				CGRect r = CGRectMake(v.frame.origin.x-left, v.frame.origin.y+v.frame.size.height+bottom, self.frame.size.width-(v.frame.origin.x-left), v.frame.size.height+top+bottom);
                //				[l_frame addObject:[NSValue valueWithCGRect:r]];
				[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
			}else{
				// change old frame
				NSValue *l = (NSValue *)[l_frame objectAtIndex:0];
				CGRect r = [l CGRectValue];
				r.origin.y = v.frame.origin.y-top + v.frame.size.height+top+bottom;
				[l_frame removeObjectAtIndex:0];
                //				[l_frame addObject:[NSValue valueWithCGRect:r]];
				[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
			}
		}else{// sinon place en dessous
			// caclule de H
			CGFloat yo = prev.origin.y + prev.size.height;
			CGFloat xo = prev.origin.x;
			for (;  [l_frame count]; ) {
				NSValue *l = (NSValue *)[l_frame objectAtIndex:0];
				CGRect r = [l CGRectValue];
				if (yo  >= r.origin.y){
					[l_frame removeObjectAtIndex:0];
					xo = xo > r.origin.x ? r.origin.x : xo;
					
				}else{
					if (self.frame.size.width -xo >= v.frame.size.width+left+right){ // dans cette frame
						//xo = r.origin .x;
						//xo = xo > r.origin.x ? r.origin.x : xo;
						
						r = CGRectMake(xo, yo, self.frame.size.width -xo, 20);
						//[l_frame addObject:[NSValue valueWithCGRect:r]];
						[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
                        
						break;
					}else{
						[l_frame removeObjectAtIndex:0];
						xo = xo > r.origin.x ? r.origin.x : xo;
						yo = r.origin.y >= yo ? r.origin.y : yo;
						r = CGRectMake(xo, yo, self.frame.size.width -xo, 20);
						//[l_frame addObject:[NSValue valueWithCGRect:r]];
						[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
                        
						// pas dans la merde
						//NSLog(@"cas non géré pour le moment");
					}
					
				}
			}
			if (![l_frame count]){
				CGRect r = CGRectMake(xo, yo, self.frame.size.width -xo, 20);
				[l_frame addObject:[NSValue valueWithCGRect:r]];
			}
			// add frame
			NSValue *l = (NSValue *)[l_frame objectAtIndex:0];
			CGRect r = [l CGRectValue];
			v.frame = CGRectMake(r.origin.x	+ left, r.origin.y+top, v.frame.size.width,v.frame.size.height);
			// create frame ???
			r = CGRectMake(v.frame.origin.x-left, v.frame.origin.y+v.frame.size.height+bottom-top, self.frame.size.width -xo, 20);
            //			[l_frame addObject:[NSValue valueWithCGRect:r]];
			//[l_frame removeObjectAtIndex:0];
			[l_frame insertObject:[NSValue valueWithCGRect:r] atIndex:0];
			
			
		}// fin si
		prev = v.frame;
		prev.size.width += left+right;
		prev.origin.x -= left;
		prev.origin.y -= top;
		prev.size.height += top + bottom;
		
		hall = prev.size.height + prev.origin.y > hall ? prev.size.height + prev.origin.y  : hall;
		[all removeObjectAtIndex:0];
		//NSLog(@"tab frame:\n%@",[l_frame description]);
	}
	
	if (setContent && [self isKindOfClass:[UIScrollView class]]){
		UIScrollView *p = (UIScrollView *) self;
		[p setContentSize:CGSizeMake(self.frame.size.width, hall)];
	}
	return CGRectMake(0,0,self.frame.size.width, hall);
}

-(void)visiteurView:(void(^)(UIView *elt))cbBefore cbAfter:(void(^)(UIView *elt))cbAfter{
    if(!cbAfter && !cbBefore)
        return;
    if (cbBefore)cbBefore(self);
    [[self subviews] each:^(NSInteger index, id elt, BOOL last) {
        [elt visiteurView:cbBefore cbAfter:cbAfter];
    }];
    if (cbAfter)cbAfter(self);
}

-(UIView*)roundShadow{
	[self.layer setCornerRadius:5];
	[self.layer setShadowColor:[UIColor blackColor].CGColor];
	[self.layer setShadowOpacity:0.34];
	[self.layer setShadowRadius:2.0];
	[self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
	CGRect shadowFrame = self.layer.bounds;
	CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
	self.layer.shadowPath = shadowPath;
	if(self.clipsToBounds)
		[self setClipsToBounds:NO];
	return self;
}
-(UIView*)setBorder:(CGFloat)width color:(UIColor*)color{
	[self.layer setBorderColor:color.CGColor];
	[self.layer setBorderWidth:width];
	return self;
}
-(NSInteger)setId:(NSString*)idview{
    if([idview isEqualToString:@""])
        NSLog(@"No ID VIEW");
    self.tag = [idview crc32];
    return self.tag;
}
-(BOOL)generateId{
    BOOL ret = FALSE;
    __block NSMutableString *str = [@"" ToMutable];
    [self visiteurView:^(UIView *elt) {
        if (elt.tag){
            [str appendFormat:@"%ld", (long)elt.tag];
            return;
        }
        if([elt isKindOfClass:[UILabel class]])
            [str appendString:((UILabel*)elt).text];
        if([elt isKindOfClass:[UITextView class]])
            [str appendString:((UITextView*)elt).text];
        if([elt isKindOfClass:[UIImageViewJA class]])
            [str appendString:((UIImageViewJA*)elt).dist_url];
        
    } cbAfter:nil];
    if ([str isNotEqualToString:@""]){
        [self setId:str];
        return YES;
    }
    return ret;
}

-(void)replavesubview:(NSArray*)newView keepOldView:(BOOL)keepOldView{
    __block NSMutableArray *sup = [@[] ToMutable];
    __block NSMutableArray *add = [newView ToMutable];
    //    __block NSMutableArray *replace = [@[] ToMutable];
    __block NSMutableDictionary *keyvalnew = [ @{} ToMutable];
    [newView each:^(NSInteger index, id elt, BOOL last) {
        UIView *v = elt;
        keyvalnew[@(v.tag)] = elt;
    }];
    
    [[self subviews] each:^(NSInteger index, id elt, BOOL last) {
        UIView *v = elt;
        if (keyvalnew[@(v.tag)]){
            UIView *obj = keyvalnew[@(v.tag)];
            if (!keepOldView){
                [add removeObject:obj];
                obj.frame = v.frame;
                [v removeFromSuperview];
                [self insertSubview:obj atIndex:index];
            }
        }else{
            [sup addObject:elt];
        }
    }];
//    [NSObject ba]
    void (^__weak  r_recustion)() = nil;
  void (^__block  recustion)(void) = ^(){
        if ([sup count]) {
            UIView *elt = sup[0];
            [sup removeObject:elt];
            [UIView animateWithDuration:0.1 animations:^{
                elt.alpha = 0;
            } completion:^(BOOL finished) {
                [elt removeFromSuperview];
                [UIView animateWithDuration:0.1 animations:^{
                    [self renderRelativeSubviewsSetMyContentScroll:NO];
                } completion:^(BOOL finished) {
                    
                    r_recustion();
                }];
            }];
        }else if ([add count]){
            UIView *elt = sup[0];
            [add removeObject:elt];
            elt.alpha = 0;
            [self insertSubview:elt atIndex:[newView indexOfObject:elt]];
            [UIView animateWithDuration:0.1 animations:^{
                [self renderRelativeSubviewsSetMyContentScroll:NO];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    elt.alpha = 1;
                } completion:^(BOOL finished) {
                    r_recustion();
                }];
            }];
        }
//        else r_recustion = nil;
    };
//    r_recustion = recustion;
    recustion();
}

-(UIView*)getMasterView{
	if (self.superview)
		return [self.superview getMasterView];
	return self;
}


 

- (UIImage*)screenshot {
    if ([NSObject isRetina])
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    else
        UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
//    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
//    image = [UIImage imageWithData:imageData];
    
    return image;
}


-(void)clearSubview{
	[self.subviews each:^(NSInteger index, id elt, BOOL last) {
		[elt removeFromSuperview];
	}];
}

-(void) resignAllResponder{
    [self visiteurView:^(UIView *elt) {
        if ([elt isFirstResponder])
            [elt resignFirstResponder];
    } cbAfter:^(UIView *elt) {
        
    }];
}
@end
