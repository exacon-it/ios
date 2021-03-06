//
//  CCUtility.m
//  Crypto Cloud Technology Nextcloud
//
//  Created by Marino Faggiana on 02/02/16.
//  Copyright (c) 2014 TWS. All rights reserved.
//
//  Author Marino Faggiana <m.faggiana@twsweb.it>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "CCUtility.h"

#import "CCGraphics.h"

#import <netinet/in.h>
#import <openssl/x509.h>
#import <openssl/bio.h>
#import <openssl/err.h>
#import <openssl/pem.h>

@implementation CCUtility

#pragma --------------------------------------------------------------------------------------------
#pragma mark ======================= KeyChainStore ==================================
#pragma --------------------------------------------------------------------------------------------

+ (void)deleteAllChainStore
{
    [UICKeyChainStore removeAllItems];
    [UICKeyChainStore removeAllItemsForService:serviceShareKeyChain];
}

+ (void)storeAllChainInService
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    
    NSArray *items = store.allItems;
    
    for (NSDictionary *item in items) {
        
        [UICKeyChainStore setString:[item objectForKey:@"value"] forKey:[item objectForKey:@"key"] service:serviceShareKeyChain]; 
        [UICKeyChainStore removeItemForKey:[item objectForKey:@"key"]];
    }
}

#pragma ------------------------------ ADMIN

+ (void)adminRemoveIntro
{
    NSString *version = [self getVersionCryptoCloud];
    [UICKeyChainStore setString:nil forKey:version service:serviceShareKeyChain];
}

+ (void)adminRemovePasscode
{
    NSString *uuid = [self getUUID];
    [UICKeyChainStore setString:nil forKey:uuid service:serviceShareKeyChain];
}

+ (void)adminRemoveVersion
{
    [UICKeyChainStore setString:@"0.0" forKey:@"version" service:serviceShareKeyChain];
}

#pragma ------------------------------ SET

+ (void)setKeyChainPasscodeForUUID:(NSString *)uuid conPasscode:(NSString *)passcode
{
    [UICKeyChainStore setString:passcode forKey:uuid service:serviceShareKeyChain];
}

+ (NSString *)setVersionCryptoCloud
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    [UICKeyChainStore setString:version forKey:@"version" service:serviceShareKeyChain];
    
    return version;
}

+ (void)setBlockCode:(NSString *)blockcode
{
    [UICKeyChainStore setString:blockcode forKey:@"blockcode" service:serviceShareKeyChain];
}

+ (void)setSimplyBlockCode:(BOOL)simply
{
    NSString *sSimply = (simply) ? @"true" : @"false";
    [UICKeyChainStore setString:sSimply forKey:@"simplyblockcode" service:serviceShareKeyChain];
}

+ (void)setOnlyLockDir:(BOOL)lockDir
{
    NSString *sLockDir = (lockDir) ? @"true" : @"false";
    [UICKeyChainStore setString:sLockDir forKey:@"onlylockdir" service:serviceShareKeyChain];
}

+ (void)setOptimizedPhoto:(BOOL)resize
{
    NSString *sOptimizedPhoto = (resize) ? @"true" : @"false";
    [UICKeyChainStore setString:sOptimizedPhoto forKey:@"optimizedphoto" service:serviceShareKeyChain];
}

+ (void)setUploadAndRemovePhoto:(BOOL)remove
{
    NSString *sRemovePhoto = (remove) ? @"true" : @"false";
    [UICKeyChainStore setString:sRemovePhoto forKey:@"uploadremovephoto" service:serviceShareKeyChain];
}

+ (void)setSynchronizationsOnlyWiFi:(BOOL)onlyWiFi
{
    NSString *sSynchronizationsOnlyWiFi = (onlyWiFi) ? @"true" : @"false";
    [UICKeyChainStore setString:sSynchronizationsOnlyWiFi forKey:@"synchronizationsonlywifi" service:serviceShareKeyChain];
}

+ (void)setOrderSettings:(NSString *)order
{
    [UICKeyChainStore setString:order forKey:@"order" service:serviceShareKeyChain];
}

+ (void)setAscendingSettings:(BOOL)ascendente
{
    NSString *sAscendente = (ascendente) ? @"true" : @"false";
    [UICKeyChainStore setString:sAscendente forKey:@"ascending" service:serviceShareKeyChain];
}

+ (void)setGroupBySettings:(NSString *)groupby
{
    [UICKeyChainStore setString:groupby forKey:@"groupby" service:serviceShareKeyChain];
}

+ (void)setIntro:(NSString *)version
{
    [UICKeyChainStore setString:@"true" forKey:version service:serviceShareKeyChain];
}

+ (void)setMessageJailbroken:(BOOL)message
{
    NSString *sMessage = (message) ? @"true" : @"false";
    [UICKeyChainStore setString:sMessage forKey:@"jailbroken" service:serviceShareKeyChain];
}

+ (void)setActiveAccountShareExt:(NSString *)activeAccount
{
    [UICKeyChainStore setString:activeAccount forKey:@"activeAccountShareExt" service:serviceShareKeyChain];
}

+ (void)setCryptatedShareExt:(BOOL)cryptated
{
    NSString *sCryptated = (cryptated) ? @"true" : @"false";
    [UICKeyChainStore setString:sCryptated forKey:@"cryptatedShareExt" service:serviceShareKeyChain];
}

