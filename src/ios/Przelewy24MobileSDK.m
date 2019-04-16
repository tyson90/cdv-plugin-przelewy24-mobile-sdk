/********* Przelewy24MobileSDK.m Cordova Plugin Implementation *******/

#import "Przelewy24MobileSDK.h"

@implementation Przelewy24MobileSDK

- (id)init:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;

  self = [super init];
  if (self) {
    self.command = command;

    // p24Config = [[P24Config alloc] init];

    for (NSString *el in command.arguments[0]) {
      NSLog(@"%@ = %@", el, command.arguments[0][el]);
    }

    // int merchantId = [command.arguments[0][@"merchantId"] intValue];
    // p24Config.merchantId = merchantId;
    //
    // NSString *crc = command.arguments[0][@"crc"];
    // p24Config.crc = crc;
    //
    // int timeLimit = [command.arguments[0][@"timeLimit"] intValue];
    // p24Config.timeLimit = timeLimit;
    //
    // // is sandbox?
    // BOOL testMode = [command.arguments[0][@"enableTestMode"] boolValue];
    // [p24Config enableTestMode:testMode];
    //
    // // only cards?
    // BOOL cardsOnly = [command.arguments[0][@"cardsOnly"] boolValue];
    // if (cardsOnly)
    // {
    //   p24Config.p24Channel = P24_CHANNEL_CARDS;
    // }
    //
    // p24 = [[P24 alloc] initWithTransactionParams:p24Config delegate:self];
    //
    // NSLog(@"P24 INIT");
    // NSLog(@"Merchant ID: %d", p24Config.merchantId);
    // NSLog(@"CRC: %@", p24Config.crc);
    // NSLog(@"Time Limit: %d", p24Config.timeLimit);
    // NSLog(@"SANDBOX: %@", testMode ? @"TAK" : @"NIE");
    // NSLog(@"Payment Channel: %d", p24Config.p24Channel);
    // NSLog(@"Cards Only: %@", cardsOnly ? @"TAK" : @"NIE");
    //
    // P24Payment *p24Payment = [[P24Payment alloc] init];
    //
    // p24Payment.sessionId = command.arguments[0][@"sessionId"];
    // p24Payment.amount = [command.arguments[0][@"amount"] intValue];
    // p24Payment.transferLabel = command.arguments[0][@"transferLabel"];
    // p24Payment.description = command.arguments[0][@"transferLabel"];
    // p24Payment.clientName = command.arguments[0][@"clientName"];
    // p24Payment.language = command.arguments[0][@"language"];
    // p24Payment.currency = command.arguments[0][@"currency"];
    // p24Payment.clientEmail = command.arguments[0][@"clientEmail"];
    //
    // // P24 URL Status
    // p24Payment.p24UrlStatus = command.arguments[0][@"p24UrlStatus"];
    // NSLog(@"P24 URL Status: %@", p24Payment.p24UrlStatus);

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CDVLaunchScreen" bundle:nil];
    MainViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"P24View"];
    [self.viewController presentViewController:controller animated:YES completion:nil];

    self.controller = controller;

    // [p24 startPayment:p24Payment inViewController:controller];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

  return self;
}

- (void)p24TransferOnSuccess
{
  NSString *info = @"P24 TRANSFER ON SUCCESS";
  NSLog(@"%@", info);

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:info];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];

  [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)p24TransferOnCanceled
{
  NSString *info = @"P24 TRANSFER ON CANCELED";
  NSLog(@"%@", info);

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:info];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];

  [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)p24TransferOnError: (NSString*) errorCode
{
  NSString *info = @"P24 TRANSFER ON ERROR";
  NSLog(@"%@", info);
  NSLog(@"Error: %@", errorCode);

  NSString *full_info = [NSString stringWithFormat:@"%@: %@", info, errorCode];

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:full_info];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];

  [self.controller dismissViewControllerAnimated:YES completion:nil];
}

@end
