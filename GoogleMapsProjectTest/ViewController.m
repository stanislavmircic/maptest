//
//  ViewController.m
//  GoogleMapsProjectTest
//
//  Created by Djordje Jovic on 2/1/16.
//  Copyright © 2016 Unit. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
{
    GMSMapView *mapView_;
    int drawingCounter;
    FMDatabase *db;
}
- (IBAction)drawingStarted:(id)sender
{
    if (![[self.view.subviews objectAtIndex:1] isKindOfClass: [TestView class]])
    {
        self.NewView = [[TestView alloc] initWithFrame: self.view.bounds];
        [self.view insertSubview:self.NewView belowSubview:self.btnDrawing];
    }
    else
    {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[self.view.subviews objectAtIndex:1].layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *data=UIImagePNGRepresentation(viewImage);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *strPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"map%i.png",++drawingCounter]];
        [data writeToFile:strPath atomically:YES];
        
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(mapView_.projection.visibleRegion.nearLeft.latitude,
                                                                      mapView_.projection.visibleRegion.nearLeft.longitude);
        
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(mapView_.projection.visibleRegion.farRight.latitude,
                                                                      mapView_.projection.visibleRegion.farRight.longitude);
        
        GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                                  coordinate:northEast];
        
        GMSGroundOverlay *overlay = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:[UIImage imageWithContentsOfFile:strPath]];
        overlay.bearing = mapView_.camera.bearing;
        overlay.map = mapView_;

        [db executeUpdate:@"INSERT INTO drawingLayout VALUES ((?),(?),(?),(?),(?))", [NSNumber numberWithInt: drawingCounter], [NSNumber numberWithDouble: southWest.latitude], [NSNumber numberWithDouble: southWest.longitude], [NSNumber numberWithDouble: northEast.latitude], [NSNumber numberWithDouble: northEast.longitude]];
        [db executeUpdate:@"UPDATE OR REPLACE settings SET maxDrawings = (?) WHERE key='key'", [NSNumber numberWithInt: drawingCounter]];
        
        [self.NewView removeFromSuperview];
    }
}
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    if (mapView_.camera.zoom >= 15)
    {
        self.btnDrawing.hidden = NO;
        [mapView_ clear];
        
        ////Loads drawings from local directory for a given view
        FMResultSet *s = [db executeQuery:@"SELECT * FROM drawingLayout"];
        while ([s next])
        {
            CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake([s doubleForColumn:@"southWestLatitude"], [s doubleForColumn:@"southWestLongitude"]);
            CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake([s doubleForColumn:@"northWestLatitude"], [s doubleForColumn:@"northWestLongitude"]);
            GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                                      coordinate:northEast];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"map%i.png",[s intForColumn:@"numberOfDrawing"]]];
            
            bool success = [fileManager fileExistsAtPath:filePath];
            if (success)
            {
                if (northEast.longitude > mapView_.projection.visibleRegion.nearLeft.longitude &&
                    southWest.longitude < mapView_.projection.visibleRegion.farRight.longitude &&
                    northEast.latitude > mapView_.projection.visibleRegion.nearLeft.latitude &&
                    southWest.latitude < mapView_.projection.visibleRegion.farRight.latitude)
                {
                    GMSGroundOverlay *overlay = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:[UIImage imageWithContentsOfFile:filePath]];
                    overlay.bearing = 0;
                    overlay.map = mapView_;
                }
            }
        }
    }
    else
    {
        self.btnDrawing.hidden = YES;
        [mapView_ clear];
    }
    
    ////Creates a marker in the center of the map
    GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(45.254994, 19.845050)];
    marker.title = @"Novi Sad";
    marker.snippet = @"Serbia";
    marker.map = mapView_;
}

- (void)viewDidLoad {
    
    ////Loads database from project and opens it
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"GoogleMapsProjectTestDB.db"];
    bool success = [fileManager fileExistsAtPath:filePath];
    if (!success) {
        NSString *pathToDB = [[NSBundle mainBundle] pathForResource:@"GoogleMapsProjectTestDB" ofType:@"db"];
        success = [fileManager copyItemAtPath:pathToDB toPath:filePath error:&error];
        if (!success) {
            NSLog(@"%@", error);
        }
    }
    db = [[FMDatabase alloc] initWithPath:filePath];
    [db open];
    
    ////Creates a camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:45.254994
                                                            longitude:19.845050
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    [self.view insertSubview:mapView_ belowSubview:self.btnDrawing];
    
    ////Loads total number of drawings from DB
    FMResultSet *s = [db executeQuery:@"SELECT * FROM settings"];
    if ([s next])
        drawingCounter = [s intForColumn:@"maxDrawings"];
    
    ////Settings
    self.btnDrawing.hidden = YES;
}
@end