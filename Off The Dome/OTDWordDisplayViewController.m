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
  

  
  
    self.wordsToIncorporateArray= [[NSMutableArray alloc]init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wordlist" ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [self.wordsToIncorporateArray addObject:line];
    }
    NSLog(@"%@",self.wordsToIncorporateArray);
    
    OTDSong *alienFamily = [[OTDSong alloc]initWithTitle:@"Alien Family (Instrumental)" artist:@"J Dilla" fileName:@"alien" bpm:85];
    OTDSong *work = [[OTDSong alloc]initWithTitle:@"Work (Instrumental)" artist:@"Gang Starr" fileName:@"work" bpm:93];
    OTDSong *flavaInYaEar = [[OTDSong alloc]initWithTitle:@"Flava In Ya Ear (Instrumental)" artist:@"Craig Mack" fileName:@"flava" bpm:89];
    self.songs = @[alienFamily, work, flavaInYaEar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSTimer*)intervalTimer: (NSUInteger)delayInterval{
    
    self.intervalTimer = [NSTimer scheduledTimerWithTimeInterval:delayInterval target:self selector:@selector(updateRandomWordLabel) userInfo:nil repeats:YES];
  return self.intervalTimer;
}

- (IBAction)stopIntervalTapped:(id)sender
{
    if (self.intervalTimer) {
        [self.intervalTimer invalidate];
        self.intervalTimer = nil;
    }
}

- (IBAction)segmentTapped:(id)sender {
  //lines are placeholder values until calculation for BPM are input
  
  if (self.segmentControl.selectedSegmentIndex == 0) {
    self.lines = 2;
  }
  if (self.segmentControl.selectedSegmentIndex == 1) {
    self.lines = 4;
  }
  else{
    self.lines = 6;
  }
  
}

-(void)updateRandomWordLabel
{
    NSUInteger random = arc4random_uniform((u_int32_t) self.wordsToIncorporateArray.count);
    
    
    self.randomWordToIncorporateLabel.text = self.wordsToIncorporateArray[random];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu bpm", bpm];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OTDSong *song = self.songs[indexPath.row];
    [self setUpAVAudioPlayerWithFileName:song.fileName];
  
  //would put here something like intervalValue = bpm/self.lines.... [self intervalTimer:intervalValue]
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)setUpAVAudioPlayerWithFileName:(NSString *)fileName
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"mp3"];
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!self.audioPlayer)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        [self.audioPlayer prepareToPlay];
    }
}

@end
