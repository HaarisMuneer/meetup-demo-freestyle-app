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
    
    OTDSong *alienFamily = [[OTDSong alloc]initWithTitle:@"Alien Family (Instrumental)" artist:@"J Dilla" fileName:@"alien.mp3" bpm:85];
    OTDSong *work = [[OTDSong alloc]initWithTitle:@"Work (Instrumental)" artist:@"Gang Starr" fileName:@"work.mp3" bpm:93];
    OTDSong *flavaInYaEar = [[OTDSong alloc]initWithTitle:@"Flava In Ya Ear (Instrumental)" artist:@"Craig Mack" fileName:@"flava.mp3" bpm:89];
    self.songs = @[alienFamily, work, flavaInYaEar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)everyTwoLinesTapped:(id)sender {
    
    self.intervalTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(runEveryTwoLines) userInfo:nil repeats:YES];
    
}

- (IBAction)stopIntervalTapped:(id)sender
{
    if (self.intervalTimer) {
        [self.intervalTimer invalidate];
        self.intervalTimer = nil;
    }
}

-(void)runEveryTwoLines
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
