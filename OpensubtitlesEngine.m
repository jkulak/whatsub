//
//  OpensubtitlesEngine.m
//  WhatSub
//
//  Created by Jakub Kulak on 24.05.2013.
//  Copyright (c) 2013 burningtomato.com. All rights reserved.
//

#import "OpensubtitlesEngine.h"
#import "xmlrpc/xmlrpc.h"

@implementation OpensubtitlesEngine

- (id)init
{
    self = [super init];
    if (self) {
        [self authenticate];
    }
    return self;
}

- (void) callProcedure:(NSString*)procedure params:(NSArray*)params
{
    NSURL *URL = [NSURL URLWithString: @"http://api.opensubtitles.org/xml-rpc"];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    [request setMethod: procedure withParameters:params];
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
    [request release];
}

- (void) authenticate
{
    [self callProcedure:@"LogIn" params:[NSArray arrayWithObjects:@"", @"", @"", @"OS Test User Agent", nil]];
}

- (void) checkMovieHash:(NSString*)hash
{
    NSLog(@"Current token: %@", [self token]);
    [self callProcedure:@"CheckMovieHash" params:[NSArray arrayWithObjects:[self token], [NSArray arrayWithObjects:hash, nil], nil]];
}

- (NSData*)retrieveSubtitlesForMovieInPath:(NSString*)moviePath hash:(NSString**)hashPtr {

    [self checkMovieHash:@"dab462412773581c"];
    return 0;
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        

        NSDictionary *result = [response object];
        NSLog(@"Parsed response: %@", result);
        
        if ([@"LogIn" isEqual: [request method]]) {
            // LogIn
            [self setToken:[result objectForKey:@"token"]];
            
        } else if ([@"GetMovieHash" isEqual: [request method]]) {

        }
    }
    
//    NSLog(@"Response body: %@", [response body]);
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error {
    
}

- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace {
    return FALSE;
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
    
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge {
    
}

@end