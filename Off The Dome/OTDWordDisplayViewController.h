//
//  OTDWordDisplayViewController.h
//  Off The Dome
//
//  Created by Haaris Muneer on 10/19/15.
//  Copyright © 2015 Haaris Muneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTDWordDisplayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *randomWordToIncorporateLabel;

//array property to create with text file
@property (nonatomic, strong) NSMutableArray *wordsToIncorporateArray;
@property (nonatomic, strong)NSTimer *intervalTimer;


//button for every two lines
- (IBAction)everyTwoLinesTapped:(id)sender;
- (IBAction)stopIntervalTapped:(id)sender;

@end