+ (void)setServerUrlShareExt:(NSString *)serverUrl
{
    [UICKeyChainStore setString:serverUrl forKey:@"serverUrlShareExt" service:serviceShareKeyChain];
}

+ (void)setTitleServerUrlShareExt:(NSString *)titleServerUrl
{
    [UICKeyChainStore setString:titleServerUrl forKey:@"titleServerUrlShareExt" service:serviceShareKeyChain];
}

+ (void)setEmail:(NSString *)email
{
    [UICKeyChainStore setString:email forKey:@"email" service:serviceShareKeyChain];
}

+ (void)setHint:(NSString *)hint
{
    [UICKeyChainStore setString:hint forKey:@"hint" service:serviceShareKeyChain];
}

+ (void)setDirectoryOnTop:(BOOL)directoryOnTop
{
    NSString *sDirectoryOnTop = (directoryOnTop) ? @"true" : @"false";
    [UICKeyChainStore setString:sDirectoryOnTop forKey:@"directoryOnTop" service:serviceShareKeyChain];
}

#pragma ------------------------------ GET

+ (NSString *)getKeyChainPasscodeForUUID:(NSString *)uuid
{
    if (!uuid) return nil;
    
    NSString *passcode = [UICKeyChainStore stringForKey:uuid service:serviceShareKeyChain];
    
    return passcode;
}

+ (NSString *)getUUID
{
#if TARGET_IPHONE_SIMULATOR
    NSUUID *deviceId = [[NSUUID alloc]initWithUUIDString:UUID_SIM];
    return [deviceId UUIDString];
#else
    NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    return uuid;
#endif
}

+ (NSString *)getNameCurrentDevice
{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)getVersionCryptoCloud
{
    return [UICKeyChainStore stringForKey:@"version" service:serviceShareKeyChain];
}

+ (NSString *)getBlockCode
{
    return [UICKeyChainStore stringForKey:@"blockcode" service:serviceShareKeyChain];
}

+ (BOOL)getSimplyBlockCode
{
    NSString *simplyBlockCode = [UICKeyChainStore stringForKey:@"simplyblockcode" service:serviceShareKeyChain];
    
    if (simplyBlockCode == nil) {
        
        [self setSimplyBlockCode:YES];
        return YES;
    }
    
    return [simplyBlockCode boolValue];
}

+ (BOOL)getOnlyLockDir
{
    return [[UICKeyChainStore stringForKey:@"onlylockdir" service:serviceShareKeyChain] boolValue];
}

+ (BOOL)getOptimizedPhoto
{
    return [[UICKeyChainStore stringForKey:@"optimizedphoto" service:serviceShareKeyChain] boolValue];
}

+ (BOOL)getUploadAndRemovePhoto
{
    return [[UICKeyChainStore stringForKey:@"uploadremovephoto" service:serviceShareKeyChain] boolValue];
}

+ (BOOL)getSynchronizationsOnlyWiFi
{
    return [[UICKeyChainStore stringForKey:@"synchronizationsonlywifi" service:serviceShareKeyChain] boolValue];
}

+ (NSString *)getOrderSettings
{
    NSString *order = [UICKeyChainStore stringForKey:@"order" service:serviceShareKeyChain];
    
    if (order == nil) {
        
        [self setOrderSettings:@"fileName"];
        return @"fileName";
    }
    
    return order;
}

+ (BOOL)getAscendingSettings
{
    NSString *ascending = [UICKeyChainStore stringForKey:@"ascending" service:serviceShareKeyChain];
    
    if (ascending == nil) {
        
        [self setAscendingSettings:YES];
        return YES;
    }
    
    return [ascending boolValue];
}

+ (NSString *)getGroupBySettings
{
    NSString *groupby = [UICKeyChainStore stringForKey:@"groupby" service:serviceShareKeyChain];
    
    if (groupby == nil) {
        
        [self setGroupBySettings:@"none"];
        return @"none";
    }
    
    return groupby;
}

+ (BOOL)getIntro:(NSString *)version
{
    return [[UICKeyChainStore stringForKey:version service:serviceShareKeyChain] boolValue];
}

+ (NSString *)getIncrementalNumber
{
    long number = [[UICKeyChainStore stringForKey:@"incrementalnumber" service:serviceShareKeyChain] intValue];
    
    number++;
    if (number >= 9999) number = 1;
    
    [UICKeyChainStore setString:[NSString stringWithFormat:@"%ld", number] forKey:@"incrementalnumber"];
    
    return [NSString stringWithFormat:@"%04ld", number];
}

+ (BOOL)getMessageJailbroken
{
    return [[UICKeyChainStore stringForKey:@"jailbroken" service:serviceShareKeyChain] boolValue];
}

+ (NSString *)getActiveAccountShareExt
{
    return [UICKeyChainStore stringForKey:@"activeAccountShareExt" service:serviceShareKeyChain];
}

+ (BOOL)getCryptatedShareExt
{
    return [[UICKeyChainStore stringForKey:@"cryptatedShareExt" service:serviceShareKeyChain] boolValue];
}

+ (NSString *)getServerUrlShareExt
{
    return [UICKeyChainStore stringForKey:@"serverUrlShareExt" service:serviceShareKeyChain];
}

+ (NSString *)getTitleServerUrlShareExt
{
    return [UICKeyChainStore stringForKey:@"titleServerUrlShareExt" service:serviceShareKeyChain];
}

+ (NSString *)getEmail
{
    return [UICKeyChainStore stringForKey:@"email" service:serviceShareKeyChain];
}

