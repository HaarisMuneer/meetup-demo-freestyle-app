//
//  OTDWordDisplayViewController.h
//  Off The Dome
//
//  Created by Haaris Muneer on 10/19/15.
//  Copyright © 2015 Haaris Muneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface OTDWordDisplayViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *songTableView;

//array property to create with text file
@property (nonatomic, strong) NSMutableArray *wordsToIncorporateArray;
@property (nonatomic, strong) NSTimer *intervalTimer;

@property (nonatomic, strong) NSArray *songs;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayer *scPlayer;

@property (weak, nonatomic) IBOutlet UILabel *randomWordToIncorporateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic) NSUInteger lineMultiplier;

@property (nonatomic, strong) AVSpeechUtterance *wordUtterance;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *wantANewWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *linesLabel;

- (IBAction)stopIntervalTapped:(id)sender;

- (IBAction)segmentTapped:(id)sender;


@end
