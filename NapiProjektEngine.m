//
//  MGNapiProjektEngine.m
//  WhatSub
//
//  Created by Marcin Grabda on 1/28/10.
//  Copyright 2010 Marcin Grabda. All rights reserved.
//

#import "NapiProjektEngine.h"
#import <openssl/md5.h>

@implementation NapiProjektEngine

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
	
	unsigned char *digest = MD5(buffer, length, NULL);
	NSString* md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
						   digest[0], digest[1],
						   digest[2], digest[3],
						   digest[4], digest[5],
						   digest[6], digest[7],
						   digest[8], digest[9],
						   digest[10], digest[11],
						   digest[12], digest[13],
						   digest[14], digest[15]
						   ];
	
	free(buffer);
	
	return md5String;
}

@end