+ (NSString *)getHint
{
    return [UICKeyChainStore stringForKey:@"hint" service:serviceShareKeyChain];
}

+ (BOOL)getDirectoryOnTop
{
    return [[UICKeyChainStore stringForKey:@"directoryOnTop" service:serviceShareKeyChain] boolValue];
}

#pragma --------------------------------------------------------------------------------------------
#pragma mark ===== Varius =====
#pragma --------------------------------------------------------------------------------------------

+ (NSString *)getUserAgent:(NSString *)typeCloud
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    /*** NEXTCLOUD OWNCLOUD ***/
    
    if ([typeCloud isEqualToString:typeCloudOwnCloud])
        return [NSString stringWithFormat:@"%@%@",@"Mozilla/5.0 (iOS) CryptoCloud-iOS/",appVersion];
    
    if ([typeCloud isEqualToString:typeCloudNextcloud])
        return [NSString stringWithFormat:@"%@%@",@"Mozilla/5.0 (iOS) Nextcloud-iOS/",appVersion];
    
    return [NSString stringWithFormat:@"%@%@",@"Mozilla/5.0 (iOS) Nextcloud-iOS/",appVersion];
}

+ (NSString *)dateDiff:(NSDate *) convertedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    //NSDate *convertedDate = [df dateFromString:origDate];
    //NSDate *convertedDate = [NSDate dateWithTimeIntervalSince1970:origDate];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return NSLocalizedString(@"_never_", nil);
    } else 	if (ti < 60) {
        return NSLocalizedString(@"_less_a_minute_", nil);
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:NSLocalizedString(@"_minutes_ago_", nil), diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:NSLocalizedString(@"_hours_ago_", nil), diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:NSLocalizedString(@"_days_ago_", nil), diff];
    } else {
        return NSLocalizedString(@"_over_30_days_", nil);
    }
}

+ (NSString *)transformedSize:(double)value
{
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",nil];
    while (value > 1024) {
        value /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f %@",value, [tokens objectAtIndex:multiplyFactor]];
}

// Replace NSUTF8StringEncoding and remove do not forbidden characters
+ (NSString *)clearFile:(NSString *)nomeFile
{
    NSArray *arrayForbiddenCharacters = [NSArray arrayWithObjects:@"\\",@"<",@">",@":",@"\"",@"|",@"?",@"*",@"/", nil];
    
    nomeFile = [nomeFile stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    for (NSString *currentCharacter in arrayForbiddenCharacters) {
        nomeFile = [nomeFile stringByReplacingOccurrencesOfString:currentCharacter withString:@""];
    }
    
    return nomeFile;
}

+ (NSString*)stringAppendServerUrl:(NSString *)serverUrl addServerUrl:(NSString *)addServerUrl
{
    NSString *result;
    
    if (serverUrl == nil || addServerUrl == nil) return nil;
    
    if ([serverUrl isEqualToString:@"/"]) result = [serverUrl stringByAppendingString:addServerUrl];
    else result = [NSString stringWithFormat:@"%@/%@", serverUrl, addServerUrl];
    
    return result;
}

+ (NSString *)createID
{
    int numeroCaratteri = 16;
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: numeroCaratteri];
    
    for (int i=0; i < numeroCaratteri; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((unsigned int)[letters length]) % [letters length]]];
    }
    
    return [NSString stringWithFormat:@"%@", randomString];
}

+ (NSString *)createFileNameFromAsset:(PHAsset *)asset
{
    NSDate *assetDate = asset.creationDate;
    
    NSString *assetFileName = [asset valueForKey:@"filename"];
    
    NSString *numberFileName;
    if ([assetFileName length] > 8) numberFileName = [assetFileName substringWithRange:NSMakeRange(04, 04)];
    else numberFileName = [CCUtility getIncrementalNumber];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *filenameDate = [formatter stringFromDate:assetDate];
    
    NSString *filenameExt = [[assetFileName pathExtension] lowercaseString];
    NSString *fileNameUpload = [NSString stringWithFormat:@"%@ %@.%@", filenameDate, numberFileName, filenameExt];
    
    return fileNameUpload;
}

+ (NSString *)getHomeServerUrlActiveUrl:(NSString *)activeUrl typeCloud:(NSString *)typeCloud
{
    if (activeUrl == nil || typeCloud == nil) return nil;
    
    NSString *home;
    
    /*** NEXTCLOUD OWNCLOUD ***/
    
    if ([typeCloud isEqualToString:typeCloudOwnCloud] || [typeCloud isEqualToString:typeCloudNextcloud])
        home = [activeUrl stringByAppendingString:webDAV];
    
    /*** DROPBOX ***/

    if ([typeCloud isEqualToString:typeCloudDropbox])
        home = @"/";
    
    return home;
}

