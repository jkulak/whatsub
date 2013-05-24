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

- (NSData*)retrieveSubtitlesForMovieInPath:(NSString*)moviePath hash:(NSString**)hashPtr {

    NSURL *URL = [NSURL URLWithString: @"http://api.opensubtitles.org/xml-rpc"];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];

    [request setMethod: @"CheckMovieHash" withParameters:[NSArray arrayWithObjects:@"08vm7eggi5j310d4vhe6dcev55", [NSArray arrayWithObjects:@"ae34f157eefc093c", nil], nil]];

    NSLog(@"Request body: %@", [request body]);

    [manager spawnConnectionWithXMLRPCRequest: request delegate: self];

    [request release];
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    if ([response isFault]) {
        NSLog(@"Fault code: %@", [response faultCode]);
        
        NSLog(@"Fault string: %@", [response faultString]);
    } else {
        NSLog(@"Parsed response: %@", [response object]);
    }
    
    NSLog(@"Response body: %@", [response body]);
}

@end
