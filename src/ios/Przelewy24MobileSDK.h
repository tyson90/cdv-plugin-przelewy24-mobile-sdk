/********* Przelewy24MobileSDK.m Cordova Plugin Header *******/

#import <Cordova/CDVPlugin.h>
#import "P24.h"
#import "MainViewController.h"

@interface Przelewy24MobileSDK : CDVPlugin <P24TransferDelegate> {
  P24 *p24;
  P24TransactionParams *p24TransactionParams;
  P24TrnDirectParams *p24TrnDirectParams;
}

@property(nonatomic, strong, readwrite) CDVInvokedUrlCommand *command;
@property(nonatomic, strong, readwrite) MainViewController *controller;

- (id)init:(CDVInvokedUrlCommand*)command;
- (void)startPayment:(CDVInvokedUrlCommand*)command;

@end


int const P24_CHANNEL_CARDS = 1;
int const P24_CHANNEL_TRANSFERS = 2;
int const P24_CHANNEL_TRADITIONAL_TRANSFERS = 4;
int const P24_CHANNEL_NA = 8;
int const P24_CHANNEL_24_7 = 16;
int const P24_CHANNEL_PREPAYMENT = 32;
