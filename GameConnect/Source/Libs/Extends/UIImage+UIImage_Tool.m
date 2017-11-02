//
//  UIImage+UIImage_Tool.m
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import "UIImage+UIImage_Tool.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "NSObject+NSObject_Tool.h"
#import "NSData+NSData_Tool.h"
#import "NSObject+NSObject_File.h"
#import "NSString+NSString_File.h"

#define SQUARE(i) ((i)*(i))
inline static void zeroClearInt(NSInteger* p, size_t count) { memset(p, 0, sizeof(NSInteger) * count); }


@implementation UIImage (UIImage_Tool)

- (UIImage *)crop:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)saveImageInFile:(NSString *)fileName
{
    if (self != nil)
    {
        NSData* data = UIImagePNGRepresentation(self);
        NSString *dest = [fileName toiphonedoc];
        [data setDataSaveNSDataFile:dest];
    }
}

+ (UIImage*)loadImageFromFile:(NSString *)fileName inTime:(int)time
{
    NSString *dest = [fileName toiphonedoc];
    [NSObject dateModifiedSort:dest temps:time];
//	UIImage *imageFromUnardhiver = [NSKeyedUnarchiver unarchiveObjectWithFile:dest] ;

    UIImage* image = [UIImage imageWithContentsOfFile:dest];
    return image;
}

+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 0.0f);
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image withSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resizableImage:(NSString *)imageName withCapInsets:(UIEdgeInsets)capInsets{
    UIImage *im = nil;
//    if ([NSObject getVerionsiOS] >= 5){
        im = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets];
//    }
//    else {
//        im = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
//    }
    return im;
}

