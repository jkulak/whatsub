//
//  OpensubtitlesEngine.h
//  WhatSub
//
//  Created by Jakub Kulak on 24.05.2013.
//  Copyright (c) 2013 burningtomato.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubtitleSourceEngine.h"
#import "xmlrpc/xmlrpc.h"

@interface OpensubtitlesEngine : SubtitleSourceEngine <XMLRPCConnectionDelegate>

@end