// Return path of User Crypto Cloud / <user dir>
+ (NSString *)getDirectoryActiveUser:(NSString *)activeUser activeUrl:(NSString *)activeUrl
{
    NSURL *dirGroup = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:capabilitiesGroups];
    NSString *user = activeUser;
    NSString *baseUrl = [activeUrl lowercaseString];
    NSString *dirUserBaseUrl = nil;
    NSString *dirApplicationUserGroup = nil;
    
    if ([user length] && [baseUrl length]) {
        
        if ([baseUrl hasPrefix:@"https://"]) baseUrl = [baseUrl substringFromIndex:8];
        if ([baseUrl hasPrefix:@"http://"]) baseUrl = [baseUrl substringFromIndex:7];
        
        dirUserBaseUrl = [NSString stringWithFormat:@"%@-%@", user, baseUrl];
        dirUserBaseUrl = [[self clearFile:dirUserBaseUrl] lowercaseString];
    } else return @"";
    
    dirApplicationUserGroup = [[dirGroup URLByAppendingPathComponent:appApplicationSupport] path];
    dirUserBaseUrl = [NSString stringWithFormat:@"%@/%@", dirApplicationUserGroup, dirUserBaseUrl];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: dirUserBaseUrl]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirUserBaseUrl withIntermediateDirectories:YES attributes:nil error:nil];
    }
        
    return dirUserBaseUrl;
}

+ (NSString *)getOLDDirectoryActiveUser:(NSString *)activeUser activeUrl:(NSString *)activeUrl
{
    NSString *user = activeUser;
    NSString *baseUrl = [activeUrl lowercaseString];
    NSString *dirUserBaseUrl = nil;
    
    if ([user length] && [baseUrl length]) {
        
        if ([baseUrl hasPrefix:@"https://"]) baseUrl = [baseUrl substringFromIndex:8];
        if ([baseUrl hasPrefix:@"http://"]) baseUrl = [baseUrl substringFromIndex:7];
        
        dirUserBaseUrl = [NSString stringWithFormat:@"%@-%@", user, baseUrl];
        dirUserBaseUrl = [[self clearFile:dirUserBaseUrl] lowercaseString];
    } else return @"";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    dirUserBaseUrl = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], dirUserBaseUrl];
    
    return dirUserBaseUrl;
}

// Return the path of directory Local -> NSDocumentDirectory
+ (NSString *)getDirectoryLocal
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

// Return the path of directory Crypto Cloud / Audio
+ (NSString *)getDirectoryAudio
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    
    return [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], @"audio"];
}

// Return the path of directory Cetificates
+ (NSString *)getDirectoryCerificates
{
    NSURL *dirGroup = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:capabilitiesGroups];
    
    NSString *dir = [[dirGroup URLByAppendingPathComponent:appCertificates] path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir])
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return dir;
}

+ (NSString *)getTitleSectionDate:(NSDate *)date
{
    NSString * title;
    
    if ([date isEqualToDate:[CCUtility datetimeWithOutTime:[NSDate distantPast]]]) {
        
        title =  NSLocalizedString(@"_no_date_", nil);
        
    } else {
        
        title = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterFullStyle timeStyle:0];
        
        if ([date isEqualToDate:[CCUtility datetimeWithOutTime:[NSDate date]]])
            title = [NSString stringWithFormat:NSLocalizedString(@"_today_", nil)];
    }
    
    return title;
}

+ (void)moveFileAtPath:(NSString *)atPath toPath:(NSString *)toPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:atPath]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:atPath toPath:toPath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:atPath error:nil];
    }
}

+ (void)copyFileAtPath:(NSString *)atPath toPath:(NSString *)toPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:atPath]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:atPath toPath:toPath error:nil];
    }
}

+ (void)removeAllFileID_UPLOAD_ActiveUser:(NSString *)activeUser activeUrl:(NSString *)activeUrl
{
    NSString *file;
    NSString *dir;
    
    dir = [self getDirectoryActiveUser:activeUser activeUrl:activeUrl];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:dir];
    
    while (file = [enumerator nextObject]) {
        
        if ([file rangeOfString:@"ID_UPLOAD_"].location != NSNotFound)
            [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", dir, file] error:nil];
    }
}

