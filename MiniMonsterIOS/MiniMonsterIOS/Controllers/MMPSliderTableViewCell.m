//
//  MMPSliderTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPSliderTableViewCell.h"

NSString* const kMMPSliderTableViewCellIdentifier = @"MMPSliderTableViewCell";
const CGFloat kMMPSliderTableViewCellHeight = 150.0f;

@interface MMPSliderTableViewCell () <UITextFieldDelegate>

@property (nonatomic, assign) CGFloat savedData;

@end

@implementation MMPSliderTableViewCell

#pragma mark - Methods

- (void) setDataForControl: (MMPControl*) control
{
    if ([self.powerValueField.text isEqualToString: @""])
    {        
        [self.powerSlider setMinimumValue: 0.0f];
        [self.powerSlider setMaximumValue: [control.maxValue floatValue]];
        [self.powerSlider setValue: [control.data floatValue]
                          animated: YES];
        
        [self.powerSlider addTarget: self
                             action: @selector(sliderValuechanged:)
                   forControlEvents: UIControlEventValueChanged];
        self.savedData = [control.data floatValue];
        [self.powerValueField setText: control.data];
        
        [self.powerSetButton addTarget: self
                                 action: @selector(saveAction:)
                       forControlEvents: UIControlEventTouchUpInside];
    }
    
    if (![self.powerValueField.text isEqualToString: [NSString stringWithFormat: @"%.0f", self.savedData]] || fabs(floor(self.powerSlider.value) - self.savedData) > 1.0 )
    {
        [self.powerSetButton setHidden: NO];
    }
    else
    {
        [self.powerSetButton setHidden: YES];
    }
    
}

- (void) setSavedData: (CGFloat) savedData
{
    _savedData = savedData;
}

#pragma mark - Actions

- (void) sliderValuechanged: (UISlider*) slider
{
    if (![self.powerValueField.text isEqualToString: [NSString stringWithFormat: @"%.0f", self.savedData]] || fabs(floor(self.powerSlider.value) - self.savedData) > 1.0 )
    {
        [self.powerSetButton setHidden: NO];
    }
    else
    {
        [self.powerSetButton setHidden: YES];
    }
    [self.powerValueField setText: [NSString stringWithFormat: @"%.0f", slider.value]];
}

- (void) saveAction: (UIButton*) button
{
    if (self.delegate )
    {
        [self.delegate savePressedForCell: self
                                withValue: floor(self.powerSlider.value)
                                  atIndex: button.tag];
    }
}

#pragma mark - UITextField

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing: (UITextField *) textField
{
    if ([self isNumeric: textField.text])
    {
        [self.powerSlider setValue: [textField.text floatValue]
                          animated: YES];
    }
}

- (BOOL) isNumeric:(NSString*) checkText
{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [numberFormatter setNumberStyle: NSNumberFormatterScientificStyle];
    NSNumber* number = [numberFormatter numberFromString:checkText];
    if (number != nil)
    {
        return YES;
    }
    return NO;
}

@end
