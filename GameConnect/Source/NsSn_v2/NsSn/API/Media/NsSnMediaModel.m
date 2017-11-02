//
//  NsSnMediaModel.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnMediaModel.h"
#import "Extends+Libs.h"
#import "NsSnLikeModel.h"
#import "NsSnCommentModel.h"
#import "NsSnMediaFormat.h"


@implementation NsSnMediaModel


-(NSDictionary*)toDictionary{
    return nil;
}
-(id) fromJSON:(NSDictionary*)data{
    self.media_name = [data getXpathEmptyString:@"media_name"];
    self.media_original_name = [data getXpathEmptyString:@"media_original_name"];
    self.media_jobid = [data getXpathEmptyString:@"media_jobid"];
    self.media_title = [data getXpathEmptyString:@"media_title"];
    
    
    self.media_nblike = [data getXpathInteger:@"media_nblike"];

    
    self.media_nbcomments = [data getXpathInteger:@"media_nbcomments"];
    
    self.fk_user_id = [data getXpathEmptyString:@"fk_user_id"];
    self.media_base = [data getXpathEmptyString:@"media_base"];
    
    self.media_type = [data getXpathInteger:@"media_type"];
    self.media_prive = [data getXpathEmptyString:@"media_prive"];
    
    self.media_active = [data getXpathInteger:@"media_active"];
    self.created_at = 0;
    NSNumber *createLong = [data getXpath:@"created_at" type:[NSNumber class] def:0];
    if (createLong > 0){
        float createInt = [createLong doubleValue] / 1000.0;
        self.created_at = (int)createInt;
    }

    
    self.media_formats = [NsSnMediaFormat fromJSONArray:[data getXpathNilArray:@"media_formats"]];
    self.Comments = [NsSnCommentModel fromJSONArray:[data getXpathNilArray:@"Comments"]];
    self.Likes = [NsSnLikeModel fromJSONArray:[data getXpathNilArray:@"Likes"]];
    
    return self;
}
-(id) fromJSONArray:(NSDictionary*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnMediaModel fromJSON:elt]];
    }];
    return ret;
}
+(id) fromJSON:(NSDictionary*)data{
    return [[NsSnMediaModel new] fromJSON:data];
}
+(id) fromJSONArray:(NSDictionary*)data{
    return [[NsSnMediaModel new] fromJSONArray:data];
}
-(BOOL)validate{
    return true;
}

@end

