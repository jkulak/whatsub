//
//  MGSubtitlesConverter.m
//  WhatSub
//
//  Created by Marcin Grabda on 1/26/10.
//  Copyright 2010 www.burningtomato.com. All rights reserved.
//

#import "SubtitlesConverter.h"
#import "FrameRateCalculator.h"
#import "RegexKitLite.h"

@implementation SubtitlesConverter

NSString* const TMP_REGEX = @"^(\\d+):(\\d+):(\\d+):(.*)";
NSString* const MDVD_REGEX = @"^\\{(\\d+)\\}\\{(\\d+)\\}(.*)";
NSString* const MPL2_REGEX = @"^\\[(\\d+)\\]\\[(\\d+)\\](.*)";

- (void)convert:(NSString*)pathToFile
{	
	NSLog(@"Processing file '%@'...", pathToFile);
	NSError* error = nil;
	
	NSString* fileContents = [NSString stringWithContentsOfFile:pathToFile
													   encoding:NSWindowsCP1250StringEncoding
														  error:&error];
	if (error != nil) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	
	// try LF first
	NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    
	// if everything is in one line, try with CR again
	if ([lines count] < 2) {
		lines = [fileContents componentsSeparatedByString:@"\r"];
	}
    
	NSString* firstLine = [lines objectAtIndex:0];
    NSArray* subRipArray = nil;
    
    if ([[firstLine captureComponentsMatchedByRegex:TMP_REGEX] count] > 0)
    {
        subRipArray = [self processTMPlayer:lines];
    }
    else if ([[firstLine captureComponentsMatchedByRegex:MDVD_REGEX] count] > 0)
    {
        subRipArray = [self processMicroDVD:lines forMovie:pathToFile];
    }
    else if ([[firstLine captureComponentsMatchedByRegex:MPL2_REGEX] count] > 0)
    {
        subRipArray = [self processMPL2:lines];
    }
    else
    {
        NSString* reason = @"Unknown subtitles format";
        NSException* e = [NSException exceptionWithName:@"SubtitlesException" reason:reason userInfo:nil];
        @throw e;
    }
    
    if (subRipArray != nil)
    {
        [self printSubRip:subRipArray];        
    }
}

- (NSArray*)processMicroDVD:(NSArray *)lines forMovie:(NSString *)pathToFile
{
    NSString* moviePath = [[pathToFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"avi"];    
    BOOL movieFileExists = [[NSFileManager defaultManager] fileExistsAtPath:moviePath];
    double framerate = 25.0;
    if (movieFileExists)
    {
        framerate = [FrameRateCalculator calculateFrameRateForMovieInPath:moviePath];
    }
    
    NSArray* capturesArray = nil;
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    
    for (NSString* line in lines) {
		capturesArray = [line captureComponentsMatchedByRegex:MDVD_REGEX];
        
        if ([capturesArray count] > 3)
        {
            int frameStart = [[capturesArray objectAtIndex:1] integerValue];
            double startTime = (double)frameStart / framerate;
            
            int frameEnd = [[capturesArray objectAtIndex:2] integerValue];
            double endTime = (double)frameEnd / framerate;
            
            NSString* text = [capturesArray objectAtIndex:3];            
            NSArray* singleLineArray = [NSArray arrayWithObjects:
                                        [NSNumber numberWithDouble:startTime],
                                        [NSNumber numberWithDouble:endTime], 
                                        text, nil];
            [outputArray addObject:singleLineArray];
        }   
	}
    
    return outputArray;
}

- (NSArray*)processMPL2:(NSArray *)lines
{
    NSArray* capturesArray = nil;
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    
    for (NSString* line in lines) {
		capturesArray = [line captureComponentsMatchedByRegex:MPL2_REGEX];
        
        if ([capturesArray count] > 3)
        {
            int frameStart = [[capturesArray objectAtIndex:1] integerValue];
            double startTime = (double)frameStart / 10;
            
            int frameEnd = [[capturesArray objectAtIndex:2] integerValue];
            double endTime = (double)frameEnd / 10;
            
            NSString* text = [capturesArray objectAtIndex:3];
            NSArray* singleLineArray = [NSArray arrayWithObjects:
                                        [NSNumber numberWithDouble:startTime],
                                        [NSNumber numberWithDouble:endTime],
                                        text, nil];
            [outputArray addObject:singleLineArray];
        }   
	}
    
    return outputArray;
}

- (NSArray*)processTMPlayer:(NSArray *)lines
{
    NSArray* capturesArray = nil;
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    
    for (NSString* line in lines) {
		capturesArray = [line captureComponentsMatchedByRegex:TMP_REGEX];
        
        if ([capturesArray count] > 4)
        {
            int hour = [[capturesArray objectAtIndex:1] integerValue];
            int minute = [[capturesArray objectAtIndex:2] integerValue];
            int second = [[capturesArray objectAtIndex:3] integerValue];
            
            int startTime = hour * 3600 + minute * 60 + second;
            int endTime = startTime + 60;
            
            NSString* text = [capturesArray objectAtIndex:4];
            NSArray* singleLineArray = [NSArray arrayWithObjects:
                                        [NSNumber numberWithInteger:startTime],
                                        [NSNumber numberWithInteger:endTime], 
                                        text, nil];
            [outputArray addObject:singleLineArray];
        }   
	}
    
    return outputArray;
}

- (void)printSubRip:(NSArray *)input
{
    int lineNumber = 1;
    for (NSArray* line in input)
    {
        NSNumber* start = [line objectAtIndex:0];
        NSString* formattedStart = [self formatSubRipTime:start];
        NSNumber* end = [line objectAtIndex:1];
        NSString* formattedEnd = [self formatSubRipTime:end];
        NSString* text = [line objectAtIndex:2];
        NSString* formattedText = [self formatSubRipText:text];
        
        NSString* print = [NSString stringWithFormat:@"%d\n%@ --> %@\n%@\n\n", 
                           lineNumber++, formattedStart, formattedEnd, formattedText, nil];
        NSLog(@"%@", print);
    }
}

/* time conversion from miliseconds */
- (NSString*)formatSubRipTime:(NSNumber*)value
{
    int intValue = [value intValue];
    float floatValue = [value floatValue];

    floatValue -= intValue;
    int miliseconds = floatValue * 1000;
    
    int hours = intValue / 3600;
    intValue -= hours * 3600;
    int minutes = intValue / 60;
    intValue -= minutes * 60;
    int seconds = intValue;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d,%03d", hours, minutes, seconds, miliseconds, nil];
}

/* additional formatting for text */
- (NSString*)formatSubRipText:(NSString*)value
{
    value = [value stringByReplacingOccurrencesOfString:@"/" withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
    return value;
}

@end
