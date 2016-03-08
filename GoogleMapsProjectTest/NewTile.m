//
//  NewTile.m
//  GoogleMapsProjectTest
//
//  Created by Djordje Jovic on 2/10/16.
//  Copyright © 2016 Unit. All rights reserved.
//

#import "NewTile.h"

@implementation NewTile

- (UIImage *)tileForX:(NSUInteger)x y:(NSUInteger)y zoom:(NSUInteger)zoom {
    // On every odd tile, render an image.
    if (x % 2) {
        return [UIImage imageNamed:@"AustralianFlag.png"];
    } else {
        return kGMSTileLayerNoTile;
    }
}

@end
