//
//  SubtitleSourceEngine.m
//  WhatSub
//
//  Created by Jakub Kulak on 24.05.2013.
//  Copyright (c) 2013 burningtomato.com. All rights reserved.
//

#import "SubtitleSourceEngine.h"

@implementation SubtitleSourceEngine

- (id)initWithUser:(NSString*)username password:(NSString*)password language:(NSString*)langCode {

    if (self = [super init]) {

        [self setUser:username];
        [self setPass:password];
        [self setLang:langCode];
    }
    return self;
}

- (NSData*)retrieveSubtitlesForMovieInPath:(NSString*)moviePath hash:(NSString**)hashPtr {

	NSError* error = nil;
    
    NSString* hash = [self getHash:moviePath];
	NSString* token = [self getToken:hash];
	NSString* urlString = [self getURLForHash:hash token:token];

	NSURL* url = [NSURL URLWithString:urlString];
	
	NSLog(@"Retrieving subtitles from %@", urlString);
	NSData* contents = [NSData dataWithContentsOfURL:url options:0 error:&error];
	
	[hash retain];
	*hashPtr = hash;
	
	char buffer[4];
	[contents getBytes:(char*)buffer length:sizeof(buffer)];
	
	NSString* magic = [[NSString alloc] initWithBytes:buffer length:sizeof(buffer) encoding:NSASCIIStringEncoding];
	if ([magic hasPrefix:@"7z"])
    {
		return contents;
	}
    
    NSString* reason;
    NSString* movieFileName = [moviePath lastPathComponent];
    if ([magic isEqualToString:@"NPc0"])
    {
        reason = [NSString stringWithFormat:@"Subtitles not found for movie %@", movieFileName];
    }
    else
    {
        reason = [NSString stringWithFormat:@"Subtitles for movie %@ could not be downloaded", movieFileName];
    }
	
    NSException* e = [NSException exceptionWithName:@"SubtitlesException" reason:reason userInfo:nil];
    @throw e;
}

- (NSString*) getHash: (NSString*)moviePath {
    
    // implementation in subclasses only
    return NO;
}

- (NSString*) getToken: (NSString*)hash {
    
    // implementation in subclasses only
    return NO;
}

- (NSString*) getURLForHash: (NSString*)hash token:(NSString*)token {
    
	// implementation in subclasses only
    return NO;
}

@end
