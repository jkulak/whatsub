//
//  OpensubtitlesEngine.h
//  WhatSub
//
//  Created by Jakub Kulak on 24.05.2013.
//  Copyright (c) 2013 burningtomato.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xmlrpc/xmlrpc.h"
#import "SubtitleSource.h"

@interface OpensubtitlesEngine : NSObject <XMLRPCConnectionDelegate,SubtitleSource>

    @property (retain) NSString* token;

- (NSString*) authenticate;

@end
