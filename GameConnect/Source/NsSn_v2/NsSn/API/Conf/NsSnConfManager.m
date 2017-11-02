//
//  NsSnConfManager.m
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnConfManager.h"
#import "NSObject+NSObject_Tool.h"
#import "BridgedLanguageManager.h"

@implementation NsSnConfManager

#pragma Singleton
+(NsSnConfManager *) getInstance
{
    static NsSnConfManager *nssnConfManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nssnConfManager = [[self alloc] init];
    });
    return nssnConfManager;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.NSAPI_URL = NSSN_API_URL;
        self.NSAPI_VERSION = NSSN_API_VERSION;
        self.NSAPI_JAST_HOST = JAST_API_URL;
        self.NSAPI_CLIENT_ID = NSSN_API_CLIENT_ID;
        self.NSAPI_CLIENT_SECRET = NSSN_API_CLIENT_SECRET;
        self.PREFERED_LANGUAGE = [BridgedLanguageManager applicationLanguage];
    }
    return self;
}

-(id)getValue:(NsSnConfigValue)value
{
    switch (value)
    {
        case NsSnConfigValueImageDns:
            return self.NSAPI_URL;
            break;
        case NsSnConfigValueImageTTL:
            return @(60*60*24);
            break;
        default:
            break;
    }
}

