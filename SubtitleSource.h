//
//  SubtitleSource.h
//  WhatSub
//
//  Created by Jakub Kulak on 24.05.2013.
//  Copyright (c) 2013 burningtomato.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubtitleSource <NSObject>

- (NSData*)retrieveSubtitlesForMovieInPath:(NSString*)moviePath hash:(NSString**)hashPtr;

@end
