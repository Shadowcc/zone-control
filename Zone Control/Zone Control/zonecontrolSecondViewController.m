//
//  zonecontrolSecondViewController.m
//  Zone Control
//
//  Created by Scott Monroe on 2/12/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import "zonecontrolSecondViewController.h"



@interface zonecontrolSecondViewController ()
{
    
        NSMutableArray *_user;
        NSMutableArray *_score;
    
  
}

@end

@implementation zonecontrolSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Second View");
    
    [_user insertObject:@"john" atIndex:0];
    [_score insertObject:@"5" atIndex:0];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
