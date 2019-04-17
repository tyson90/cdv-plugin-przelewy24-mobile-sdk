/********* Przelewy24MobileSDK.m Cordova Plugin Implementation *******/

#import "Przelewy24MobileSDK.h"

@implementation Przelewy24MobileSDK

- (id)init:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;

  self = [super init];
  if (self) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

  return self;
}

- (void)startPayment:(CDVInvokedUrlCommand*)command
{
  self.command = command;

  NSDictionary *params = command.arguments[0];

  NSLog(@"\n\nLoop through params provided by user APP\n---");
  for (NSString *k in params) {
    NSLog(@"%@ = %@", k, params[k]);
  }

  p24TransactionParams = [[P24TransactionParams alloc] init];

  // config
  p24TransactionParams.crc = params[@"crc"];
  p24TransactionParams.merchantId = [params[@"merchantId"] intValue];
  p24TransactionParams.urlStatus = params[@"p24UrlStatus"];
  p24TransactionParams.timeLimit = [params[@"timeLimit"] intValue];
  // p24TransactionParams.method = 25:mBank, 232:ApplePay;

  // transaction details
  p24TransactionParams.sessionId = params[@"sessionId"];
  p24TransactionParams.amount = [params[@"amount"] intValue];
  p24TransactionParams.currency = params[@"currency"];
  p24TransactionParams.desc = params[@"description"];
  p24TransactionParams.transferLabel = params[@"description"];
  // only cards?
  BOOL cardsOnly = [params[@"cardsOnly"] boolValue];
  if (cardsOnly)
  {
    p24TransactionParams.channel = P24_CHANNEL_CARDS;
  }
  // is sandbox?
  BOOL isSandbox = [params[@"enableTestMode"] boolValue];

  // user details
  p24TransactionParams.client = params[@"clientName"];
  p24TransactionParams.email = params[@"clientEmail"];
  p24TransactionParams.country = params[@"country"];
  p24TransactionParams.language = params[@"language"];

  // address details
  p24TransactionParams.address = params[@"clientAddress"];
  p24TransactionParams.city = params[@"clientCity"];
  p24TransactionParams.phone = params[@"clientPhone"];
  p24TransactionParams.zip = params[@"clientZipCode"];

  NSLog(@"\n\np24TransactionParams passed to P24 transaction:\n---");

  NSLog(@"Address: %@", p24TransactionParams.address);
  NSLog(@"Amount: %d", p24TransactionParams.amount);
  NSLog(@"Channel: %d", p24TransactionParams.channel);
  NSLog(@"City: %@", p24TransactionParams.city);
  NSLog(@"Client: %@", p24TransactionParams.client);
  NSLog(@"Country: %@", p24TransactionParams.country);
  NSLog(@"Crc: %@", p24TransactionParams.crc);
  NSLog(@"Currency: %@", p24TransactionParams.currency);
  NSLog(@"Desc: %@", p24TransactionParams.desc);
  NSLog(@"Email: %@", p24TransactionParams.email);
  NSLog(@"Language: %@", p24TransactionParams.language);
  NSLog(@"Merchant id: %d", p24TransactionParams.merchantId);
  NSLog(@"Method: %d", p24TransactionParams.method);
  NSLog(@"Phone: %@", p24TransactionParams.phone);
  NSLog(@"Session id: %@", p24TransactionParams.sessionId);
  NSLog(@"Shipping: %d", p24TransactionParams.shipping);
  NSLog(@"Time limit: %d", p24TransactionParams.timeLimit);
  NSLog(@"Transfer label: %@", p24TransactionParams.transferLabel);
  NSLog(@"Url status: %@", p24TransactionParams.urlStatus);
  NSLog(@"Zip: %@", p24TransactionParams.zip);
  NSLog(@"Cards Only: %@", cardsOnly ? @"YES" : @"NO");
  NSLog(@"SANDBOX: %@", isSandbox ? @"YES" : @"NO");

  p24TrnDirectParams = [[P24TrnDirectParams alloc] initWithTransactionParams:p24TransactionParams];

  if (isSandbox) {
    p24TrnDirectParams.sandbox = TRUE;
  }

  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CDVLaunchScreen" bundle:nil];
  MainViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"P24View"];
  [self.viewController presentViewController:controller animated:YES completion:nil];

  self.controller = controller;

  [P24 startTrnDirect:p24TrnDirectParams inViewController:controller delegate:self];
}

- (void)p24TransferOnSuccess
{
  NSString *info = @"P24 TRANSFER ON SUCCESS";
  NSLog(@"%@", info);

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:info];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];

  [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)p24TransferOnCanceled
{
  NSString *info = @"P24 TRANSFER ON CANCELED";
  NSLog(@"%@", info);
  // NSLog(@"callbackId: %d", self.command.callbackId);

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:info];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];

  [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)p24TransferOnError: (NSString*) errorCode
{
  NSString *info = @"P24 TRANSFER ON ERROR";
  NSLog(@"%@", info);
  NSLog(@"Error: %@", errorCode);

  NSString *full_info = [NSString stringWithFormat:@"%@: %@", info, errorCode];

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:full_info];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];

  [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