-(NSString*)getURL:(NsSnConfigURL)value
{
    switch (value)
    {
        // NEW API

            /* Authentification  */
        case NsSnConfigURLCheckEmail:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/email_not_already_used/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;

        case NsSnConfigURLCheckNickname:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/nickname_not_already_used/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;

        case NsSnConfigURLSubscribe:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/subscribe", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
            
        case NsSnConfigURLSubscribeSecutix:
            return [NSString stringWithFormat:@"%@/api/%@/secutix/_/subscribe", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLLoginByMail:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/login_by_email", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLLoginSecutix:
            return [NSString stringWithFormat:@"%@/api/%@/secutix/_/login", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLRecoverPasswordSecutix:
            return [NSString stringWithFormat:@"%@/api/%@/secutix/_/recover_password/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
            
        case NsSnConfigURLLoginTVA:
            return [NSString stringWithFormat:@"%@/api/%@/tvasports/_/login", self.NSAPI_URL, self.NSAPI_VERSION];
            break;

        case NsSnConfigURLLogout:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/logout", self.NSAPI_URL, self.NSAPI_VERSION];
            break;

            /* User  */
        case NsSnConfigURLUserInfo:
            return [NSString stringWithFormat:@"%@/api/%@/users/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLUserUpdateProfile:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/update_my_profile", self.NSAPI_URL, self.NSAPI_VERSION];
            break;

        case NsSnConfigURLUserUpdatePassword:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/update_my_password", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
            
        case NsSnConfigURLUserUpdateMetadatas:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/update_my_metadatas", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLUserSearchByMetadatas:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/search", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLUserSearchByMetadatasPaginated:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/search/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"_/pages/p%d/l%d"];
            break;

        case NsSnConfigURLFriendAdd:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/friend_request/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLFriendRemove:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/remove_friend/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@"];
            break;
        case NsSnConfigURLFriendAcceptPending:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/accept_pending_friend_request/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLFriendDenyPending:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/deny_pending_friend_request/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLFriendsList:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/list_friends/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLFriendsListPaginated:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/list_friends/%@/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@", @"_/pages/p%d/l%d"];
            break;
        case NsSnConfigURLMyFriendsList:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/list_my_friends", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLMyFriendsListPaginated:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/list_my_friends/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"_/pages/p%d/l%d"];
            break;
        case NsSnConfigURLFriendsListPendingOutgoing:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/list_my_outgoing_requests", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLFriendsListPendingIncoming:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/list_my_incoming_requests", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLAllMyFriendsListPaginated:
            return [NSString stringWithFormat:@"%@/api/%@/friends/_/list_all_my/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"_/pages/p%d/l%d"];
            break;
            
        case NsSnConfigURLMessagePostThread:
            return [NSString stringWithFormat:@"%@/api/%@/threads/_/post_to_thread", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLMessagePostUsers:
            return [NSString stringWithFormat:@"%@/api/%@/threads/_/post_to_users", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
        case NsSnConfigURLMessageHistory:
            return [NSString stringWithFormat:@"%@/api/%@/threads/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLMessageGetThreadByUsers:
            return [NSString stringWithFormat:@"%@/api/%@/threads/_/find_by_users", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
            
        case NsSnConfigURLMessageJastAuthorized:
            return [NSString stringWithFormat:@"%@/my_credentials", self.NSAPI_JAST_HOST];
            break;

        case NsSnConfigURLImportLinkedInNetwork:
            return [NSString stringWithFormat:@"%@/api/%@/linkedin/_/import_network/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];

        case NsSnConfigURLImportFacebookNetwork:
            return [NSString stringWithFormat:@"%@/api/%@/facebook/_/import_network/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            
        case NsSnConfigURLUploadAvatar:
            return [NSString stringWithFormat:@"%@/api/%@/users/_/upload_my_avatar", self.NSAPI_URL, self.NSAPI_VERSION];
            break;

        case NsSnConfigURLSecutixTicketById:
            return [NSString stringWithFormat:@"%@/api/%@/secutix/_/ticket/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLSecutixTicketsList:
            return [NSString stringWithFormat:@"%@/api/%@/secutix/_/tickets", self.NSAPI_URL, self.NSAPI_VERSION];
            break;
            
        case NsSnConfigURLBucketSetByName:
            return [NSString stringWithFormat:@"%@/api/%@/buckets/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLBucketGetByName:
            return [NSString stringWithFormat:@"%@/api/%@/buckets/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
            
            
            
            
            
        // OLD API => To re-validate

        case NsSnConfigURLUserTop:
            return [NSString stringWithFormat:@"%@/api/%@/users/getTopUsers", self.NSAPI_URL, self.NSAPI_VERSION];
            break;

        case NsSnConfigURLTagGetFeedsTag:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/getTagFeeds/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@/%@/%d/%d"];
            break;
        case NsSnConfigURLDeleteFeeds:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/deleteFeed/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLFeedCommentDelete:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/deleteComment/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@/%@"];
            break;
        case NsSnConfigURLFeedCommentLike:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/likeComment/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@/%@"];
            break;
        case NsSnConfigURLFeedCommentunLike:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/unLikeComment/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@/%@"];
            break;
        case NsSnConfigURLTagGetFeedsTagAPI:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/getTagAPIFeeds/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@/%@/%d/%d"];
            break;
        case NsSnConfigURLTagGetFeed:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/getFeed/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLFeedSave:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/postComment/%@", self.NSAPI_URL, self.NSAPI_VERSION, @""];
            break;
        case NsSnConfigURLFeedCommentAdd:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/addComment/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLFeedLike:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/like/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLFeedReportAbuse:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/reportAbuse/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@"];
            break;
        case NsSnConfigURLFeedCommentReportAbuse:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/reportAbuseComment/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@/%@"];
            break;
        case NsSnConfigURLFeedUnLike:
            return [NSString stringWithFormat:@"%@/api/%@/feeds/unLike/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
            
            
        case NsSnConfigURLTagGetTags:
            return [NSString stringWithFormat:@"%@/api/%@/tags/getTags/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%d/%@/%d"];
            break;
        case NsSnConfigURLTagGetTag:
            return [NSString stringWithFormat:@"%@/api/%@/tags/getTag/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLTagGetUserTags:
            return [NSString stringWithFormat:@"%@/api/%@/tags/getUserTags/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@/%@/%d"];
            break;
        case NsSnConfigURLTagSave:
            return [NSString stringWithFormat:@"%@/api/%@/tags/addTag%@", self.NSAPI_URL, self.NSAPI_VERSION, @""];
            break;
        case NsSnConfigURLTagUpdate:
            return [NSString stringWithFormat:@"%@/api/%@/tags/updateTag%@", self.NSAPI_URL, self.NSAPI_VERSION, @""];
            break;
        case NsSnConfigURLDeleteTag:
            return [NSString stringWithFormat:@"%@/api/%@/tags/deleteTag/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLUserReportAbuse:
            return [NSString stringWithFormat:@"%@/api/%@/users/reportAbuse/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@"];
            break;
        case NsSnConfigURLTagSubscribe:
            return [NSString stringWithFormat:@"%@/api/%@/tags/joinTag/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@"];
            break;
        case NsSnConfigURLTagUnSubscribe:
            return [NSString stringWithFormat:@"%@/api/%@/tags/unJoinTag/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@"];
            break;
        case NsSnConfigURLTagAcceptSubscribe:
            return [NSString stringWithFormat:@"%@/api/%@/tags/acceptSubscribe/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@/%@"];
            break;
        case NsSnConfigURLTagDenySubscribe:
            return [NSString stringWithFormat:@"%@/api/%@/tags/denySubscribe/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@/%@"];
            break;
        case NsSnConfigURLTagAddFavorite:
            return [NSString stringWithFormat:@"%@/api/%@/tags/addFavoris/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@/1"];
            break;
        case NsSnConfigURLTagDeleteFavorite:
            return [NSString stringWithFormat:@"%@/api/%@/tags/addFavoris/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@/0"];
            break;
        case NsSnConfigURLTagGetSubscribeUsers:
            return [NSString stringWithFormat:@"%@/api/%@/tags/getSubscribeUsers/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@/%@/%d"];
            break;
        case NsSnConfigURLTagInvite:
            return [NSString stringWithFormat:@"%@/api/%@/tags/invite/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@/%@"];
            break;

        case NsSnConfigURLTagDirectInvite:
            return [NSString stringWithFormat:@"%@/api/%@/tags/inviteDirect/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@/%@"];
            break;
            
        case NsSnConfigURLTagAcceptInvitation :
            return [NSString stringWithFormat:@"%@/api/%@/tags/acceptInvitTag/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLTagDenyInvitation :
            return [NSString stringWithFormat:@"%@/api/%@/tags/denyInvitTag/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
        case NsSnConfigURLTagReportAbuse:
            return [NSString stringWithFormat:@"%@/api/%@/tags/reportAbuse/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
            
            // New from LEJ
        case NsSnConfigURLTagApiGSMTeam:
            return [NSString stringWithFormat:@"%@/api/%@/tags/getTagApiXid/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@"];
            break;
            
            // Third party
        case NsSnConfigURLAddThirdParty:
            return [NSString stringWithFormat:@"%@/api/%@/users/AddThirdParty", self.NSAPI_URL, self.NSAPI_VERSION];
            
        case NsSnConfigURLTagInviteThirdParty:
            return [NSString stringWithFormat:@"%@/api/%@/tags/inviteThirdParty/%@", self.NSAPI_URL, self.NSAPI_VERSION, @"%@/%@/%@"];

            
//        case NsSnConfigURLTagExpulseUser:
//            return [NSString stringWithFormat:@"%@/api/%@/tags/expulse/%@", self.NSAPI_URL, self.NSAPI_VERSION,@"%@/%@"];
        default:
            break;
    }
    return @"";
}

@end
