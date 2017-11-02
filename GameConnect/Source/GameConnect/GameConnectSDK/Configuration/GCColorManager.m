//
//  GCColorManager.m
//  GameConnectV2
//
//  Created by Guillaume Derivery on 3/24/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCColorManager.h"
#import "GCConfManager.h"
#import "Extends+Libs.h"

@interface GCColorManager ()
{
  NSDictionary *initializedColors;
}
@end

@implementation GCColorManager

#pragma Singleton
+(GCColorManager *) getInstance
{
  static GCColorManager *colorManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    colorManager = [[self alloc] init];
  });
  return colorManager;
}

-(id)init
{
  self = [super init];
  if (self)
  {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[[GCConfManager getInstance] getValue:GCConfigValueColorJSONFile] ofType:@"json"];
    NSError *fileError = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:(NSDataReadingMappedIfSafe) error:&fileError];

    if (!fileError)
    {
      NSError *jsonError;
      NSDictionary *colors = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

      if (colors)
        initializedColors = [colors getXpathNilDictionary:@"colors"];
      else
        NSLog(@"GCColorManager : JSON Error => %@", [jsonError localizedDescription]);
    }
    else
      NSLog(@"GCColorManager : File Error => %@", [fileError localizedDescription]);
  }
  return self;
}

-(UIColor *) getColorForKey:(NSString *)key
{
  if (initializedColors)
  {
    NSDictionary *colorDescription = [initializedColors getXpathNilDictionary:key];
    if (colorDescription)
    {
      NSString *strColor = [colorDescription getXpathNilString:@"color"];
      if (strColor)
      {
        CGFloat alpha = [[colorDescription getXpathEmptyString:@"alpha"] floatValue];
        alpha = floorf(alpha * 100 + 0.5) / 100;
        return [UIColor colorWithRGBString:strColor alpha:alpha];
      }
    }
  }
  return [UIColor colorWithARGBString:DEFAULT_COLOR];
}

-(void)setColorForKey:(NSString *)key toObject:(id)obj
{
  UIColor *color = [self getColorForKey:key];

  if (!obj)
    return ;
  else
  {
    if ([obj isKindOfClass:[UILabel class]])
      [(UILabel *)obj setTextColor:color];
    else if ([obj isKindOfClass:[UIButton class]])
    {
      //            [((UIButton *)obj).titleLabel setTextColor:color];
      [((UIButton *)obj) setTitleColor:color forState:UIControlStateNormal];
    }
    else if ([obj respondsToSelector:@selector(setColor:)])
      [obj setColor:color];
    else if ([obj respondsToSelector:@selector(setTintColor:)])
      [obj setTintColor:color];
  }
}

@end
