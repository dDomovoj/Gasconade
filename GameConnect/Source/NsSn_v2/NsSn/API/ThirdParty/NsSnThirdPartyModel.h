//
//  NsSnThirdPartyModel.h
//  PepsiLiveGaming
//
//  Created by Guillaume Derivery on 3/10/14.
//  Copyright (c) 2014 Seb Jallot. All rights reserved.
//

#import "NsSnModel.h"

@interface NsSnThirdPartyModel : NsSnModel

@property (nonatomic,retain) NSString *_id;
@property (nonatomic,retain) NSString *third_party_id;
@property (nonatomic,retain) NSString *third_party_key;
@property (nonatomic,retain) NSString *third_party_token;
@property (nonatomic, strong) NSArray *third_party_friends;
@property (assign) NSTimeInterval third_party_token_expiration;

@end
