//
//  UICountryPicker.h
//  
//
//  Created by Kuldeep Tyagi on 17/01/18.
//

#import <UIKit/UIKit.h>

/**Country Picker callback*/
typedef void (^CountryPickerCompletionHandler)(NSString * _Nonnull name, NSString * _Nonnull code, NSString * _Nonnull countryCode);

@interface UICountryPicker : UITableViewController

/*!
 @abstract
 Provides a wrapper that presents the view controller modally and automatically dismisses it
 when either the Done or Cancel button is pressed.
 
 @param parentViewController  The view controller that is presenting this view controller.
 @param handler               The block called when the Done or Cancel button is pressed.
 */
+(instancetype _Nullable ) showCountryPickerFromViewController:(UIViewController *_Nonnull) parentViewController
                                                       handler:(CountryPickerCompletionHandler _Nonnull )handler;
@end