+ (NSString *)deletingLastPathComponentFromServerUrl:(NSString *)serverUrl
{
    NSURL *url = [[NSURL URLWithString:[serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] URLByDeletingLastPathComponent];
    
    NSString *pather = [[url absoluteString] stringByRemovingPercentEncoding];
    
    return [pather substringToIndex: [pather length] - 1];
}

+ (void)sendMailEncryptPass:(NSString *)recipient validateEmail:(BOOL)validateEmail form:(id)form
{
    BOOL error = NO;
    
    if (validateEmail)
        error = ![self isValidEmail:recipient];
    
    if (!error)
        error = ![MFMailComposeViewController canSendMail];
    
    if (!error) {
        
        NSString *key = [CCUtility getKeyChainPasscodeForUUID:[CCUtility getUUID]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = form;
        
        [mc setSubject:[self localizableBrand:@"_title_mail_encryptpass_" table:nil]];
        
        NSString *htmlMsg =[NSString stringWithFormat:@"<html><body><p>%@ : %@ , %@</p></body></html>", NSLocalizedString(@"_text1_mail_encryptpass_", nil), key, NSLocalizedString(@"_text2_mail_encryptpass_", nil)];
        
        NSData *jpegData = UIImageJPEGRepresentation([UIImage imageNamed:image_brandSfondoiPad], 1.0);
        [mc addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:@"cryptocloud.png"];
        [mc setMessageBody:htmlMsg isHTML:YES];
        
        if ([self isValidEmail:recipient])
            [mc setToRecipients:@[recipient]];
        
        [form presentViewController:mc animated:YES completion:NULL];
        
    } else {
        
        UIAlertController * alert= [UIAlertController alertControllerWithTitle:NSLocalizedString(@"_error_", nil) message:NSLocalizedString(@"_mail_not_can_send_mail_", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"_ok_", nil)  style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [alert addAction:ok];
        [form presentViewController:alert animated:YES completion:nil];
    }
}

+ (NSString *)localizableBrand:(NSString *)localize table:(NSString *)table
{
    NSString *translate;
    
    if (table)
        translate = NSLocalizedStringFromTable(localize, table, nil);
    else
        translate = NSLocalizedString(localize, nil);
    
    translate = [translate stringByReplacingOccurrencesOfString:@"_brand_" withString:_brand_];
    translate = [translate stringByReplacingOccurrencesOfString:@"_mail_me_" withString:_mail_me_];
    
    return translate;
}

#pragma --------------------------------------------------------------------------------------------
#pragma mark ===== CCMetadata =====
#pragma --------------------------------------------------------------------------------------------

#ifdef CC
+ (CCMetadata *)trasformedMetadataToMetadata:(DBMetadata *)dbMetadata fileNamePrint:(NSString *)fileNamePrint serverUrl:(NSString *)serverUrl directoryID:(NSString *)directoryID cameraFolderName:(NSString *)cameraFolderName cameraFolderPath:(NSString *)cameraFolderPath activeAccount:(NSString *)activeAccount directoryUser:(NSString *)directoryUser
{
    CCMetadata *metadata = [[CCMetadata alloc] init];
    
    metadata.account = activeAccount;
    metadata.cryptated = NO;
    metadata.date = dbMetadata.lastModifiedDate;
    metadata.directory = dbMetadata.isDirectory;
    metadata.errorPasscode = NO;
    metadata.fileID = dbMetadata.rev;
    metadata.directoryID = directoryID;
    metadata.fileName = [CCUtility clearFile:dbMetadata.filename];
    metadata.fileNameData = [CCUtility trasformedFileNamePlistInCrypto:metadata.fileName];
    metadata.fileNamePrint = [CCUtility clearFile:fileNamePrint];
    metadata.iconName = @"";
    metadata.model = @"";
    metadata.nameCurrentDevice = [CCUtility getNameCurrentDevice];
    metadata.permissions = @"";
    metadata.protocol = @"";
    metadata.rev = dbMetadata.rev;
    metadata.size = (long)dbMetadata.totalBytes;
    metadata.thumbnailExists = dbMetadata.thumbnailExists;
    metadata.title = @"";
    metadata.type = metadataType_file;
    metadata.typeFile = @"";
    metadata.typeCloud = typeCloudDropbox;
    metadata.uuid = [CCUtility getUUID];
    
    switch ([self getTypeFileName:metadata.fileName]) {
            
        case metadataTypeFilenamePlist:
            
            metadata.cryptated = YES;
            metadata.fileNamePrint = NSLocalizedString(@"_download_plist_", nil);
            
            [self insertInformationPlist:metadata directoryUser:directoryUser];
            
            break;
            
        case metadataTypeFilenameCrypto:
            
            metadata.cryptated = YES;
            metadata.fileNamePrint = @"";
            
            break;
    }

    [self insertTypeFileIconName:metadata directory:serverUrl cameraFolderName:cameraFolderName cameraFolderPath:cameraFolderPath];
    
    return metadata;
}
#endif

+ (CCMetadata *)trasformedOCFileToCCMetadata:(OCFileDto *)itemDto fileNamePrint:(NSString *)fileNamePrint serverUrl:(NSString *)serverUrl directoryID:(NSString *)directoryID cameraFolderName:(NSString *)cameraFolderName cameraFolderPath:(NSString *)cameraFolderPath activeAccount:(NSString *)activeAccount directoryUser:(NSString *)directoryUser typeCloud:(NSString *)typeCloud
{
    CCMetadata *metadata = [[CCMetadata alloc] init];
    
    metadata.account = activeAccount;
    metadata.cryptated = NO;
    metadata.date = [NSDate dateWithTimeIntervalSince1970:itemDto.date];
    metadata.directory = itemDto.isDirectory;
    metadata.errorPasscode = false;
    metadata.fileID = itemDto.ocId;
    metadata.directoryID = directoryID;
    metadata.fileName = [CCUtility clearFile:itemDto.fileName];
    metadata.fileNameData = [CCUtility trasformedFileNamePlistInCrypto:metadata.fileName];
    metadata.fileNamePrint = [CCUtility clearFile:fileNamePrint];
    metadata.iconName = @"";
    metadata.model = @"";
    metadata.nameCurrentDevice = [CCUtility getNameCurrentDevice];
    metadata.permissions = itemDto.permissions;
    metadata.protocol = @"";
    metadata.rev = itemDto.etag;
    metadata.size = itemDto.size;
    metadata.title = @"";
    metadata.type = metadataType_file;
    metadata.typeFile = @"";
    metadata.typeCloud = typeCloud;
    metadata.uuid = [CCUtility getUUID];
    
    switch ([self getTypeFileName:metadata.fileName]) {
            
        case metadataTypeFilenamePlist:
            
            metadata.cryptated = YES;            
            metadata.fileNamePrint = NSLocalizedString(@"_download_plist_", nil);
            
            [self insertInformationPlist:metadata directoryUser:directoryUser];
            
            break;
            
        case metadataTypeFilenameCrypto:
            
            metadata.cryptated = YES;
            metadata.fileNamePrint = @"";
            
            break;
    }
    
    [self insertTypeFileIconName:metadata directory:serverUrl cameraFolderName:cameraFolderName cameraFolderPath:cameraFolderPath];
    
    return metadata;
}

+ (void)insertTypeFileIconName:(CCMetadata *)metadata directory:(NSString *)directory cameraFolderName:(NSString *)cameraFolderName cameraFolderPath:(NSString *)cameraFolderPath
{
    if ([metadata.type isEqualToString:metadataType_model]) {
        
        metadata.typeFile = metadataTypeFile_template;
        
    } else if (!metadata.directory) {
        
        CFStringRef fileExtension = (__bridge CFStringRef)[metadata.fileNamePrint pathExtension];
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        
        NSString *ext = (__bridge NSString *)fileExtension;
        ext = ext.uppercaseString;

        /*** NEXTCLOUD OWNCLOUD ***/
        
        // thumbnailExists for typeCloudOwnCloud
        if ([metadata.typeCloud isEqualToString:typeCloudOwnCloud] || [metadata.typeCloud isEqualToString:typeCloudNextcloud]) {
            
            
            if([ext isEqualToString:@"JPG"] || [ext isEqualToString:@"PNG"] || [ext isEqualToString:@"JPEG"] || [ext isEqualToString:@"GIF"] || [ext isEqualToString:@"BMP"] || [ext isEqualToString:@"MP3"]  || [ext isEqualToString:@"MOV"]  || [ext isEqualToString:@"MP4"]  || [ext isEqualToString:@"M4V"] || [ext isEqualToString:@"3GP"])
                metadata.thumbnailExists = YES;
            else
                metadata.thumbnailExists = NO;
        }
        // if wrong code, icon protect
        if (metadata.errorPasscode) {
            metadata.typeFile = metadataTypeFile_unknown;
            metadata.iconName = image_plist;
            return;
        }
        // Type compress
        if (UTTypeConformsTo(fileUTI, kUTTypeZipArchive) && [(__bridge NSString *)fileUTI containsString:@"org.openxmlformats"] == NO && [(__bridge NSString *)fileUTI containsString:@"oasis"] == NO) {
            metadata.typeFile = metadataTypeFile_compress;
            if (metadata.cryptated) metadata.iconName = image_typeFileCompress;
            else metadata.iconName = image_typeFileCompress;
        }
        // Type image
        else if (UTTypeConformsTo(fileUTI, kUTTypeImage)) {
            metadata.typeFile = metadataTypeFile_image;
            if (metadata.cryptated) metadata.iconName = image_photocrypto;
            else metadata.iconName = image_photo;
        }
        // Type Video
        else if (UTTypeConformsTo(fileUTI, kUTTypeMovie)) {
            metadata.typeFile = metadataTypeFile_video;
            if (metadata.cryptated) metadata.iconName = image_moviecrypto;
            else metadata.iconName = image_movie;
        }
        // Type Audio
        else if (UTTypeConformsTo(fileUTI, kUTTypeAudio)) {
            metadata.typeFile = metadataTypeFile_audio;
            if (metadata.cryptated) metadata.iconName = image_audiocrypto;
            else metadata.iconName = image_audio;
        }
        // Type Document [DOC] [PDF] [XLS] [TXT] (RTF = "public.rtf" - ODT = "org.oasis-open.opendocument.text") [MD]
        else if (UTTypeConformsTo(fileUTI, kUTTypeContent) || [ext isEqualToString:@"MD"]) {
            
            metadata.typeFile = metadataTypeFile_document;
            if (metadata.cryptated) metadata.iconName = image_documentcrypto;
            else metadata.iconName = image_document;
            
            NSString *typeFile = (__bridge NSString *)fileUTI;
            
            if ([typeFile isEqualToString:@"com.adobe.pdf"]) {
                if (metadata.cryptated) metadata.iconName = image_pdfcrypto;
                else metadata.iconName = image_pdf;
            }
            
            if ([typeFile isEqualToString:@"org.openxmlformats.spreadsheetml.sheet"]) {
                if (metadata.cryptated) metadata.iconName = image_xlscrypto;
                else metadata.iconName = image_xls;
            }
            
            if ([typeFile isEqualToString:@"com.microsoft.excel.xls"]) {
                if (metadata.cryptated) metadata.iconName = image_xlscrypto;
                else metadata.iconName = image_xls;
            }
            
            if ([typeFile isEqualToString:@"public.plain-text"] || [ext isEqualToString:@"MD"]) {
                if (metadata.cryptated) metadata.iconName = image_txtcrypto;
                else metadata.iconName = image_txt;
            }
            
            if ([typeFile isEqualToString:@"public.html"]) {
                if (metadata.cryptated) metadata.iconName = image_filetype_htlm_crypto;
                else metadata.iconName = image_filetype_htlm;
            }
            
        } else {
            
            // Type unknown
            metadata.typeFile = metadataTypeFile_unknown;
            
            // icon uTorrent
            if ([(__bridge NSString *)fileExtension isEqualToString:@"torrent"]) {
                
                if (metadata.cryptated) metadata.iconName = image_utorrentcrypto;
                else metadata.iconName = image_utorrent;
            } else {
            
                if (metadata.cryptated) metadata.iconName = image_plist;
                else metadata.iconName = image_file;
            }
        }
        
    } else {
        // icon directory
        metadata.typeFile = metadataTypeFile_directory;
        
        if (metadata.cryptated) metadata.iconName = image_foldercrypto;
        else metadata.iconName = image_folder;
        
        if([metadata.fileName isEqualToString:cameraFolderName] && [directory isEqualToString:cameraFolderPath])
            metadata.iconName = image_folderphotocamera;
    }
}

+ (void)insertInformationPlist:(CCMetadata *)metadata directoryUser:(NSString *)directoryUser
{
    NSString *fileNamePlist, *temp, *passcode;
    NSError *error;
    
    CCCrypto *crypto = [[CCCrypto alloc] init];
    
    // find the plist
    // 1) directory temp
    // 2) directory serverUrl
    
    temp = [NSTemporaryDirectory() stringByAppendingString:metadata.fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:temp]) fileNamePlist = temp;
    else {
        temp = [NSString stringWithFormat:@"%@/%@", directoryUser, metadata.fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:temp]) fileNamePlist = temp;
    }
    
    if (!fileNamePlist) return;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:fileNamePlist];
    NSString *title =  [data objectForKey:@"title"];
    NSString *len = [data objectForKey:@"len"];
    NSString *uuid = [data objectForKey:@"uuid"];
    
    // AutoInsert password if possible Versione 1.3
    [crypto autoInsertPasscodeUUID:uuid text:title];
    
    passcode = [crypto getKeyPasscode:uuid];

    metadata.cryptated = YES;
    metadata.directory = [[data objectForKey:@"dir"] boolValue];
    metadata.iconName = [data objectForKey:@"icon"];
    metadata.model = [data objectForKey:@"model"];
    metadata.nameCurrentDevice = [data objectForKey:@"namecurrentdevice"];
    metadata.protocol = [data objectForKey:@"protocol"];
    metadata.size = (long) [len longLongValue];
    if ([data objectForKey:@"image"] == nil)
        metadata.thumbnailExists = NO;
    else
        metadata.thumbnailExists = YES;
    metadata.title = title;
    metadata.type = [data objectForKey:@"type"];
    metadata.uuid = uuid;
    
    // Optimization V2.12
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.ico", directoryUser, metadata.fileID]] && !metadata.directory) {
    
        // exists image V1.8
        NSData *imageData = [data objectForKey:@"image"];
        if (imageData) {
        
            if (passcode) imageData = [RNDecryptor decryptData:imageData withSettings:kRNCryptorAES256Settings password:passcode error:&error];
            else imageData = nil;
        
            if (imageData && error == nil) {
            
                UIImage *image = [UIImage imageWithData:imageData];
                if (image) {
                
                    if (image.size.width == 128 && image.size.height == 128)
                        [CCGraphics saveIcoWithFileID:metadata.fileID image:image writeToFile:[NSString stringWithFormat:@"%@/%@.ico", directoryUser, metadata.fileID] copy:NO move:NO fromPath:nil toPath:nil];
                    else
                        [CCGraphics saveIcoWithFileID:metadata.fileID image:[CCGraphics scaleImage:image toSize:CGSizeMake(128, 128)] writeToFile:[NSString stringWithFormat:@"%@/%@.ico", directoryUser, metadata.fileID] copy:NO move:NO fromPath:nil toPath:nil];
                }
            }
        }
    }
    
    if (passcode) {
        
        metadata.fileNamePrint = [AESCrypt decrypt:title password:passcode];
        
        if ([metadata.fileNamePrint length]) {
            
            metadata.errorPasscode = false;
            
        } else {
            
            // succede che è stata inserito un Passcode nuovo per lo stesso UUID
            metadata.fileNamePrint = NSLocalizedString(@"_insert_password_", nil);
            metadata.errorPasscode = true;
        }
        
    } else {
        
        metadata.errorPasscode = true;
        if (!metadata.uuid) metadata.fileNamePrint = NSLocalizedString(@"_download_plist_", nil);
        else metadata.fileNamePrint = NSLocalizedString(@"_insert_password_", nil);
    }
}

