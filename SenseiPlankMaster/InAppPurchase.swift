//
//  InAppPurchase.swift
//  PowerliftingStats
//
//  Created by Роман Кабиров on 11.10.17.
//  Copyright © 2017 Logical Mind. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchse {
    static let FULL_PRODUCT_ID = "logicalmind.dev.SenseiPlankMaster.Full"
    static var productID = ""
    static var productsRequest = SKProductsRequest()
    static var iapProducts = [SKProduct]()
    static var isFullVersionPurchased = UserDefaults.standard.bool(forKey: "FullUnlocked")
    static var productPriceStr: String = ""
}

extension ViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {

    func getAppName() -> String? {
        return "Sensei Plank Master"
    }
    
    func purchaseFullVersion() {
        
        let alert = UIAlertController(title: getAppName(), message: "Do you want to unlock full version?".localized + " " + InAppPurchse.productPriceStr, preferredStyle: .alert)
        let buyAction = UIAlertAction(title: "Buy".localized, style: .destructive) { (alert: UIAlertAction!) -> Void in
            self.purchaseMyProduct(product: InAppPurchse.iapProducts[0])
        }
        let restore = UIAlertAction(title: "Restore purchase".localized, style: .default, handler: {(_) in
            // self.delegate?.userConfirmedPurchase()
            self.restorePurchase()
        })

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) { (alert: UIAlertAction!) -> Void in
        }
        
        alert.addAction(buyAction)
        alert.addAction(restore)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion:nil)
    }
    
    func fetchAvailableProducts()  {
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            InAppPurchse.FULL_PRODUCT_ID
        )
        
        InAppPurchse.productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        InAppPurchse.productsRequest.delegate = self
        InAppPurchse.productsRequest.start()
    }
    
    
    func restorePurchase() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        InAppPurchse.isFullVersionPurchased = true
        UserDefaults.standard.set(InAppPurchse.isFullVersionPurchased, forKey: "FullUnlocked")
    }
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            InAppPurchse.iapProducts = response.products
            
            let secondProd = response.products[0] as SKProduct
            
            // Get its price from iTunes Connect
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            
            // Get its price from iTunes Connect
            numberFormatter.locale = secondProd.priceLocale
            let price2Str = numberFormatter.string(from: secondProd.price)
            
            // Show its description
            InAppPurchse.productPriceStr = secondProd.localizedDescription + "\n" + "for".localized + " \(price2Str!)"
        }
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            InAppPurchse.productID = product.productIdentifier
        } else {
            let alert = UIAlertController(title: getAppName(), message: "Purchases are disabled on your device!".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                // print("OK")
            })
            present(alert, animated: true)
        }
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if InAppPurchse.productID == InAppPurchse.FULL_PRODUCT_ID {
                        
                        // Save your purchase locally (needed only for Non-Consumable IAP)
                        InAppPurchse.isFullVersionPurchased = true
                        UserDefaults.standard.set(InAppPurchse.isFullVersionPurchased, forKey: "FullUnlocked")
                        
                        let alert = UIAlertController(title: getAppName(), message: "You've successfully unlocked the full version".localized, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            print("OK")
                        })
                        present(alert, animated: true)
                        
                    }
                    
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    InAppPurchse.isFullVersionPurchased = true
                    UserDefaults.standard.set(InAppPurchse.isFullVersionPurchased, forKey: "FullUnlocked")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }

    
}
