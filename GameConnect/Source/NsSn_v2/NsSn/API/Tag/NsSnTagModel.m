//
//  NsSnTagModel.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnTagModel.h"
#import "Extends+Libs.h"
#import "UIImageViewJA.h"
#import "NsSnConfManager.h"
#import "NsSnUserManager.h"
#import "NsSnPendingTagModel.h"

@implementation NsSnTagModel


-(NSDictionary*)toDictionary
{
    NSDictionary *post = @{
                           @"title":self.tag_name,
                           @"desc":self.tag_desc,
                           @"priv":@(self.tag_private),
                           };
    if ([self._id length])
    {
        post = @{
                 @"_id":self._id,
                 @"title":self.tag_name,
                 @"desc":self.tag_desc,
                 @"priv":@(self.tag_private),
                 };
        if (self.upimg)
            post = @{
                     @"_id":self._id,
                     @"title":self.tag_name,
                     @"desc":self.tag_desc,
                     @"priv":@(self.tag_private),
                     @"file":self.upimg
                     };
    }
    return post;
}


-(BOOL)validate{
    if ([self.tag_name length] < 4)
        return NO;
    if ([self.tag_desc length] < 4)
        return NO;
    
    return YES;
}

-(void) fromJSON:(NSDictionary*)data{
//    NSLog(@"=> NsSnTagModel - fromJSON : %@", [data description]);
    
    self._id = [data getXpathEmptyString:@"_id"];
    
    self.fk_user_id = [data getXpathEmptyString:@"fk_user_id"];
    self.tag_xid = [data getXpathEmptyString:@"tag_xid"];
    self.tag_type = [data getXpathInteger:@"tag_type"];
    self.tag_name = [data getXpathEmptyString:@"tag_name"];
    self.tag_image_url = [data getXpathEmptyString:@"tag_image_url"];
    self.tag_image = [data getXpathEmptyString:@"tag_image"];
    self.tag_image_name = [data getXpathEmptyString:@"tag_image_name"];
    self.tag_desc = [data getXpathEmptyString:@"tag_desc"];
    self.tag_nbinvites = [data getXpathInteger:@"tag_nbinvites"];
    self.tag_nbfeeds = [data getXpathInteger:@"tag_nbfeeds"];
    self.created_at = 0;
    NSNumber *createLong = [data getXpath:@"created_at" type:[NSNumber class] def:0];
    if (createLong > 0){
        float createInt = [createLong doubleValue] / 1000.0;
        self.created_at = (int)createInt;
    }
    self.tag_last_update = [data getXpathInteger:@"tag_last_update"];
    self.tag_private = [data getXpathInteger:@"tag_private"];
//    self.tag_favorite = [[NsSnUserManager getInstance] isTagFavorite:self._id] ? 1 : 0;
    
    self.Pendings = [NsSnPendingTagModel fromJSONArray:[data getXpathNilArray:@"Pendings"]];
}

+(NsSnTagModel*) fromJSON:(NSDictionary*)data{
    NsSnTagModel *user = [NsSnTagModel new];
    [user fromJSON:data];
    return user;
}

+(id) fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnTagModel fromJSON:elt]];
    }];
    return ret;
}

-(void)setImageViewJARatio:(UIImageViewJA *)imageView
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageDns], @"/m/r/",self.tag_image_url];
    [imageView loadImageFromURL:url ttl:[[[NsSnConfManager getInstance] getValue:NsSnConfigValueImageTTL] unsignedIntValue]];
}


@end