+ (CCMetadata *)insertFileSystemInMetadata:(NSString *)fileName directory:(NSString *)directory activeAccount:(NSString *)activeAccount cameraFolderName:(NSString *)cameraFolderName cameraFolderPath:(NSString *)cameraFolderPath
{
    CCMetadata *metadata = [[CCMetadata alloc] init];
    
    NSString *fileNamePath = [NSString stringWithFormat:@"%@/%@", directory, fileName];
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileNamePath error:nil];
    
    metadata.account = activeAccount;
    metadata.date = attributes[NSFileModificationDate];
    
    BOOL isDirectory;
    [[NSFileManager defaultManager] fileExistsAtPath:fileNamePath isDirectory:&isDirectory];
    metadata.directory = isDirectory;
    
    metadata.errorPasscode = false;
    metadata.fileID = fileName;
    metadata.directoryID = directory;
    metadata.fileName = fileName;
    metadata.fileNameData = fileName;
    metadata.fileNamePrint = fileName;
    metadata.nameCurrentDevice = [CCUtility getNameCurrentDevice];
    metadata.protocol = versionProtocolPlist;
    metadata.size = [attributes[NSFileSize] longValue];
    metadata.thumbnailExists = false;
    metadata.type = metadataType_local;
    metadata.title = @"";
    metadata.uuid = [CCUtility getUUID];
    
    if ([CCUtility isCryptoPlistString:fileName])
        [CCUtility insertInformationPlist:metadata directoryUser:directory];
    
    [self insertTypeFileIconName:metadata directory:directory cameraFolderName:cameraFolderName cameraFolderPath:cameraFolderPath];
    
    return metadata;
}

