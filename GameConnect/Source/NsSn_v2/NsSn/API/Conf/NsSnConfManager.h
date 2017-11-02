//
//  NsSnConfManager.h
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef JAST_API_URL
#define JAST_API_URL @"https://minijast-integration.netcodev.com" // Dev
#endif

#ifndef NSSN_API_URL
#define NSSN_API_URL @"https://nsapi-integration.netcodev.com" // Dev
#endif

#ifndef NSSN_API_VERSION
#define NSSN_API_VERSION @"1"
#endif

#ifndef NSSN_API_CLIENT_ID
#define NSSN_API_CLIENT_ID @"a366c46b-ccf5-4583-a681-8c819ede64fc"
#endif

#ifndef NSSN_API_CLIENT_SECRET
#define NSSN_API_CLIENT_SECRET @"29113a661772583261db287788522d796cd908c4"
#endif

typedef enum
{
    NsSnConfigValueImageDns,
    NsSnConfigValueImageTTL
} NsSnConfigValue;

typedef enum
{
    // NEW API
    NsSnConfigURLCheckEmail,
    NsSnConfigURLCheckNickname,
    
    NsSnConfigURLSubscribe,
    NsSnConfigURLSubscribeSecutix,
    NsSnConfigURLLoginByMail,
    NsSnConfigURLLoginSecutix,
    NsSnConfigURLRecoverPasswordSecutix,
    NsSnConfigURLLoginTVA,
    NsSnConfigURLLogout,
    NsSnConfigURLUserUpdateProfile,
    NsSnConfigURLUserUpdatePassword,
    NsSnConfigURLUserUpdateMetadatas,
    NsSnConfigURLUserSearchByMetadatas,
    NsSnConfigURLUserSearchByMetadatasPaginated,

    NsSnConfigURLFriendAdd,
    NsSnConfigURLFriendRemove,
    NsSnConfigURLFriendAcceptPending,
    NsSnConfigURLFriendDenyPending,
    NsSnConfigURLFriendsList,
    NsSnConfigURLFriendsListPaginated,
    NsSnConfigURLMyFriendsList,
    NsSnConfigURLMyFriendsListPaginated,
    NsSnConfigURLFriendsListPendingOutgoing,
    NsSnConfigURLFriendsListPendingIncoming,
    NsSnConfigURLAllMyFriendsListPaginated,

    NsSnConfigURLMessageJastAuthorized,
    NsSnConfigURLMessageHistory,
    NsSnConfigURLMessageGetThreadByUsers,
    NsSnConfigURLMessagePostThread,
    NsSnConfigURLMessagePostUsers,

    NsSnConfigURLImportLinkedInNetwork,
    NsSnConfigURLImportFacebookNetwork,
    NsSnConfigURLUploadAvatar,

    NsSnConfigURLSecutixTicketById,
    NsSnConfigURLSecutixTicketsList,
    
    NsSnConfigURLBucketSetByName,
    NsSnConfigURLBucketGetByName,
    
    
    // OLD API => To re-validate
    NsSnConfigURLTagGetTags,
    NsSnConfigURLTagGetTag,
    NsSnConfigURLDeleteTag,
    NsSnConfigURLTagGetFeedsTag,
    NsSnConfigURLTagGetFeedsTagAPI,
    NsSnConfigURLTagGetFeed,
    NsSnConfigURLTagGetUserTags,
    NsSnConfigURLTagGetSubscribeUsers,
    NsSnConfigURLTagSave,
    NsSnConfigURLTagUpdate,
    NsSnConfigURLTagSubscribe,
    NsSnConfigURLTagUnSubscribe,
    NsSnConfigURLTagDenySubscribe,
    NsSnConfigURLTagAcceptSubscribe,

    NsSnConfigURLTagAddFavorite,
    NsSnConfigURLTagDeleteFavorite,
    NsSnConfigURLTagInvite,
    NsSnConfigURLTagDirectInvite,
    NsSnConfigURLTagAcceptInvitation,
    NsSnConfigURLTagDenyInvitation,
    NsSnConfigURLTagReportAbuse,
    
    NsSnConfigURLDeleteFeeds,
    NsSnConfigURLFeedSave,
    NsSnConfigURLFeedUnLike,
    NsSnConfigURLFeedLike,
    NsSnConfigURLFeedReportAbuse,
    NsSnConfigURLFeedCommentAdd,
    NsSnConfigURLFeedCommentDelete,
    NsSnConfigURLFeedCommentLike,
    NsSnConfigURLFeedCommentunLike,
    NsSnConfigURLFeedCommentReportAbuse,

    NsSnConfigURLUserInfo,
    NsSnConfigURLUserTop,
    NsSnConfigURLUserReportAbuse,

    // Third party
    NsSnConfigURLAddThirdParty,
    NsSnConfigURLTagInviteThirdParty,
    
    NsSnConfigURLTagApiGSMTeam,

} NsSnConfigURL;

@interface NsSnConfManager : NSObject

@property (strong, nonatomic) NSString *NSAPI_JAST_HOST;

@property (strong, nonatomic) NSString *NSAPI_URL;
@property (strong, nonatomic) NSString *NSAPI_VERSION;

@property (strong, nonatomic) NSString *NSAPI_CLIENT_ID;
@property (strong, nonatomic) NSString *NSAPI_CLIENT_SECRET;

@property (strong, nonatomic) NSString *PREFERED_LANGUAGE;

+(NsSnConfManager *) getInstance;

-(id)getValue:(NsSnConfigValue)value;
-(NSString*)getURL:(NsSnConfigURL)value;

@end
