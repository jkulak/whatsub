//
//  MGNapiProjektEngine.h
//  WhatSub
//
//  Created by Marcin Grabda on 1/28/10.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SubtitleSource.h"

@interface NapiProjektEngine : NSObject <SubtitleSource>

@property (assign) NSString* user;
@property (assign) NSString* pass;
@property (assign) NSString* lang;

- (id)initWithUser:(NSString*)username password:(NSString*)password language:(NSString*)langCode;
- (NSString*)npFDigest:(NSString*)input;
- (NSString*)md5ForFileInPath:(NSString*)path limitedTo10MB:(BOOL)limited;
- (NSString*) MD5StringOfData:(NSData*)inputData;

@end
