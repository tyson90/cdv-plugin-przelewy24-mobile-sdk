/********* Przelewy24MobileSDK.m Cordova Plugin Implementation *******/

#import "Przelewy24MobileSDK.h"

@implementation Przelewy24MobileSDK

- (id)init:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
  
  self = [super init];
  if (self) {
    p24Config = [[P24Config alloc] init];
    
    // for (NSString *el in command.arguments[0]) {
    //   NSLog(@"%@ = %@", el, command.arguments[0][el]);
    // }
    
    int merchantId = [command.arguments[0][@"merchantId"] intValue];
    p24Config.merchantId = merchantId;
    
    NSString *crc = command.arguments[0][@"crc"];
    p24Config.crc = crc;
    
    int timeLimit = [command.arguments[0][@"timeLimit"] intValue];
    p24Config.timeLimit = timeLimit;
    
    // is sandbox?
    BOOL testMode = [command.arguments[0][@"enableTestMode"] boolValue];
    [p24Config enableTestMode:testMode];
    
    p24 = [[P24 alloc] initWithConfig:p24Config delegate:self];
    
    NSLog(@"P24 INIT");
    NSLog(@"Merchant ID: %d", p24Config.merchantId);
    NSLog(@"CRC: %@", p24Config.crc);
    NSLog(@"Time Limit: %d", p24Config.timeLimit);
    NSLog(@"SANDBOX: %@", testMode ? @"TAK" : @"NIE");
		
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error"];
  }
  
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  
  return self;
}

- (void)paymentStart:(CDVInvokedUrlCommand *)command
{
  self.command = command;
  
  // for (NSString *el in command.arguments[0]) {
  //   NSLog(@"%@ = %@", el, command.arguments[0][el]);
  // }
  
  P24Payment *p24Payment = [[P24Payment alloc] init];
  
  p24Payment.sessionId = command.arguments[0][@"sessionId"];
  p24Payment.amount = [command.arguments[0][@"amount"] intValue];
  p24Payment.transferLabel = command.arguments[0][@"transferLabel"];
  p24Payment.clientName = command.arguments[0][@"clientName"];
  p24Payment.language = command.arguments[0][@"language"];
  p24Payment.currency = command.arguments[0][@"currency"];
  p24Payment.clientEmail = command.arguments[0][@"clientEmail"];
  
//  p24Payment.clientAddress = @"Ulica testowa";
//  p24Payment.clientCity = @"Lublin";
//  p24Payment.clientZipCode = @"20-111";
//  p24Payment.clientCountry = @"PL";
//  p24Payment.clientPhone = @"12423513";
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CDVLaunchScreen" bundle:nil];
  MainViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"P24View"];
  [self.viewController presentViewController:controller animated:YES completion:nil];
  
  self.controller = controller;
  
  [p24 startPayment:p24Payment inViewController:controller];
}

- (void)p24:(P24 *)p24 didFinishPayment:(P24Payment *)p24Payment withResult:(P24PaymentResult *)p24PaymentResult
{
  NSLog(@"P24 DID FINISH PAYMENT");
  NSLog(@"Payment result code: %d, description: %@", p24PaymentResult.status.code, p24PaymentResult.status.description);
  NSLog(@"Session id: %@", p24Payment.sessionId);
  NSLog(@"Order id: %d", p24PaymentResult.orderId);
  
  BOOL paymentOk = [p24PaymentResult isOk];
  
  NSString *info = p24PaymentResult.status.description;
  
  if (paymentOk) {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:info];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
  } else {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:info];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
  }
  
  [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)p24:(P24 *)p24 didCancelPayment:(P24Payment *)p24Payment
{
  NSString *info = @"P24 DID CANCEL PAYMENT";
  NSLog(@"%@", info);
  
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:info];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
  
  [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)p24:(P24 *)p24 didFailPayment:(P24Payment *)p24Payment withError:(NSError *)error
{
  NSString *info = @"P24 DID FAIL PAYMENT";
  NSLog(@"%@", info);
  NSLog(@"Error: %@", [error localizedDescription]);
  
  NSString *full_info = [NSString stringWithFormat:@"%@: %@", info, [error localizedDescription]];
  
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:full_info];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];
  
  [self.controller dismissViewControllerAnimated:YES completion:nil];
}

@end
