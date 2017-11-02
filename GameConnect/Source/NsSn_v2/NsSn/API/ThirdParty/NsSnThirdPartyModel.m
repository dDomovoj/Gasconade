//
//  NsSnThirdPartyModel.m
//  PepsiLiveGaming
//
//  Created by Guillaume Derivery on 3/10/14.
//  Copyright (c) 2014 Seb Jallot. All rights reserved.
//

#import "NsSnThirdPartyModel.h"
#import "Extends+Libs.h"

@implementation NsSnThirdPartyModel

-(NSDictionary *)toDictionary
{
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    
    if (self._id)
        [mutableDict setValue:self._id forKey:@"_id"];
    
    if (self.third_party_id)
        [mutableDict setValue:self.third_party_id forKey:@"third_party_id"];
    
    if (self.third_party_key)
        [mutableDict setValue:self.third_party_key forKey:@"third_party_key"];

    if (self.third_party_token)
        [mutableDict setValue:self.third_party_token forKey:@"third_party_token"];
    
    if (self.third_party_token_expiration && self.third_party_token_expiration > 0)
        [mutableDict setValue:[NSNumber numberWithDouble:self.third_party_token_expiration] forKey:@"third_party_token_expiration"];

    if (self.third_party_friends)
        [mutableDict setValue:self.third_party_friends forKey:@"third_party_friends"];
    
    return [mutableDict ToUnMutable];
}

+(NsSnThirdPartyModel*) fromJSON:(NSDictionary*)data
{
    NsSnThirdPartyModel *third_party = [NsSnThirdPartyModel new];
    if (data)
    {
        third_party._id = [data getXpathNilString:@"_id"];
        third_party.third_party_id = [data getXpathNilString:@"third_party_id"];
        third_party.third_party_key = [data getXpathNilString:@"third_party_key"];
        third_party.third_party_token = [data getXpathNilString:@"third_party_token"];
        third_party.third_party_token_expiration = [[data getXpath:@"third_party_token_expiration" type:[NSNumber class] def:@0] doubleValue];
        third_party.third_party_friends = [data getXpathNilArray:@"third_party_friends"];
    }
    return third_party;
}


+(id) fromJSONArray:(NSArray*)data
{
    NSArray *a = [data getXpathNilArray:@"/"];
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    [a each:^(NSInteger index, id elt, BOOL last) {
        [ret addObject:[NsSnThirdPartyModel fromJSON:elt]];
    }];
    return ret;
}

@end
