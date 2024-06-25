//
//  ApplePayViewController.swift
//  moyasar
//
//  Created by LaBaih on 25/09/2022.
//

import Foundation
import MoyasarSdk
import PassKit
class ApplePayViewController : UIViewController{
    var methodCall:FlutterMethodCall!
    var flutterResult:FlutterResult!
    var supportedNetworks: [PKPaymentNetwork]!
    private let applePayService = ApplePayService()
    private var didStartPayment = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = .clear
        view.layer.backgroundColor = UIColor.clear.cgColor
        let controller = PKPaymentAuthorizationController(paymentRequest: createPaymentRequestFromResult())
        controller.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: { [weak self] in
            controller.present(completion: { (presented: Bool) in
                if presented {
                    self?.didStartPayment = true
                } else {
                    self?.dismiss(animated: true)
                    self?.flutterResult(FlutterError(code: "error", message: "Failed to present payment controller", details: nil))
                }
            })
        })
        
    }
    
    private func createPaymentRequestFromResult()->PKPaymentRequest{
        let args = methodCall.arguments as! NSDictionary

        let merchantId = args.value(forKey: "merchant_id") as? String
        
        let paymentRequest =  PKPaymentRequest()
        if let merchantId = merchantId {
            paymentRequest.merchantIdentifier = merchantId
        }else{
            flutterResult(FlutterError(code: "apple005", message: "Merchant Identifier not found.", details: ""))
            self.dismiss(animated: true)
        }
    
        paymentRequest.supportedNetworks = supportedNetworks
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "SA"
        paymentRequest.currencyCode = "SAR"
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "LaBaih Trading Co", amount:NSDecimalNumber(value: ((args.value(forKey: "amount") as? Double ?? 1) / 100)))
        ]
        return paymentRequest
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if didStartPayment{
            flutterResult(FlutterError(code: "cancel", message: "payment canceled.", details: ""))
        }
    }
}

extension ApplePayViewController : PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss{
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    func paymentAuthorizationControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationController) {
        didStartPayment = true
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        do{
            didStartPayment = true
            let request: PaymentRequest = (methodCall.arguments as! NSDictionary).toPaymentRequest()
            try applePayService.authorizePayment(request: request, token: payment.token) { apiResult in
                switch apiResult{
                case .success(let apiPayment):
                    self.flutterResult(apiPayment.dictionary())
                    if apiPayment.status == "paid"{
                        completion(.init(status: .success, errors: nil))
                    }else{
                        completion(.init(status: .failure, errors: []))
                    }
                    break
                case .error(let error):
                    completion(.init(status: .failure, errors: []))
                    self.flutterResult(FlutterError(code: "apple003", message: error.localizedDescription, details: ""))
                    break
                @unknown default:
                    break
                }
                
            }
        }catch{
            didStartPayment = false
            self.flutterResult(FlutterError(code: "apple004", message: "Failed to complete payment.", details: ""))
            completion(.init(status: .failure, errors: []))
        }
    }
    
    
    
}
