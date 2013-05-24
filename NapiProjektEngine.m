//
//  MGNapiProjektEngine.m
//  WhatSub
//
//  Created by Marcin Grabda on 1/28/10.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import "NapiProjektEngine.h"
#import <openssl/md5.h>
#import "SubtitleSource.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NapiProjektEngine

- (id)initWithUser:(NSString*)username password:(NSString*)password language:(NSString*)langCode {
    
    if (self = [super init]) {
        
        [self setUser:username];
        [self setPass:password];
        [self setLang:langCode];
    }
    return self;
}

- (NSString*) getHash: (NSString*) moviePath {
    
    return [self md5ForFileInPath:moviePath limitedTo10MB:YES];
}

- (NSString*) getToken:(NSString*) hash {
    
    return [self npFDigest:hash];
}

- (NSString*)getURLForHash:(NSString*)hash token:(NSString*)token {

	NSString* urlFormatString = 
		@"http://napiprojekt.pl/unit_napisy/dl.php?l=%@&f=%@&t=%@&v=other&kolejka=false&nick=%@&pass=%@";
	
	return [NSString stringWithFormat:urlFormatString, [self lang], hash, token, [self user], [self pass]];
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


- (NSString*)npFDigest:(NSString*)input {
	if ([input length] != 32) return @"";
	
	int idx[] = { 0xe, 0x3, 0x6, 0x8, 0x2 },
	mul[] = { 2, 2, 5, 4, 3 },
	add[] = { 0x0, 0xd, 0x10, 0xb, 0x5 },
	a, m, i, t, v;
	
    char vtmp[3] = { 0, 0, 0 };
	char tmp[2] = { 0, 0 };
    
    const char* cin = [input cStringUsingEncoding:NSASCIIStringEncoding];
	NSMutableString* output = [NSMutableString string];
	
	for(int j = 0; j <= 4; j++)
	{
		a = add[j];
		m = mul[j];
		i = idx[j];
		
        tmp[0] = cin[i];
		t = a + (int)(strtol(tmp, NULL, 16));
		
        vtmp[0] = cin[t];
        vtmp[1] = cin[t + 1];
		v = (int)(strtol(vtmp, NULL, 16));
		
		snprintf(tmp, 2, "%x", (v * m) % 0x10);
        
		NSString* tmpString = [NSString stringWithCString:tmp encoding:NSASCIIStringEncoding];                        
		[output appendString:tmpString];
	}
    
	return output;
}

- (NSString*)md5ForFileInPath:(NSString*)path limitedTo10MB:(BOOL)limited
{	
	int length = 10485760;
	void* buffer = malloc(length);
	
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	NSData* data = [fileHandle readDataOfLength:length];
	[data getBytes:buffer length:length];
    
    NSString* md5String = [self MD5StringOfData:data];
	
	free(buffer);
	
	return md5String;
}

- (NSString*) MD5StringOfData:(NSData*)inputData {

	unsigned char outputData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([inputData bytes], [inputData length], outputData);
	
	NSMutableString* hashStr = [NSMutableString string];
	int i = 0;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
		[hashStr appendFormat:@"%02x", outputData[i]];
	return hashStr;
}

@end
