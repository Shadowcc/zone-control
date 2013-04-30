//
//  scoreViewController.m
//  Zone Control
//
//  Created by user on 4/19/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import "scoreViewController.h"
#import "ScoreCell.h"
#import "GCDAsyncSocket.h"

@interface scoreViewController ()
{
    NSMutableArray *_user;
    NSMutableArray *_score;
    
}

@end

@implementation scoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
	
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    [_user insertObject:@"John" atIndex:0];
    [_score insertObject:@"5" atIndex:0];
    [_user insertObject:@"Scott" atIndex:0];
    [_score insertObject:@"6" atIndex:0];
    [_user insertObject:@"Scott" atIndex:0];
    [_score insertObject:@"6" atIndex:0];
    [_user insertObject:@"you" atIndex:0];
    [_score insertObject:@"6" atIndex:0];
    [_user insertObject:@"Scott" atIndex:0];
    [_score insertObject:@"6" atIndex:0];
    [_user insertObject:@"Scott" atIndex:0];
    [_score insertObject:@"6" atIndex:0];[_user insertObject:@"Scott" atIndex:0];
    [_score insertObject:@"6" atIndex:0];
     */
    
    
    
    
	// Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [self connectToServer];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _user.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * userID = [UIDevice currentDevice].uniqueIdentifier;
    static NSString *identifier = @"scorebox";
    
    ScoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    cell.scoreLabel.text = [_score objectAtIndex:indexPath.row];
    cell.avatar.image = [UIImage imageNamed:@"android"];
    
    cell.userLabel.text = [_user objectAtIndex:indexPath.row];
    cell.backgroundColor =[UIColor greenColor];
    if([[_user objectAtIndex:indexPath.row] isEqualToString:userID])
    {
    cell.backgroundColor = [UIColor grayColor];
    }
   
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)connectToServer
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
	_asyncSocketA = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    
    NSError *err = nil;
    if((![_asyncSocketA connectToHost:@"192.168.0.7" onPort:8001 error:&err]))
    {
        NSLog(@"Error connecting: %@",	 err);
        
    }
    [_asyncSocketA readDataToData:[GCDAsyncSocket LFData] withTimeout:15 tag:1];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    NSString * userID = [UIDevice currentDevice].uniqueIdentifier;

    
    // We're just going to send a test string to the server.
    
    NSString *myStr =[NSString stringWithFormat: @"%@*allscore\r\n",userID];
    
   
    
    
    NSData *myData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [_asyncSocketA writeData:myData withTimeout:5.0 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
	
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    
    
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
	NSLog(@"%@", httpResponse);
    
    
    
    NSArray *chunks = [httpResponse componentsSeparatedByString: @"*"];
    _user = [[NSMutableArray alloc] init];
    _score = [[NSMutableArray alloc] init];
    
    
    if([chunks[0] isEqualToString: @"allscore"])
    {
        NSInteger numberOfUsers =  [chunks[1] intValue];
        
        for(int i = 1; i < numberOfUsers*2; i= i+2)
        {
            [_user insertObject:chunks[i+1] atIndex:0];
            [_score insertObject:chunks[i+2] atIndex:0];
            
        
        }
    [[self collectionView ] reloadData];

    }
        
    
    
}

@end
