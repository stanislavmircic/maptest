//
//  ViewController.h
//  GoogleMapsProjectTest
//
//  Created by Djordje Jovic on 2/1/16.
//  Copyright © 2016 Unit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTile.h"
#import "TestView.h"
@import GoogleMaps;
#import "FMDB.h"

@interface ViewController : UIViewController <GMSMapViewDelegate>
{
    UIView *drawImage;
    CGPoint startPoint;
}

@property (strong, nonatomic) TestView *NewView;
@property (weak, nonatomic) IBOutlet UIButton *btnDrawing;

//- (void)intializeDrawImage;

@end

