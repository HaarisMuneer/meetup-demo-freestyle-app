//
//  OTDSong.h
//  Off The Dome
//
//  Created by Haaris Muneer on 10/19/15.
//  Copyright © 2015 Haaris Muneer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTDSong : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, assign) NSUInteger bpm;

-(instancetype) initWithTitle: (NSString *)title
                       artist: (NSString *)artist
                     fileName: (NSString *)fileName
                          bpm: (NSUInteger)bpm;

@end
