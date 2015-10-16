//
//  ViewController.m
//  Off The Dome
//
//  Created by Haaris Muneer on 10/7/15.
//  Copyright © 2015 Haaris Muneer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize bpmView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeBetweenPresses = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.

  
  //add text file of words to words array
  self.wordsToIncorporateArray= [[NSMutableArray alloc]init];
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wordlist" ofType:@"txt"];
  NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
  for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
    [self.wordsToIncorporateArray addObject:line];
  }
  NSLog(@"%@",self.wordsToIncorporateArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressButton:(UIButton *)sender
{
    self.currentPressTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = self.currentPressTime - self.lastPressTime;
    [self.timeBetweenPresses addObject:@(elapsedTime)];
    self.lastPressTime = [NSDate timeIntervalSinceReferenceDate];
    [self averageTimeBetweenButtonPresses];
}

- (void) averageTimeBetweenButtonPresses {
    CGFloat total = 0.0;
    self.averageTimeBetweenButtonPress = 0.0;
    for (NSInteger i=0; i<self.timeBetweenPresses.count; i++) {
        if (i!=0) {
            total+=[self.timeBetweenPresses[i] doubleValue];
        }
    }
    self.averageTimeBetweenButtonPress = total/(self.timeBetweenPresses.count-1);
    self.bpm = round(60.0/self.averageTimeBetweenButtonPress);
    [self writeToLabel];
}
- (IBAction)resetButton: (id)sender {
    self.lastPressTime = 0;
    self.currentPressTime = 0;
    [self.timeBetweenPresses removeAllObjects];
    self.averageTimeBetweenButtonPress = 0;
    self.bpmView.text = @"";

}

-(void) writeToLabel {
   if (self.bpm<1000) { //temporary hacky workaround
        self.bpmView.text = [NSString stringWithFormat:@"%lu BPM", self.bpm];
    }
}



//right now next two methods run so that the label updates every three seconds with a new word ad infinitum
//need to update so that button sends message to timer to set time interval, then timer starts when song starts
//then remove stop button and relocate logic so that set to end when song ends

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


@end
