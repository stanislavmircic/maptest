//
//  ViewController.h
//  GoogleMapsProjectTest
//
//  Created by Djordje Jovic on 2/1/16.
//  Copyright © 2016 Unit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestView.h"

@interface ViewController : UIViewController
{
    UIView *drawImage;
    CGPoint startPoint;
}

@property (strong, nonatomic) TestView *NewView;

//- (void)intializeDrawImage;

@end

