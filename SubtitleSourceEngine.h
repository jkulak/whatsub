//
//  SubtitleSourceEngine.h
//  WhatSub
//
//  Created by Jakub Kulak on 24.05.2013.
//  Copyright (c) 2013 burningtomato.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubtitleSourceEngine : NSObject

@property (assign) NSString* user;
@property (assign) NSString* pass;
@property (assign) NSString* lang;

- (NSString*) getHash: (NSString*)moviePath;
- (NSString*) getToken: (NSString*)hash;
- (NSString*) getURLForHash: (NSString*)hash token: (NSString*)token;

- (NSData*)retrieveSubtitlesForMovieInPath:(NSString*)moviePath hash:(NSString**)hashPtr;
- (id)initWithUser:(NSString*)username password:(NSString*)password language:(NSString*)langCode;

@end