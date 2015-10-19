//
//  OTDSong.m
//  Off The Dome
//
//  Created by Haaris Muneer on 10/19/15.
//  Copyright © 2015 Haaris Muneer. All rights reserved.
//

#import "OTDSong.h"

@implementation OTDSong

-(instancetype) init {
    self = [self initWithTitle:@"Test Song" artist:@"Test Artist" fileName:@"" bpm:100];
    return self;
}

-(instancetype) initWithTitle:(NSString *)title artist:(NSString *)artist fileName:(NSString *)fileName bpm:(NSUInteger)bpm {
    self = [super init];
    if (self) {
        _title = title;
        _artist = artist;
        _fileName = fileName;
        _bpm = bpm;
    }
    return self;
}

@end
