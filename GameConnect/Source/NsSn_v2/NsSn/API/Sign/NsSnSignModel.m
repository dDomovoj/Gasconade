//
//  NsSnSignModel.m
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "NsSnSignModel.h"
#import "NsSnConfManager.h"
#import "NsSnRequester.h"
#import "Extends+Libs.h"
#import "BridgedLanguageManager.h"

@interface NsSnSignModel()
{
    NSArray *arrayOfCustomMandatoryData;
}
@end

@implementation NsSnSignModel

-(NSDictionary*)toDictionary
{
    NSDictionary *dict = @{@"nickname":self.nickname,
                           @"password":self.password,
                           @"email":self.email,
                           @"password":self.password,
                           @"country":self.country,
                           @"last_name":self.nom,
                           @"first_name":self.prenom,
                           @"visibility" : [NsSnSignModel giveMeStringFromNsUserVisibility:self.visiblity] };
    return dict;
}

+(NSString *)giveMeStringFromNsUserVisibility:(eNsUserVisibility)eVisibility
{
    NSString *visibility = nil;
    switch (eVisibility)
    {
        case NSVisibilityOnlyMe:
            visibility = @"only_me";
            break;
        case NSVisibilityOnlyFriends:
            visibility = @"only_friends";
            break;
        case NSVisibilityEverybody:
            visibility = @"everybody";
            break;
        default:
            visibility = @"everybody";
            break;
    }
    return visibility;
}

+(eNsUserVisibility)giveMeNsUserVisibilityFromString:(NSString *)visibility
{
    if ([visibility isEqualToString:@"only_me"])
        return NSVisibilityOnlyMe;
    else if ([visibility isEqualToString:@"only_friends"])
        return NSVisibilityOnlyFriends;
    else if ([visibility isEqualToString:@"everybody"])
        return  NSVisibilityEverybody;
    else
        return NSVisibilityNone;
}

+(NSString *)giveMeNsUserVisibilityFromEnumNsUserVisibility:(eNsUserVisibility)visibility
{
    if (visibility == NSVisibilityOnlyMe)
        return @"only_me";
    else if (visibility == NSVisibilityOnlyFriends)
        return @"only_friends";
    else if (visibility == NSVisibilityEverybody)
        return @"everybody";
    else
        return @"";
}

+(NSString *)giveMeStringFromNsUserGender:(eNsUserGender)eGender
{
    NSString *gender = nil;
    switch (eGender)
    {
        case NSGenderMale:
            gender = @"male";
            break;
            
        case NSGenderFemale:
            gender = @"female";
            break;
        case NSGenderNone:
            gender = @"other";
            break;
        default:
            gender = @"other";
            break;
    }
    return gender;
}

-(NSString *)dateOfBirthToString
{
    NSString *deviceLanguage = [BridgedLanguageManager applicationLanguage];
    if ([NsSnConfManager getInstance].PREFERED_LANGUAGE && [[NsSnConfManager getInstance].PREFERED_LANGUAGE length] > 0)
        deviceLanguage = [NsSnConfManager getInstance].PREFERED_LANGUAGE;

    NSString *format = @"MM/dd/yyyy";
    if ([deviceLanguage isEqualToString:@"fr"] ||
        [deviceLanguage isEqualToString:@"pt"] ||
        [deviceLanguage isEqualToString:@"ja"])
        format = @"dd/MM/yyyy";
    
    return [self dateOfBirthToStringWithFormat:format];
}

-(NSString *)dateOfBirthToStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *dateOfBirth = [dateFormatter dateFromString:[self.dateOfBirth trim]];
    return [NsSnSignModel NSDateToISO8601String:dateOfBirth];
}

+(NSString *) NSDateToISO8601String:(NSDate *)dateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2013-11-18T23:00:00.324Z
    formatter.locale = [NSLocale systemLocale];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    return [formatter stringFromDate:dateTime];
}

#pragma mark - Custom Mandatory Data

-(void) setMoreMandatoryData:(NSArray *)mandatoryInfoTypes
{
    if (mandatoryInfoTypes && [mandatoryInfoTypes count] > 0)
    {
        arrayOfCustomMandatoryData = mandatoryInfoTypes;
    }
}

#pragma mark - Model Validation

