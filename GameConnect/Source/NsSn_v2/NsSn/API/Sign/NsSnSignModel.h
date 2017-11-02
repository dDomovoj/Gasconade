//
//  NsSnSignModel.h
//  NsSn
//
//  Created by adelskott on 22/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NsSnThirdPartyModel.h"

typedef enum
{
    eNsSnSignErrorLoginLength,
    eNsSnSignErrorBadLoginFormat,

    eNsSnSignErrorBadPasswordFormat,
    eNsSnSignErrorPasswordLength,

    eNsSnSignErrorPasswordsDifferent,
    eNsSnSignErrorBadEmailFormat,
    eNsSnSignErrorBadCountryFormat,
    
    // For custom mandatory data
    eNsSnSignErrorNoGender,
    eNsSnSignErrorNoFirstName,
    eNsSnSignErrorNoLastName,
    eNsSnSignErrorNoDOB,
    eNsSnSignErrorBadDOBFormat,
    
    eNsSnSignErrorNone,
} eNsSnSignError;

typedef enum
{
    NSVisibilityNone,
    NSVisibilityOnlyMe,
    NSVisibilityOnlyFriends,
    NSVisibilityEverybody,
} eNsUserVisibility;

typedef enum
{
    NSGenderMale,
    NSGenderFemale,
    NSGenderNone,
} eNsUserGender;

typedef enum
{
    NSProfileInfoGender,
    NSProfileInfoFirstName,
    NSProfileInfoLastName,
    NSProfileInfoDoB,
} NSProfileInfoType;

@interface NsSnSignModel : NsSnModel

@property (nonatomic,retain) NSString *nickname;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *confirm_password;
@property (nonatomic,retain) NSString *email;

@property (nonatomic,retain) NSString *prenom;
@property (nonatomic,retain) NSString *nom;

@property (nonatomic) eNsUserVisibility visiblity;

// For Meta data only
@property (nonatomic, retain) NSString *dateOfBirth;
@property (nonatomic) eNsUserGender gender;

@property (nonatomic,retain) NSString *country;

// Secutix exclusive
@property (nonatomic,retain) NSString *function;
@property (nonatomic,retain) NSString *company;

/**
 *  Visibility Management String To Enum and Vice versa
 */
+(eNsUserVisibility)giveMeNsUserVisibilityFromString:(NSString *)visibility;
+(NSString *)giveMeNsUserVisibilityFromEnumNsUserVisibility:(eNsUserVisibility)visibility;

/**
 *  Date of birth
 *  works only if the format is jj/MM/yyyy or MM/jj/yyyy
 *  @return BoB (stored as a String) is returned as NSString FORMATZ ISO8601
 */
-(NSString *)dateOfBirthToString;
-(NSString *)dateOfBirthToStringWithFormat:(NSString *)format;

/**
 *  Add Custom Data as required for Subscription
 *
 *  @param mandatoryInfoTypes Array of infoTypes (c.f enum NSProfileInfoType)
 */
-(void) setMoreMandatoryData:(NSArray *)mandatoryInfoTypes;

/**
 *  Validation Info by Info
 *
 */
-(eNsSnSignError)validateSigningModel;
-(eNsSnSignError)validateDateOfBirth;
-(eNsSnSignError)validateNickname;
-(eNsSnSignError)validateEmail;
-(eNsSnSignError)validatePassword;
-(eNsSnSignError)validateConfirmPassword;

/**
 *  Secutix Management
 */
-(NSDictionary *)toSecutixDictionary;
-(BOOL)validateSecutix;

@end
