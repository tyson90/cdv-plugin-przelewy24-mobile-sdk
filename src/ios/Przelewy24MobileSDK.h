/********* Przelewy24MobileSDK.m Cordova Plugin Header *******/

#import <Cordova/CDVPlugin.h>
#import "P24.h"
#import "MainViewController.h"

@interface Przelewy24MobileSDK : CDVPlugin <P24Delegate> {
    P24TrnDirectParams *p24Config;
    P24 *p24;
}

@property(nonatomic, strong, readwrite) CDVInvokedUrlCommand *command;
@property(nonatomic, strong, readwrite) MainViewController *controller;

- (id)init:(CDVInvokedUrlCommand*)command;

- (void)startTrnDirect:(CDVInvokedUrlCommand*)command;

@end
