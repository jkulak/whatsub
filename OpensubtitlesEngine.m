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
        [self setToken:[self authenticate]];
    }
    return self;
}

- (NSString*) authenticate
{
    NSURL *URL = [NSURL URLWithString: @"http://api.opensubtitles.org/xml-rpc"];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    [request setMethod: @"LogIn" withParameters:[NSArray arrayWithObjects:@"", @"", @"", @"OS Test User Agent", nil]];
    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
    
    [request release];
    
    return @"sdsfsdfsdfsdfsdf";
}

- (NSData*)retrieveSubtitlesForMovieInPath:(NSString*)moviePath hash:(NSString**)hashPtr {

//    NSURL *URL = [NSURL URLWithString: @"http://api.opensubtitles.org/xml-rpc"];
//    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
//    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
//
//    [request setMethod: @"CheckMovieHash" withParameters:[NSArray arrayWithObjects:@"08vm7eggi5j310d4vhe6dcev55", [NSArray arrayWithObjects:@"ae34f157eefc093c", nil], nil]];
//
//    NSLog(@"Request body: %@", [request body]);
//
//    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];
//
//    [request release];
    return 0;
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        
        NSLog(@"Parsed response: %@", [response object]);
        
        if ([@"LogIn" isEqual: [request method]]) {
            // LogIn
//            NSLog(@"%@", [request parameters]);
//            NSLog(@"%@", [response object]);
            
            NSString *mySmallerString = [[response object] substringToIndex:4];
            NSLog(@"%@", mySmallerString);
            
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