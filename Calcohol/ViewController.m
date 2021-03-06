//
//  ViewController.m
//  Calcohol
//
//  Created by Peter Scheyer on 1/25/15.
//  Copyright (c) 2015 Peter Scheyer. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) UIButton *calculateButton;
@property (weak, nonatomic) UITapGestureRecognizer *hideKeyboardTapGestureRecognizer;
@property (weak, nonatomic) UILabel *beerSliderLabel;

@end

@implementation ViewController

-(instancetype) init {
    self = [super init];
    
    if(self) {
        self.title = NSLocalizedString(@"Wine", @"wine");
        
        //Since we don't have icons, lets move the title to the middle of the tab bar.
        [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -18)];
    }
    return self;
}

- (void)loadView {
    // Allocate and initialize the all-encompassing view
    self.view = [[UIView alloc] init];
    
    // Allocate and initialize each of our views and the gesture recognizer
    UITextField *textField = [[UITextField alloc] init];
    UISlider *slider = [[UISlider alloc] init];
    UILabel *label = [[UILabel alloc] init];
    UILabel *beerSliderLabel = [[UILabel alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];

    
    // Add each view and the gesture recognizer as the view's subviews
    [self.view addSubview:textField];
    [self.view addSubview:slider];
    [self.view addSubview:label];
    [self.view addSubview:beerSliderLabel];
    [self.view addSubview:button];
    [self.view addGestureRecognizer:tap];
    
    // Assign the views and gesture recognizer to our properties
    self.beerPercentTextField = textField;
    self.beerCountSlider = slider;
    self.resultLabel = label;
    self.beerSliderLabel = beerSliderLabel;
    self.calculateButton = button;
    self.hideKeyboardTapGestureRecognizer = tap;
    
}

- (void)viewDidLoad
{
    // Calls the superclass's implementation
    [super viewDidLoad];
    
    // Set our primary view's background color to whiteColor
    self.view.backgroundColor = [UIColor whiteColor];
    self.calculateButton.backgroundColor = [UIColor darkGrayColor];
    self.calculateButton.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:20];
    
    // Tells the text field that `self`, this instance of `BLCViewController` should be treated as the text field's delegate
    self.beerPercentTextField.delegate = self;
    
    // Set the placeholder text
    self.beerPercentTextField.placeholder = NSLocalizedString(@"% Alcohol Content Per Beer", @"Beer percent placeholder text");
    
    // Tells `self.beerCountSlider` that when its value changes, it should call `[self -sliderValueDidChange:]`.
    // This is equivalent to connecting the IBAction in our previous checkpoint
    [self.beerCountSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // Set the minimum and maximum number of beers
    self.beerCountSlider.minimumValue = 1;
    self.beerCountSlider.maximumValue = 10;
    
    // Tells `self.calculateButton` that when a finger is lifted from the button while still inside its bounds, to call `[self -buttonPressed:]`
    [self.calculateButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the title of the button
    [self.calculateButton setTitle:NSLocalizedString(@"Calculate!", @"Calculate command") forState:UIControlStateNormal];
    
    // Tells the tap gesture recognizer to call `[self -tapGestureDidFire:]` when it detects a tap.
    [self.hideKeyboardTapGestureRecognizer addTarget:self action:@selector(tapGestureDidFire:)];
    
    // Gets rid of the maximum number of lines on the label
    self.resultLabel.numberOfLines = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.741 green:0.925 blue:0.714 alpha:1]; /*#bdecb6*/
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    
    CGFloat viewWidth;
    CGFloat itemWidth;
    CGFloat itemHeight;
    CGFloat padding = 20;
    CGFloat navBar = 44;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        NSLog(@"This UI Setup is for Ipad");
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        NSLog(@"Orientation is %d", orientation);
        if (orientation == 1) {
            viewWidth = 768;
            itemWidth = viewWidth - padding - padding;
            itemHeight = 44;
            NSLog(@"Orientation is portrait");
        } else  {
            viewWidth = 1024;
            itemWidth = viewWidth - padding - padding;
            itemHeight = 22;
            NSLog(@"Orientation not portrait");
        }
        
    } else {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        NSLog(@"Orientation is %d", orientation);
        NSLog(@"This UI Setup is for IPhone");
        if (orientation == 1) {
            viewWidth = 320;
            itemWidth = viewWidth - padding - padding;
            itemHeight = 44;
            NSLog(@"Orientation is portrait");
        } else  {
            viewWidth = 480;
            itemWidth = viewWidth - padding - padding;
            itemHeight = 22;
            NSLog(@"Orientation not portrait");
        }
    }

    
    self.beerPercentTextField.frame = CGRectMake(padding, padding + navBar, itemWidth, itemHeight);
    
    CGFloat bottomOfTextField = CGRectGetMaxY(self.beerPercentTextField.frame);
    self.beerCountSlider.frame = CGRectMake(padding, bottomOfTextField + padding, itemWidth, itemHeight);
    
    CGFloat bottomOfSlider = CGRectGetMaxY(self.beerCountSlider.frame);
    self.beerSliderLabel.frame = CGRectMake(padding, bottomOfSlider+padding, itemWidth, itemHeight);
    
    CGFloat bottomOfSliderLabel = CGRectGetMaxY(self.beerSliderLabel.frame);
    self.resultLabel.frame = CGRectMake(padding, bottomOfSliderLabel + padding, itemWidth, itemHeight * 4);
    
    CGFloat bottomOfLabel = CGRectGetMaxY(self.resultLabel.frame);
    self.calculateButton.frame = CGRectMake(padding, bottomOfLabel + padding, itemWidth, itemHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange:(UITextField *)sender {

    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        //the user typed zero or something that's not a number, clear the field
        sender.text = nil;
    }
}

- (void)sliderValueDidChange:(UISlider *)sender {
    
    NSLog(@"Slider value changed to %f", sender.value);
    [self.beerPercentTextField resignFirstResponder];
    
    //Update text box with slider value
    NSString *sliderText = [NSString stringWithFormat:NSLocalizedString(@"%.1f ", nil), sender.value];
    self.beerSliderLabel.text = sliderText;
    
    //add slider value into title for tab/view
    NSString *titleText = [NSString stringWithFormat:NSLocalizedString(@"Wine (%.1f glasses)", nil), sender.value];
    self.title = titleText;
    
    //update tab bar with icon incl slider value
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", (int) sender.value]];
}

- (void)buttonPressed:(UIButton *)sender {
    
    [self.beerPercentTextField resignFirstResponder];
    
    //first, calculate how much alcohol is in all those beers
    
    int numberOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12; //12 oz beer bottles
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100;
    float ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    //now calc the equivalent amount of wine
    float ouncesInOneWineGlass = 5; //wine glasses are usually 5oz
    float alcoholPercentageOfWine = 0.13; //13% is average
    
    float ouncesOfAlcoholPerWineGlass = ouncesInOneWineGlass * alcoholPercentageOfWine;
    float numberOfWineGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal / ouncesOfAlcoholPerWineGlass;
    
    //decide whether to use "beer"/"beers" and "glass"/"glasses"
    
    NSString *beerText;
    
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *wineText;
    
    if (numberOfWineGlassesForEquivalentAlcoholAmount == 1) {
        wineText = NSLocalizedString(@"glass", @"singular glass");
    } else {
        wineText = NSLocalizedString(@"glasses", @"plural of glass");
    }
    
//    generate the result text, and display it on the label
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ contain as much alcohol as %.1f %@ of wine.", nil), numberOfBeers, beerText,numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    self.resultLabel.text = resultText;
    NSLog(@"%@", resultText);
    
}


- (void)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}





@end
