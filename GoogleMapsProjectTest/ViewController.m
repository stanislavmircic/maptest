//
//  ViewController.m
//  GoogleMapsProjectTest
//
//  Created by Djordje Jovic on 2/1/16.
//  Copyright © 2016 Unit. All rights reserved.
//

#import "ViewController.h"
#import "NewTile.h"
@import GoogleMaps;

@implementation ViewController {
    GMSMapView *mapView_;
    UIBezierPath *path; // (3)
}

- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
//    [self.view addSubview:mapView_];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;

    self.NewView = [[TestView alloc] initWithFrame: self.view.bounds];
    [self.view addSubview:self.NewView];
//    self.view = self.NewView;
}

//    -(void)intializeDrawImage
//    {
//        drawImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 320, 320)];
////        [drawImage setBackgroundColor:[UIColor purpleColor]];
//        [drawImage setUserInteractionEnabled:YES];
//        [self.view addSubview:drawImage];
//    }
//    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//    {
//        NSLog(@"touchesBegan");
//        UITouch *touch = [touches anyObject];
//        CGPoint p = [touch locationInView:drawImage];
//        startPoint = p;
//    }
//    
//    - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//    {
//        NSLog(@"touchesMoved");
//        UITouch *touch = [touches anyObject];
//        CGPoint p = [touch locationInView:drawImage];
//        [self drawLineFrom:startPoint endPoint:p];
//    }
//    
//    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//    {
//        [self touchesMoved:touches withEvent:event];
//    }
//    
//    - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//    {
//        [self touchesEnded:touches withEvent:event];
//    }
//    
//    -(void)drawLineFrom:(CGPoint)from endPoint:(CGPoint)to
//    {
//        drawImage.image = [UIImage imageNamed:@""];
//        
//        UIGraphicsBeginImageContext(drawImage.frame.size);
//        [drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
//        [[UIColor greenColor] set];
//        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0f);
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), from.x, from.y);
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), to.x , to.y);
//        
//        CGContextStrokePath(UIGraphicsGetCurrentContext());
//        
//        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
@end