+ (UIImage *)resizableUIImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets{
    UIImage *im = nil;
    if ([NSObject getVerionsiOS] >= 5){
        im = [image resizableImageWithCapInsets:capInsets];
    }
    else {
        im = [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    return im;
}

+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor
{
	UIGraphicsBeginImageContextWithOptions(baseImage.size, NO, 0.0f);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
	
	CGContextScaleCTM(ctx, 1, -1);
	CGContextTranslateCTM(ctx, 0, -area.size.height);
	
	CGContextSaveGState(ctx);
	CGContextClipToMask(ctx, area, baseImage.CGImage);
	
	[theColor set];
	CGContextFillRect(ctx, area);
	
	CGContextRestoreGState(ctx);
	
	CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
	
	CGContextDrawImage(ctx, area, baseImage.CGImage);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}

+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor verticalOffSet:(int)verticalOffSet
{
	UIGraphicsBeginImageContextWithOptions(baseImage.size, NO, 0.0f);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
	
	CGContextScaleCTM(ctx, 1, -1);
	CGContextTranslateCTM(ctx, 0, -baseImage.size.height);
	
	CGContextSaveGState(ctx);
	CGContextClipToMask(ctx, area, baseImage.CGImage);
	
	[theColor set];
	CGContextFillRect(ctx, CGRectMake(area.origin.x, baseImage.size.height, area.size.width, -verticalOffSet));
	
	CGContextRestoreGState(ctx);
	
	CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

	CGContextDrawImage(ctx, area, baseImage.CGImage);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

-(UIImage *)boxblurImageWithBlur:(CGFloat)inradius{
    inradius *= 50;
	if (inradius < 1){
		return self;
	}
    // Suggestion xidew to prevent crash if size is null
	if (CGSizeEqualToSize(self.size, CGSizeZero)) {
        return self;
    }
    
    //	return [other applyBlendFilter:filterOverlay  other:self context:nil];
	// First get the image into your data buffer
    CGImageRef inImage = self.CGImage;
    NSInteger nbPerCompt = CGImageGetBitsPerPixel(inImage);
    if(nbPerCompt != 32){
        UIImage *tmpImage = [self normalize];
        inImage = tmpImage.CGImage;
    }
    CGDataProviderRef img = CGImageGetDataProvider(inImage);
    CFDataRef dataref = CGDataProviderCopyData(img);
    CFMutableDataRef m_DataRef = CFDataCreateMutableCopy(0, 0, dataref);
    CFRelease(dataref);
    UInt8 * m_PixelBuf=malloc(CFDataGetLength(m_DataRef));
    CFDataGetBytes(m_DataRef,
                   CFRangeMake(0,CFDataGetLength(m_DataRef)) ,
                   m_PixelBuf);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
											 CGImageGetWidth(inImage),
											 CGImageGetHeight(inImage),
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),
											 CGImageGetColorSpace(inImage),
											 CGImageGetBitmapInfo(inImage)
											 );
	
    // Apply stack blur
    const NSInteger imageWidth  = CGImageGetWidth(inImage);
	const NSInteger imageHeight = CGImageGetHeight(inImage);
    [self.class applyStackBlurToBuffer:m_PixelBuf
                                 width:(int)imageWidth
                                height:(int)imageHeight
                            withRadius:inradius];
    
    // Make new image
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CFRelease(m_DataRef);
    free(m_PixelBuf);
	return finalImage;
}


+ (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius {
    // Constants
	const NSInteger radius = inradius; // Transform unsigned into signed for further operations
	const NSInteger wm = w - 1;
	const NSInteger hm = h - 1;
	const NSInteger wh = w*h;
	const NSInteger div = radius + radius + 1;
	const NSInteger r1 = radius + 1;
	const NSInteger divsum = SQUARE((div+1)>>1);
    
    // Small buffers
	NSInteger stack[div*3];
	zeroClearInt(stack, div*3);
    
	NSInteger vmin[MAX(w,h)];
	zeroClearInt(vmin, MAX(w,h));
    
    // Large buffers
	NSInteger *r = malloc(wh * sizeof(int));
	NSInteger *g = malloc(wh * sizeof(int));
	NSInteger *b = malloc(wh * sizeof(int));
	zeroClearInt(r, wh);
	zeroClearInt(g, wh);
	zeroClearInt(b, wh);
    
    const size_t dvcount = 256 * divsum;
    NSInteger *dv = calloc(sizeof(int) * dvcount,1);
	for (NSInteger i = 0;i < dvcount;i++) {
		dv[i] = (i / divsum);
	}
    
    // Variables
    NSInteger x, y;
	NSInteger *sir;
	NSInteger routsum,goutsum,boutsum;
	NSInteger rinsum,ginsum,binsum;
	NSInteger rsum, gsum, bsum, p, yp;
	NSInteger stackpointer;
	NSInteger stackstart;
	NSInteger rbs;
    
	NSInteger yw = 0, yi = 0;
	for (y = 0;y < h;y++) {
		rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
		
		for(NSInteger i = -radius;i <= radius;i++){
			sir = &stack[(i + radius)*3];
			NSInteger offset = (yi + MIN(wm, MAX(i, 0)))*4;
			sir[0] = targetBuffer[offset];
			sir[1] = targetBuffer[offset + 1];
			sir[2] = targetBuffer[offset + 2];
			
			rbs = r1 - labs(i);
			rsum += sir[0] * rbs;
			gsum += sir[1] * rbs;
			bsum += sir[2] * rbs;
			if (i > 0){
				rinsum += sir[0];
				ginsum += sir[1];
				binsum += sir[2];
			} else {
				routsum += sir[0];
				goutsum += sir[1];
				boutsum += sir[2];
			}
		}
		stackpointer = radius;
		
		for (x = 0;x < w;x++) {
			r[yi] = dv[rsum];
			g[yi] = dv[gsum];
			b[yi] = dv[bsum];
			
			rsum -= routsum;
			gsum -= goutsum;
			bsum -= boutsum;
			
			stackstart = stackpointer - radius + div;
			sir = &stack[(stackstart % div)*3];
			
			routsum -= sir[0];
			goutsum -= sir[1];
			boutsum -= sir[2];
			
			if (y == 0){
				vmin[x] = MIN(x + radius + 1, wm);
			}
			
			NSInteger offset = (yw + vmin[x])*4;
			sir[0] = targetBuffer[offset];
			sir[1] = targetBuffer[offset + 1];
			sir[2] = targetBuffer[offset + 2];
			rinsum += sir[0];
			ginsum += sir[1];
			binsum += sir[2];
			
			rsum += rinsum;
			gsum += ginsum;
			bsum += binsum;
			
			stackpointer = (stackpointer + 1) % div;
			sir = &stack[(stackpointer % div)*3];
			
			routsum += sir[0];
			goutsum += sir[1];
			boutsum += sir[2];
			
			rinsum -= sir[0];
			ginsum -= sir[1];
			binsum -= sir[2];
			
			yi++;
		}
		yw += w;
	}
    
	for (x = 0;x < w;x++) {
		rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
		yp = -radius*w;
		for(NSInteger i = -radius;i <= radius;i++) {
			yi = MAX(0, yp) + x;
			
			sir = &stack[(i + radius)*3];
			
			sir[0] = r[yi];
			sir[1] = g[yi];
			sir[2] = b[yi];
			
			rbs = r1 - labs(i);
			
			rsum += r[yi]*rbs;
			gsum += g[yi]*rbs;
			bsum += b[yi]*rbs;
			
			if (i > 0) {
				rinsum += sir[0];
				ginsum += sir[1];
				binsum += sir[2];
			} else {
				routsum += sir[0];
				goutsum += sir[1];
				boutsum += sir[2];
			}
			
			if (i < hm) {
				yp += w;
			}
		}
		yi = x;
		stackpointer = radius;
		for (y = 0;y < h;y++) {
			NSInteger offset = yi*4;
			targetBuffer[offset]     = dv[rsum];
			targetBuffer[offset + 1] = dv[gsum];
			targetBuffer[offset + 2] = dv[bsum];
			rsum -= routsum;
			gsum -= goutsum;
			bsum -= boutsum;
			
			stackstart = stackpointer - radius + div;
			sir = &stack[(stackstart % div)*3];
			
			routsum -= sir[0];
			goutsum -= sir[1];
			boutsum -= sir[2];
			
			if (x == 0){
				vmin[y] = MIN(y + r1, hm)*w;
			}
			p = x + vmin[y];
			
			sir[0] = r[p];
			sir[1] = g[p];
			sir[2] = b[p];
			
			rinsum += sir[0];
			ginsum += sir[1];
			binsum += sir[2];
			
			rsum += rinsum;
			gsum += ginsum;
			bsum += binsum;
			
			stackpointer = (stackpointer + 1) % div;
			sir = &stack[stackpointer*3];
			
			routsum += sir[0];
			goutsum += sir[1];
			boutsum += sir[2];
			
			rinsum -= sir[0];
			ginsum -= sir[1];
			binsum -= sir[2];
			
			yi += w;
		}
	}
    
	free(r);
	free(g);
	free(b);
    free(dv);
}


- (UIImage *) normalize {
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         width,
                                                         height,
                                                         8, (4 * width),
                                                         genericColorSpace,
                                                         kCGBitmapAlphaInfoMask);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, self.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    
    return result;
}



@end