-(eNsSnSignError)validateSigningModel
{
    __block eNsSnSignError error = eNsSnSignErrorNone;
    [arrayOfCustomMandatoryData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        if (obj && [obj isKindOfClass:[NSNumber class]])
        {
            error = [self validateCustomMandatoryData:[obj intValue]];
            if (error != eNsSnSignErrorNone)
            {
                *stop = YES;
            }
        }
    }];
    
    if (error != eNsSnSignErrorNone)
        return error;

    // NSAPI REQUIRES THESE DATA => CANNOT BE MODIFIED
    
    error = [self validateEmail];
    if (error == eNsSnSignErrorNone)
    {
        error = [self validateNickname];
        if (error == eNsSnSignErrorNone)
        {
            error = [self validatePassword];
            if (error == eNsSnSignErrorNone)
            {
                error = [self validateConfirmPassword];
                if (error == eNsSnSignErrorNone)
                {
                    NSString *country = [self.country trim];
                    if (country && [country length] != 3)
                        return eNsSnSignErrorBadCountryFormat;
                    return eNsSnSignErrorNone;
                }
            }
        }
    }
    return error;
}

-(eNsSnSignError)validateCustomMandatoryData:(NSProfileInfoType)profileInfoType
{
    switch (profileInfoType)
    {
        case NSProfileInfoGender:
        {
            if (self.gender == NSGenderNone)
                return eNsSnSignErrorNoGender;
                
        } break;
            
        case NSProfileInfoFirstName:
        {
            if (!self.prenom || [self.prenom length] == 0)
                return eNsSnSignErrorNoFirstName;
        } break;
            
        case NSProfileInfoLastName:
        {
            if (!self.nom || [self.nom length] == 0)
                return eNsSnSignErrorNoLastName;
        } break;
            
        case NSProfileInfoDoB:
        {
            if (!self.dateOfBirth || [self.dateOfBirth length] == 0)
                return eNsSnSignErrorNoDOB;
            
            else if ([self validateDateOfBirth] != eNsSnSignErrorNone)
                return [self validateDateOfBirth];
        } break ;
            
        default:
            return eNsSnSignErrorNone;
            break;
    }
    return eNsSnSignErrorNone;
}

-(eNsSnSignError)validateDateOfBirth
{
    NSString *DOB = [self dateOfBirthToString];
    if (DOB && [DOB length] > 0)
        return eNsSnSignErrorNone;
    else
        return eNsSnSignErrorBadDOBFormat;
}

-(eNsSnSignError)validateNickname
{
    NSString *login = [self.nickname trim];
    
    if ([login length] < 4)
        return eNsSnSignErrorLoginLength;
    else
    {
//        NSError *error;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9\\.;:_\\(\\),\\?\\+=]+$" options:NSRegularExpressionCaseInsensitive error:&error];
//        NSArray *matches = [regex matchesInString:login options:0 range:NSMakeRange(0, [login length])];
//
//        NSTextCheckingResult *match = nil;
//        if (matches && [matches count] == 1)
//            match = [matches objectAtIndex:0];
//        
//        if (!match || [match range].length != [login length]) // NOT GOOD
//            return eNsSnSignErrorBadLoginFormat;
    }
    return eNsSnSignErrorNone;
}

-(eNsSnSignError)validateEmail
{
    NSString *email = [self.email trim];
    if (![NSString validateEmail:email])
        return eNsSnSignErrorBadEmailFormat;
    return eNsSnSignErrorNone;
}

-(eNsSnSignError)validatePassword
{
    NSString *password = [self.password trim];
    if ([password length] < 4)
        return eNsSnSignErrorPasswordLength;
    else
    {
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([A-Za-z]|[0-9])+$" options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *matches = [regex matchesInString:password options:0 range:NSMakeRange(0, [password length])];
        
        NSTextCheckingResult *match = nil;
        if (matches && [matches count] == 1)
            match = [matches objectAtIndex:0];
        
        if (!match || [match range].length != [password length]) // NOT GOOD
            return eNsSnSignErrorBadPasswordFormat;
    }
    return eNsSnSignErrorNone;
}

-(eNsSnSignError)validateConfirmPassword
{
    NSString *password = [self.password trim];
    NSString *confirm_password = [self.confirm_password trim];
    
    if ([password isNotEqualToString:confirm_password])
        return eNsSnSignErrorPasswordsDifferent;
    return eNsSnSignErrorNone;
}


#pragma mark - Special Secutix

-(NSDictionary *)toSecutixDictionary
{
    if ([self validateSecutix])
    {
        NSDictionary *post = @{
                               @"first_name":self.prenom,
                               @"last_name":self.nom,
                               @"email":self.email,
                               @"password":self.password,
                               @"function":self.function,
                               @"company":self.company,
                               };
        return post;
    }
    return nil;
}

-(BOOL)validateSecutix
{
    if ([self.email length] < 4)
        return NO;
    if ([self.password length] < 4)
        return NO;
    return YES;
}
@end
