//
//  SubtitlesDownloader.h
//  WhatSub
//
//  Created by Marcin Grabda on 5/3/11.
//  Copyright 2011 Marcin Grabda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubtitleSourceEngine.h"

@class NapiProjektEngine;

@interface SubtitlesDownloader : NSObject
@property SubtitleSourceEngine* engine;

- (id)initWithEngine:(SubtitleSourceEngine*)initEngine;
- (NSString*)download:(NSString*)pathToFile;

@end
