//
//  WhiskeyViewController.h
//  Calcohol
//
//  Created by Peter Scheyer on 1/27/15.
//  Copyright (c) 2015 Peter Scheyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface WhiskeyViewController : ViewController
@property (weak, nonatomic) UITextField *beerPercentTextField;
@property (weak, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) UISlider *beerCountSlider;
@property (weak, nonatomic) UILabel *beerSliderLabel;

- (void)buttonPressed:(UIButton *)sender;

@end
