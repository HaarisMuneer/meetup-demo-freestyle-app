//
//  OTDWordDisplayViewController.m
//  Off The Dome
//
//  Created by Haaris Muneer on 10/19/15.
//  Copyright © 2015 Haaris Muneer. All rights reserved.
//

#import "OTDWordDisplayViewController.h"
#import "OTDSong.h"

@interface OTDWordDisplayViewController () <UITableViewDelegate, UITableViewDataSource>



@end

@implementation OTDWordDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  

    self.lineMultiplier = 2;
    self.randomWordToIncorporateLabel.text = @"Off The Dome!";
  self.randomWordToIncorporateLabel.font = [UIFont systemFontOfSize:55];
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    [self setStyle];
  
    self.wordsToIncorporateArray= [[NSMutableArray alloc]init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wordlist" ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
  
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [self.wordsToIncorporateArray addObject:line];
    }
  
    NSLog(@"%@",self.wordsToIncorporateArray);
    
    OTDSong *alienFamily = [[OTDSong alloc]initWithTitle:@"Alien Family (Instrumental)" artist:@"J Dilla" fileName:@"alien" bpm:85];
    OTDSong *work = [[OTDSong alloc]initWithTitle:@"Work (Instrumental)" artist:@"Gang Starr" fileName:@"work" bpm:92];
    OTDSong *flavaInYaEar = [[OTDSong alloc]initWithTitle:@"Flava In Ya Ear (Instrumental)" artist:@"Craig Mack" fileName:@"flava" bpm:90];
    self.songs = @[alienFamily, work, flavaInYaEar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSTimer*)intervalTimer: (CGFloat)delayInterval{
    
    self.intervalTimer = [NSTimer scheduledTimerWithTimeInterval:delayInterval target:self selector:@selector(updateRandomWordLabel) userInfo:nil repeats:YES];
    return self.intervalTimer;
}

- (IBAction)stopIntervalTapped:(id)sender
{
    if (self.intervalTimer) {
        [self.intervalTimer invalidate];
        self.intervalTimer = nil;
    }
    [self.audioPlayer stop];
}

- (IBAction)segmentTapped:(id)sender {
  //lines are placeholder values until calculation for BPM are input
    NSLog(@"selectedSegmentIndex: %lu", self.segmentControl.selectedSegmentIndex);
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            self.lineMultiplier = 2;
            break;
        case 1:
            self.lineMultiplier = 4;
            break;
        default:
            self.lineMultiplier = 8;
            break;
    }
  
}

-(void)updateRandomWordLabel
{
    NSUInteger random = arc4random_uniform((u_int32_t) self.wordsToIncorporateArray.count);
    
    
    self.randomWordToIncorporateLabel.text = self.wordsToIncorporateArray[random];
  self.randomWordToIncorporateLabel.font = [UIFont systemFontOfSize:75];
    self.wordUtterance = [AVSpeechUtterance speechUtteranceWithString:self.randomWordToIncorporateLabel.text];
    [self.synthesizer speakUtterance:self.wordUtterance];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
    OTDSong *song = self.songs[indexPath.row];
    NSString *title = song.title;
    NSString *artist = song.artist;
    NSUInteger bpm = song.bpm;
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", title, artist];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.196 green:0.6 blue:0.733 alpha:1];
    cell.textLabel.textColor = [UIColor colorWithRed:0.259 green:0.259 blue:0.259 alpha:1];
 
  
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu bpm", bpm];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OTDSong *song = self.songs[indexPath.row];
    
    if ([[self.audioPlayer.url absoluteString] containsString:song.fileName]) {
        if (self.audioPlayer.isPlaying) {
            [self.audioPlayer pause];
        }
        else {
            [self.audioPlayer play];
        }
    }
  
    if (self.intervalTimer) {
        [self.intervalTimer invalidate];
        self.intervalTimer = nil;
    }
  
    
    [self setUpAVAudioPlayerWithFileName:song.fileName];
    [self.audioPlayer play];
    CGFloat intervalValue = (240.0/song.bpm) * self.lineMultiplier;
    NSLog(@"lineMultiplier: %lu",self.lineMultiplier);
    NSLog(@"BPM: %lu", song.bpm);
    NSLog(@"intervalValue: %f",intervalValue);
    [self intervalTimer:intervalValue];
    [self updateRandomWordLabel];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)setUpAVAudioPlayerWithFileName:(NSString *)fileName
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"mp3"];
    NSError *error = nil;
//    NSLog(@"%@", url);
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        [self.audioPlayer prepareToPlay];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

-(void)setStyle {
  UIColor *darkMainColor = [UIColor colorWithRed:0.216 green:0.243 blue:0.251 alpha:1];
  UIColor *boldBlue = [UIColor colorWithRed:0.196 green:0.6 blue:0.733 alpha:1];
  UIColor *brightOrange = [UIColor colorWithRed:1 green:0.6 blue:0 alpha:1];
  UIColor *darkGray = [UIColor colorWithRed:0.259 green:0.259 blue:0.259 alpha:1];
  UIColor *lightGray = [UIColor colorWithRed:0.737 green:0.737 blue:0.737 alpha:1];
  UIColor *lighterGray = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
  
  
  
  
    self.segmentControl.tintColor = boldBlue;
    self.songTableView.backgroundColor = [UIColor clearColor];
    self.songTableView.layer.borderWidth = 2.0;
  self.songTableView.layer.borderColor = darkGray.CGColor;
  self.view.backgroundColor = lighterGray;
  
//  self.view.backgroundColor = [UIColor colorWithRe d:0.965 green:1 blue:0.973 alpha:1];
  self.randomWordToIncorporateLabel.textColor = brightOrange;
  
  
  
//  self.stopButton.layer.borderWidth = 1.0;
//  self.stopButton.layer.borderColor = darkGray.CGColor;
  [self.stopButton setTitleColor:boldBlue forState:UIControlStateNormal];
  self.wantANewWordLabel.textColor = darkGray;
  self.linesLabel.textColor = darkGray;
  
  
  
}

@end
