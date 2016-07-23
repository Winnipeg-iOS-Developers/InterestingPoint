//
//  AlertProvider.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-07-22.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import UIKit

protocol AlertProvider {
    /// Present Alert for error from viewController parameter.
    func present(error: ErrorType, from viewController: UIViewController)
}

class AlertService: AlertProvider {
    static let sharedInstance = AlertService()
    private init() {}  // Enforce singleton; prevent others from instantiating instances.
    
    func present(error: ErrorType, from viewController: UIViewController) {
        let error = error as NSError
        
        let alertController = UIAlertController(
            title: "COULD NOT COMPUTE",
            message: error.localizedDescription,
            preferredStyle: .Alert
        )
        
        let okAction = UIAlertAction(title: "Ok???", style: .Default) { (alertAction) in
            print("do I need to dismiss?")
        }
        
        alertController.addAction(okAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}