//
//  PayViewController.swift
//  Svail
//
//  Created by Ronald Hernandez on 4/23/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import Foundation
class PayViewController: UIViewController, PTKViewDelegate {

    var payButton: UIBarButtonItem?
    var paymentView: PTKView?

    override func viewDidLoad() {
        super.viewDidLoad()

        paymentView = PTKView(frame: CGRectMake(15, 20, 290, 55))
        paymentView?.center = view.center
        paymentView?.delegate = self
        view.addSubview(paymentView!)

        payButton = UIBarButtonItem(title: "pay", style: UIBarButtonItemStyle.Plain, target: self, action: "createToken")
        payButton!.enabled = false
        navigationItem.rightBarButtonItem = payButton
    }

    func paymentView(paymentView: PTKView!, withCard card: PTKCard!, isValid valid: Bool) {
        payButton!.enabled = valid
    }

    func createToken() {
        let card = STPCard()
        card.number = paymentView!.card.number
        card.expMonth = paymentView!.card.expMonth
        card.expYear = paymentView!.card.expYear
        card.cvc = paymentView!.card.cvc

        STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token: STPToken!, error: NSError!) -> Void in
            println(token)
            self.handleToken(token)
        })
    }

    func handleToken(token: STPToken!) {
        //send token to backend and create charge
    }
}