// Return file name plist -> crypto
+ (NSString *)trasformedFileNamePlistInCrypto:(NSString *)fileName
{
    if([self isCryptoPlistString:fileName])
        return [fileName substringToIndex:[fileName length] - 6];
    
    return fileName;
}

// Return file name crypto -> plist
+ (NSString *)trasformedFileNameCryptoInPlist:(NSString *)fileName
{
    if([self isCryptoString:fileName])
        return [fileName stringByAppendingString:@".plist"];
    
    return fileName;
}

// It's file crypto ? 64 + crypto = 70
+ (BOOL)isCryptoString:(NSString *)fileName
{
    NSString *crypto;
    if ([fileName length] != 70) return false;
    
    crypto = [fileName substringWithRange:NSMakeRange(64, 6)];
    
    if ([crypto isEqualToString:@"crypto"]) return true;
    else return false;
}

// It's file crypto.plist ? 64 + crypto.plist = 76
+ (BOOL)isCryptoPlistString:(NSString *)fileName
{
    NSString *cryptoPlist;
    if ([fileName length] != 76) return false;
    
    cryptoPlist = [fileName substringWithRange:NSMakeRange(64, 12)];
    
    if ([cryptoPlist isEqualToString:@"crypto.plist"]) return true;
    else return false;
}

