//
//  SubtitlesDownloader.h
//  WhatSub
//
//  Created by Marcin Grabda on 5/3/11.
//  Copyright 2011 Marcin Grabda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubtitleSource.h"

@class NapiProjektEngine;

@interface SubtitlesDownloader : NSObject
@property id <SubtitleSource> engine;

- (id)initWithEngine:(id <SubtitleSource>)initEngine;
- (NSString*)download:(NSString*)pathToFile;

@end
