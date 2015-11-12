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

@property (nonatomic)NSUInteger BPM;
@property (nonatomic)NSUInteger currentInterval;
@property (nonatomic, strong)NSDate *timeAtLastLabelUpdate;
@property (nonatomic, strong) NSDate *timeAtSongPause;
@property (nonatomic)NSTimeInterval timeBetweenPauseAndLastUpdate;
@property (nonatomic, strong) NSTimer *pausedTimer;
@property (nonatomic)CGFloat pauseTime;

@end

@implementation OTDWordDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  

    self.lineMultiplier = 2;
    self.randomWordToIncorporateLabel.text = @"Spit!";
    self.randomWordToIncorporateLabel.font = [UIFont fontWithName:@"LemonMilk" size:80];
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    [self setStyle];
  
    self.wordsToIncorporateArray= [[NSMutableArray alloc]init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wordlist" ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
  
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [self.wordsToIncorporateArray addObject:line];
    }
  
    //NSLog(@"%@",self.wordsToIncorporateArray);
    
    OTDSong *alienFamily = [[OTDSong alloc]initWithTitle:@"Alien Family (Instrumental)" artist:@"J Dilla" fileName:@"alien" bpm:85];
    OTDSong *work = [[OTDSong alloc]initWithTitle:@"Work (Instrumental)" artist:@"Gang Starr" fileName:@"work" bpm:92];
    OTDSong *flavaInYaEar = [[OTDSong alloc]initWithTitle:@"Flava In Ya Ear (Instrumental)" artist:@"Craig Mack" fileName:@"flava" bpm:90];
    self.songs = @[flavaInYaEar, work, alienFamily];
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
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"" withExtension:@"mp3"] error:nil];
}

- (IBAction)segmentTapped:(id)sender {
  //lines are placeholder values until calculation for BPM are input
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
    NSString *randomWord = self.wordsToIncorporateArray[random];
    self.randomWordToIncorporateLabel.text = randomWord;
    if (randomWord.length >= 7) {
        self.randomWordToIncorporateLabel.font = [UIFont fontWithName:@"LemonMilk" size:68];
    }
    else self.randomWordToIncorporateLabel.font = [UIFont fontWithName:@"LemonMilk" size:84];

    self.wordUtterance = [AVSpeechUtterance speechUtteranceWithString:self.randomWordToIncorporateLabel.text];
    [self.synthesizer speakUtterance:self.wordUtterance];
  
    if (self.currentInterval != self.lineMultiplier) {
      CGFloat intervalValue = (240.0/self.BPM) * self.lineMultiplier;
    [self.intervalTimer invalidate];
    self.intervalTimer = nil;

      
    
    [self intervalTimer:intervalValue];
    self.currentInterval = self.lineMultiplier;
      NSLog(@"%@", self.timeAtLastLabelUpdate);
      
  }
  self.timeAtLastLabelUpdate = [NSDate date];
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
  CGFloat intervalValue = (240.0/song.bpm) * self.lineMultiplier;

  NSLog(@"intervalValue = %f", intervalValue);
  
    if ([[self.audioPlayer.url absoluteString] containsString:song.fileName]) {
        NSLog(@"Song clicked is song that is already playing");
        if (self.audioPlayer.isPlaying) {
            NSLog(@"This pauses the currently playing song");
            [self.audioPlayer pause];
          [self.intervalTimer invalidate];
          self.intervalTimer = nil;
          self.timeAtSongPause = [NSDate date];
          

          self.timeBetweenPauseAndLastUpdate = [self.timeAtLastLabelUpdate timeIntervalSinceDate:self.timeAtSongPause] * -1;
          
          NSLog(@"timeBetweenPauseAndLastUpdate: %f",self.timeBetweenPauseAndLastUpdate) ;
          self.pauseTime = intervalValue - self.timeBetweenPauseAndLastUpdate;
          NSLog(@"pauseTime: %f",self.pauseTime) ;


        }
        else {
            NSLog(@"This plays the paused song");
          self.currentInterval = self.lineMultiplier;

            [self.audioPlayer play];
            [self pausedTimer:self.pauseTime];
        }
    }
    else {
        NSLog(@"Song clicked is a song that is not already playing");

        if (self.intervalTimer) {
            [self.intervalTimer invalidate];
            self.intervalTimer = nil;
        }
      
        
        [self setUpAVAudioPlayerWithFileName:song.fileName];
        [self.audioPlayer play];
      
        self.BPM = song.bpm;
        self.currentInterval = self.lineMultiplier;
        [self intervalTimer:intervalValue];
        [self updateRandomWordLabel];
    }

//  NSLog(@"pauseTime: %f", self.pauseTime);
//  NSLog(@"timeAtSongPause: %@", self.timeAtSongPause);
//  NSLog(@"timeAtLastLabelUpdate: %@", self.timeAtLastLabelUpdate);
//  NSLog(@"-----------------------");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSTimer*)pausedTimer: (CGFloat)pausedDelayInterval{

  NSLog(@"PausedTimer");

  self.pausedTimer = [NSTimer scheduledTimerWithTimeInterval:pausedDelayInterval target:self selector:@selector(pausedLabelUpdate) userInfo:nil repeats:NO];
  return self.pausedTimer;
}
-(void)pausedLabelUpdate
{
  [self updateRandomWordLabel];
  self.lineMultiplier = self.currentInterval;

  CGFloat intervalValue = (240.0/self.BPM) * self.lineMultiplier;
  
  NSLog(@"pause label update");
//  self.currentInterval = self.lineMultiplier;

  [self intervalTimer:intervalValue];
  
}

- (void)setUpAVAudioPlayerWithFileName:(NSString *)fileName
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"mp3"];
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        [self.audioPlayer prepareToPlay];
    }
}

- (IBAction)scButtonTapped:(id)sender {
    [self setUpAVPlayerAndPlay];
}

- (void) setUpAVPlayerAndPlay {
    NSURL *scSearch = [NSURL URLWithString:@"https://api.soundcloud.com/playlists/76553025?client_id=d52c6078d33b0753271d9832dc819ce2"];
    NSURLRequest *scRequest = [NSURLRequest requestWithURL:scSearch];

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *scData = [session dataTaskWithRequest:scRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *tracks = responseDictionary[@"tracks"];
        for (NSDictionary *trackDict in tracks) {
            NSLog(@"%@", trackDict[@"title"]);
        }
//        NSString *streamString = [NSString stringWithFormat:@"%@?client_id=%@", songDictionary[@"stream_url"], @"d52c6078d33b0753271d9832dc819ce2"];
//        NSURL *streamURL = [NSURL URLWithString:streamString];
//
//        NSLog(@"%@", streamURL);
//
//        self.scPlayer = [AVPlayer playerWithURL:streamURL];
//        [self.scPlayer play];
        
    }];
    
    [scData resume];
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