// It's file plain
+ (BOOL)isFileNotCryptated:(NSString *)filename
{
    if ([self isCryptoPlistString:filename] == NO && [self isCryptoString:filename] == NO) return true;
    else return false;
}

// It's file encrypted
+ (BOOL)isFileCryptated:(NSString *)filename
{
    if ([self isCryptoPlistString:filename] == YES || [self isCryptoString:filename] == YES) return true;
    else return false;
}

+ (NSInteger)getTypeFileName:(NSString *)fileName
{
    NSUInteger len = [fileName length];
    
    switch (len) {
            
        case 70:
            
            if ([[fileName substringWithRange:NSMakeRange(64, 6)] isEqualToString:@"crypto"]) return metadataTypeFilenameCrypto;
            else return metadataTypeFilenamePlain;
            break;
            
        case 76:
            
            if ([[fileName substringWithRange:NSMakeRange(64, 12)] isEqualToString:@"crypto.plist"]) return metadataTypeFilenamePlist;
            else return metadataTypeFilenamePlain;
            break;
            
        default:
            
            return metadataTypeFilenamePlain;
            break;
    }
    
    return metadataTypeFilenamePlain;
}

#pragma --------------------------------------------------------------------------------------------
#pragma mark ===== Third parts =====
#pragma --------------------------------------------------------------------------------------------

+ (NSString *)stringValueForKey:(id)key conDictionary:(NSDictionary *)dictionary
{
    id obj = [dictionary objectForKey:key];
    
    if ([obj isEqual:[NSNull null]]) return @"";
    
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj stringValue];
    }
    else {
        return [obj description];
    }
}

+ (NSString *)currentDevice
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceName=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //NSLog(@"[LOG] Device Name :%@",deviceName);
    
    return deviceName;
}

+ (NSString *)getExtension:(NSString*)fileName
{
    NSMutableArray *fileNameArray =[[NSMutableArray alloc] initWithArray: [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]]];
    NSString *extension = [NSString stringWithFormat:@"%@",[fileNameArray lastObject]];
    extension = [extension uppercaseString];
    //If the file has a ZIP extension obtain the previous one for check if it is a .pages.zip / .numbers.zip / .key.zip extension
    if ([extension isEqualToString:@"ZIP"]) {
        [fileNameArray removeLastObject];
        NSString *secondExtension = [NSString stringWithFormat:@"%@",[fileNameArray lastObject]];
        secondExtension = [secondExtension uppercaseString];
        if ([secondExtension isEqualToString:@"PAGES"] || [secondExtension isEqualToString:@"NUMBERS"] || [secondExtension isEqualToString:@"KEY"]) {
            extension = [NSString stringWithFormat:@"%@.%@",secondExtension,extension];
            return extension;
        }
    }
    return extension;
}

/*
 * Util method to make a NSDate object from a string from xml
 * @dateString -> Data string from xml
 */
+ (NSDate*)parseDateString:(NSString*)dateString
{
    //Parse the date in all the formats
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    /*In most cases the best locale to choose is "en_US_POSIX", a locale that's specifically designed to yield US English results regardless of both user and system preferences. "en_US_POSIX" is also invariant in time (if the US, at some point in the future, changes the way it formats dates, "en_US" will change to reflect the new behaviour, but "en_US_POSIX" will not). It will behave consistently for all users.*/
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    //This is the format for the concret locale used
    [dateFormatter setDateFormat:@"EEE, dd MMM y HH:mm:ss zzz"];
    
    NSDate *theDate = nil;
    NSError *error = nil;
    if (![dateFormatter getObjectValue:&theDate forString:dateString range:nil error:&error]) {
        NSLog(@"[LOG] Date '%@' could not be parsed: %@", dateString, error);
    }
    
    return theDate;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}

+ (NSDate *)datetimeWithOutTime:(NSDate *)datDate
{
    if (datDate == nil) return nil;
    
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
    datDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    return datDate;
}

+ (NSDate *)datetimeWithOutDate:(NSDate *)datDate
{
    if (datDate == nil) return nil;
    
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (BOOL)isValidEmail:(NSString *)checkString
{
    checkString = [checkString lowercaseString];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

@end
