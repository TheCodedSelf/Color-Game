//
//  InAppPurchasesManager.m
//  Zen Habits Reader
//
//  Created by Keegan on 1/4/16.
//  Copyright © 2016 Keegan. All rights reserved.
//

#import "InAppPurchasesManager.h"
#import "ColorGame-swift.h"
@implementation InAppPurchasesManager

bool const ShouldShowIAP = NO;

UIColor* appPrimaryColor;
NSString* currentProductIdentifier;


- (NSString*)identifierForProductAtIndex:(NSInteger)index
    {
    return ((SKProduct*)self.purchasesArray[index]).productIdentifier;
    }

- (void)setPrimaryColor: (UIColor*)primaryColor
    {
    appPrimaryColor = primaryColor;
    }

+ (InAppPurchasesManager *) sharedInstance
    {
    static InAppPurchasesManager *sharedInstance;
    if (sharedInstance == nil)
        {
        sharedInstance = [[InAppPurchasesManager alloc] init];
        sharedInstance.purchasesArray = [[NSMutableArray alloc] init];
        }
    
    return sharedInstance;
    }

- (void) initialiseInViewController:(UIViewController*)viewController
    {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self requestProductInfoInViewController:viewController];
    }

- (void) displayPurchasesErrorAlertInViewController:(UIViewController*)viewController
    {
    UIAlertController* alertController =  [UIAlertController alertControllerWithTitle:@"A Problem Occurred" message:@"In App Purchases are not available right now." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
    [alertController addAction: cancelAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    alertController.view.tintColor = appPrimaryColor;
        
    NSLog(@"Cannot perform In App Purchases.");
    }

- (void) requestProductInfoInViewController:(UIViewController*)viewController
    {
    if ([SKPaymentQueue canMakePayments])
        {
        NSSet<NSString*>* identifiers = [[NSSet alloc] initWithObjects:PointsMultiplierPurchaseIdentifier, Buy500PurchaseIdentifier, nil];
        SKProductsRequest* productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
        productRequest.delegate = self;
        [productRequest start];
        }
    else
        {
        [self displayPurchasesErrorAlertInViewController:viewController];
        }
    }

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
    {
    if (response.products.count != 0)
        {
        if (response.products.count < 2)
            {
            [self presentAlertWithTitle:@"Problem" andText:@"One of the app purchases couldn't be found"];
            return;
            }
            if (response.products.count > 2)
            {
                [self presentAlertWithTitle:@"Problem" andText:@"Only two purchases were expected, but there appears to be more."];
                return;
            }
            
        for (int i = 0; i < response.products.count; i++)
            {
            [self.purchasesArray addObject:response.products[i]];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:IAPLoadedNotification object:nil];
        
        }
    else
        {
        NSLog(@"No products found");
        [self presentAlertWithTitle:@"Problem" andText:@"No products found"];
        }
        
        if (response.invalidProductIdentifiers.count != 0)
            {
            [self presentAlertWithTitle:@"Problem" andText:@"Invalid product identifiers"];
            NSLog(@"Invalid product identifiers!");
            }
    }

- (void) presentPurchaseDialogInViewController: (UIViewController*)viewController forProductIdentifier: (NSString*)productIdentifier
    {
    currentProductIdentifier = productIdentifier;
    SKProduct* product;
    for (int i = 0; i < self.purchasesArray.count; i++)
        {
        if ([((SKProduct*)self.purchasesArray[i]).productIdentifier isEqualToString:productIdentifier])
            {
            product = ((SKProduct*)self.purchasesArray[i]);
            }
        }
    if (self.TransactionInProgress)
        {
        return;
        }   
        
    UIAlertController* alertController =  [UIAlertController alertControllerWithTitle:product.localizedTitle message:product.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    __weak InAppPurchasesManager* weakSelf = self;
    
    UIAlertAction* buyAction = [UIAlertAction actionWithTitle:@"Buy" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
         {
         if (self.purchasesArray.count < 2)
             {
             [self displayPurchasesErrorAlertInViewController:viewController];
             return;
             }
         SKPayment* payment = [SKPayment paymentWithProduct:product];
         [[SKPaymentQueue defaultQueue] addPayment:payment];
             
         weakSelf.TransactionInProgress = true;
         }];
 
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Maybe Later" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
                                   {
                                   }];
        
     [alertController addAction: buyAction];
     [alertController addAction: cancelAction];
     [viewController presentViewController:alertController animated:YES completion:nil];
      alertController.view.tintColor = appPrimaryColor;
    }

- (void)processSuccessfulPurchase
    {
    if ([currentProductIdentifier isEqualToString:Buy500PurchaseIdentifier])
        {
        NSInteger points;
            points =  [[AppManager sharedInstance] currentPoints];//(NSInteger)[[NSUserDefaults standardUserDefaults] objectForKey:@"POINTS"];
        points += 500;
        [[AppManager sharedInstance] setCurrentPoints:points];
        [[NSNotificationCenter defaultCenter]postNotificationName:PointsIncreasedNotification object:nil];
        }
    else if ([currentProductIdentifier isEqualToString:PointsMultiplierPurchaseIdentifier])
        {
            NSInteger rounds;
            rounds = [[AppManager sharedInstance] pointsMultiplierRounds];
            rounds += 100;
            [[AppManager sharedInstance] setPointsMultiplierRounds: rounds];
        }
    }

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
    {
    for (SKPaymentTransaction* transaction in transactions)
        {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Transaction completed successfully.");
//                [self presentAlertWithTitle:@"Purchase successful" andText:@"The purchase was successful"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                self.TransactionInProgress = false;
                [self processSuccessfulPurchase];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                self.TransactionInProgress = false;
                [self presentAlertWithTitle:@"In App Purchase" andText:@"I'm sorry, the purchase failed. Please try again later."];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction restored successfully.");
                [self presentAlertWithTitle:@"Restore Purchase" andText:@"Your purchase has been restored."];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                self.TransactionInProgress = false;
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"Transaction Deferred");
                [self presentAlertWithTitle:@"In App Purchase" andText:@"The transaction is in the queue, but its final status is pending external action."];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction purchasing");
                break;
            default:
                break;
            }
        }
    }

- (void)presentAlertWithTitle: (NSString*)title andText:(NSString*)text
    {
    if (ShouldShowIAP == NO)
        {
        return;
        }
        
    UIAlertController* alertController =  [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction: cancelAction];
    
    [[[UIApplication sharedApplication]windows][0].rootViewController presentViewController:alertController animated:YES completion:nil];
    alertController.view.tintColor = appPrimaryColor;
    }
@end
