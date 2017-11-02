//
//  NsSnMessageModel.m
//  NsSn
//
//  Created by adelskott on 23/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnMessageModel.h"
#import "JSONKit.h"
#import "Extends+Libs.h"

@interface NsSnMessageContentModel (Private)

-(NSString*)getMessageContentTypeToString;

@end

@implementation NsSnMessageModel

- (void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self._id forKey:@"id"];
    [aCoder encodeObject:self.thread_id forKey:@"thread_id"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.to forKey:@"to"];
    [aCoder encodeObject:self.from forKey:@"from"];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self._id = [aDecoder decodeObjectForKey:@"id"];
    self.thread_id = [aDecoder decodeObjectForKey:@"thread_id"];
    self.content = [aDecoder decodeObjectForKey:@"content"];
    self.to = [aDecoder decodeObjectForKey:@"to"];
    self.from = [aDecoder decodeObjectForKey:@"from"];
    
    return self;
}


-(BOOL)isOneOfDest:(NSString *)userId{
    __block BOOL ret = NO;
    [self.to each:^(NSInteger index, NsSnUserModel *elt, BOOL last) {
        if ([elt._id isEqualToString:userId])
            ret = YES;
    }];
    return ret;
}

-(NSString*)getListUserTo{
    NSMutableArray *ret = [NSMutableArray new];
    [self.to each:^(NSInteger index, NsSnUserModel *elt, BOOL last) {
        if (elt._id)
            [ret addObject:elt._id];
    }];
    if (self.from._id)
        [ret addObject:self.from._id];
    return [ret componentsJoinedByString:@","];
}

-(NSDictionary*)toDictionary{
    if ([self validate]){
        NSDictionary *post = @{
                               @"to_thread":self.thread_id,
                               @"type":[self.content getMessageContentTypeToString],
                               @"text":self.content.message ? self.content.message : @"",
                               @"image":self.content.img_image ? self.content.img_image : @"",
                               @"ical":self.content.ical ? self.content.ical : @""
                               };
        return post;
    }
    return nil;
}

-(NSDictionary*)toDictionaryPost{
    if ([self validate]){
        NSDictionary *post = @{
                               @"to_user_ids":[self getListUserTo],
                               @"type":[self.content getMessageContentTypeToString],
                               @"text":self.content.message ? self.content.message : @"",
                               @"image":self.content.img_image ? self.content.img_image : @"",
                               @"ical":self.content.ical ? self.content.ical : @""
                               };
        return post;
    }
    return nil;
}


-(BOOL)validate{
    return YES;
}


-(void)fromJSON:(NSDictionary *)data{
    NSLog(@"MSG : %@", data);
    self._id = [data getXpathEmptyString:@"id"];
    self.thread_id = [data getXpathEmptyString:@"thread_id"];
    self.content = [NsSnMessageContentModel fromJSON:[data getXpathNilDictionary:@"content"]];
    self.from = [NsSnUserModel fromJSON:[data getXpathNilDictionary:@"from"]];
    self.to = [NsSnUserModel fromJSONArray:[data getXpathNilArray:@"to"]];
}


+(NsSnMessageModel *)fromJSON:(NSDictionary*)data{
    NsSnMessageModel *message = [NsSnMessageModel new];
    [message fromJSON:data];
    return message;
}

+(id)fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnMessageModel fromJSON:elt]];
    }];
    return ret;
}

@end


@implementation NsSnMessageContentModel


-(NSDictionary*)toDictionary{
    if ([self validate]){
        NSDictionary *post = @{};
        return post;
    }
    return nil;
}



-(BOOL)validate{
    return YES;
}
-(NSString*)getMessageContentTypeToString{
    switch (self.type) {
        case NsSnMessageContentIcal:
            return @"ical";
            break;
        case NsSnMessageContentImage:
            return @"image";
            break;
        case NsSnMessageContentMessage:
            return @"text";
            break;
        default:
            return @"";
            break;
    }
}
+(NsSnMessageContentType)getMessageContentTypeFromString:(NSString*)type{
    if ([type isEqualToString:@"image"])
        return NsSnMessageContentImage;
    if ([type isEqualToString:@"ical"])
        return NsSnMessageContentIcal;
    if ([type isEqualToString:@"text"])
        return NsSnMessageContentMessage;
    return NsSnMessageContentUnknow;
}


-(void)fromJSON:(NSDictionary *)data{
    self.message = [data getXpathEmptyString:@"text"];
    self.image = [data getXpathEmptyString:@"medium_square_url"];
    self.image_big_url = [data getXpathEmptyString:@"image_big_url"];
    self.image_original_url = [data getXpathEmptyString:@"image_original_url"];
    self.ical = [data getXpathEmptyString:@"ical"];
    self.type = [NsSnMessageContentModel getMessageContentTypeFromString:[data getXpathEmptyString:@"type"]];
    if (self.type == NsSnMessageContentIcal){
        NSDictionary *d = [self.ical objectFromJSONString];
        self.message = d[@"titre"];
    }
}


+(NsSnMessageContentModel *)fromJSON:(NSDictionary*)data{
    NsSnMessageContentModel *content = [NsSnMessageContentModel new];
    [content fromJSON:data];
    return content;
}

+(id)fromJSONArray:(NSArray*)data{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnMessageContentModel fromJSON:elt]];
    }];
    return ret;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.type forKey:@"type"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.image forKey:@"medium_square_url"];
    [aCoder encodeObject:self.image_big_url forKey:@"image_big_url"];
    [aCoder encodeObject:self.image_original_url forKey:@"image_original_url"];
    [aCoder encodeObject:self.img_image forKey:@"img_image"];
    [aCoder encodeObject:self.ical forKey:@"ical"];
    [aCoder encodeObject:self.ical_id forKey:@"ical_id"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type = [aDecoder decodeIntForKey:@"type"];
    self.message = [aDecoder decodeObjectForKey:@"message"];
    self.image = [aDecoder decodeObjectForKey:@"medium_square_url"];
    self.image_big_url = [aDecoder decodeObjectForKey:@"image_big_url"];
    self.image_original_url = [aDecoder decodeObjectForKey:@"image_original_url"];
    self.img_image = [aDecoder decodeObjectForKey:@"img_image"];
    self.ical = [aDecoder decodeObjectForKey:@"ical"];
    self.ical_id = [aDecoder decodeObjectForKey:@"ical_id"];
    
    
    return self;
}

@end
