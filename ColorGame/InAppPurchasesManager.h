//
//  InAppPurchasesManager.h
//  Zen Habits Reader
//
//  Created by Keegan on 1/4/16.
//  Copyright © 2016 Keegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
static NSString* const IAPLoadedNotification = @"IAPLoadedNotification";
static NSString* const PointsIncreasedNotification = @"PointsIncreasedNotification";
static NSString* const PointsMultiplierPurchaseIdentifier = @"PointsMultiplier";
static NSString* const Buy500PurchaseIdentifier = @"500Points";

@interface InAppPurchasesManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property BOOL TransactionInProgress;
@property (nonatomic, strong) NSMutableArray* purchasesArray;

+ (InAppPurchasesManager *) sharedInstance;
- (void) initialiseInViewController:(UIViewController*)viewController;
- (void) presentPurchaseDialogInViewController: (UIViewController*)viewController forProductIdentifier: (NSString*)productIdentifier;
- (void)setPrimaryColor: (UIColor*)primaryColor;
- (NSString*)identifierForProductAtIndex:(NSInteger)index;
@end
