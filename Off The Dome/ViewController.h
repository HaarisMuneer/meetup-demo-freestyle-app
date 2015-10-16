//
//  ViewController.h
//  Off The Dome
//
//  Created by Haaris Muneer on 10/7/15.
//  Copyright © 2015 Haaris Muneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, assign) NSTimeInterval lastPressTime;
@property (nonatomic, assign) NSTimeInterval currentPressTime;
@property (nonatomic, strong) NSMutableArray *timeBetweenPresses;
@property (nonatomic, assign) NSUInteger bpm;
@property (nonatomic, strong) IBOutlet UILabel *bpmView;
@property (nonatomic, assign) CGFloat averageTimeBetweenButtonPress;

@property (weak, nonatomic) IBOutlet UILabel *randomWordToIncorporateLabel;

//array property to create with text file
@property (nonatomic, strong) NSMutableArray *wordsToIncorporateArray;
@property (nonatomic, strong)NSTimer *intervalTimer;


//button for every two lines
- (IBAction)everyTwoLinesTapped:(id)sender;
- (IBAction)stopIntervalTapped:(id)sender;

@end

