//
//  File.swift
//  moyasar
//
//  Created by LaBaih on 25/09/2022.
//

import Foundation
import MoyasarSdk
import SwiftUI
import UIKit

class PaymentHostingController : UIHostingController<AnyView>{
    var methodCall:FlutterMethodCall!
    var flutterResult:FlutterResult!
    private var didStartPayment = false
    lazy var swiftUiView: CreditCardView = {
        let args = methodCall.arguments as! NSDictionary
        
        return CreditCardView(request: args.toPaymentRequest(), callback: handlePaymentResult(result:))
    }()
    
    init(methodCall:FlutterMethodCall,flutterResult:@escaping FlutterResult) {
        super.init(rootView: AnyView(Rectangle()))
        self.methodCall = methodCall
        self.flutterResult = flutterResult
        rootView = AnyView(VStack(alignment:.leading){
            Button (action: {
                self.navigationController?.popViewController(animated: true)
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            }).frame(width: 30,height: 30)
                .padding()
            
            VStack{
                swiftUiView
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
    }
    
    func handlePaymentResult(result: PaymentResult) {
        didStartPayment = true
        switch result{
        case .canceled:
            flutterResult(FlutterError(code: "cancel", message: "payment canceled.", details: ""))
            navigationController?.popViewController(animated: true)
            break
        case let .completed(payment):
            let source = NSMutableDictionary()
            switch payment.source{
            case .creditCard(let data):
                let jsonData = try? JSONEncoder().encode(data)
                if let data = jsonData{
                    let encodedSource = (try? JSONSerialization.jsonObject(with: data) as? [String:Any]) ?? [String:Any]()
                    source.addEntries(from: encodedSource)
                }
            case .applePay(let data):
                let jsonData = try? JSONEncoder().encode(data)
                if let data = jsonData{
                    let encodedSource = (try? JSONSerialization.jsonObject(with: data) as? [String:Any]) ?? [String:Any]()
                    source.addEntries(from: encodedSource)
                }
            case .stcPay(let data):
                let jsonData = try? JSONEncoder().encode(data)
                if let data = jsonData{
                    let encodedSource = (try? JSONSerialization.jsonObject(with: data) as? [String:Any]) ?? [String:Any]()
                    source.addEntries(from: encodedSource)
                }
            @unknown default:
                break
            }
            let paymentResponse : [String:Any] = [
                "id" : payment.id,
                "status" : payment.status,
                "amount" : payment.amount,
                "amountFormat" : payment.amountFormat,
                "fee" : payment.fee,
                "feeFormat" : payment.feeFormat ?? "",
                "currency" : payment.currency,
                "refunded" : payment.refunded,
                "source" :  [
                    "type": source.value(forKey: "type"),
                    "name": source.value(forKey:"name"),
                    "number": source.value(forKey:"number"),
                    "gateway_id": source.value(forKey:"gateway_id"),
                    "reference_number":source.value(forKey:"referenceNumber"),
                    "token": source.value(forKey:"token"),
                    "message": source.value(forKey:"message"),
                    "transaction_url": source.value(forKey:"transactionUrl")
                ],
                "refundedAt" : payment.refundedAt ?? "",
                "refundedFormat" : payment.refundedFormat ?? "",
                "captured" : payment.captured,
                "capturedAt" : payment.capturedAt ?? "",
                "capturedFormat" : payment.capturedFormat ?? "",
                "voidedAt" : payment.voidedAt ?? "",
                "description" : payment.description ?? "",
                "invoiceId" : payment.invoiceId ?? "",
                "ip" : payment.ip ?? "",
                "callbackUrl" : payment.callbackUrl ?? "",
                "createdAt" : payment.createdAt,
                "updatedAt" : payment.updatedAt,
                "metaData" : payment.metadata ?? [:] ]
            flutterResult(paymentResponse)
            navigationController?.popViewController(animated: true)
            break
        case let .failed(error):
            handlePaymentError(error)
            break
        default:
            break
        }
    }
    
    
    
    private func handlePaymentError(_ error: Error) {
        didStartPayment = true
        
        switch error{
        case MoyasarError.apiError(let message):
            flutterResult(FlutterError(code: "error", message: message.message, details: ""))
            break
        case MoyasarError.authorizationError(let message):
            flutterResult(FlutterError(code: "error", message: message, details: ""))
            break
        case MoyasarError.networkError(let message):
            flutterResult(FlutterError(code: "error", message: message.localizedDescription, details: ""))
            break
        case MoyasarError.invalidApiKey(let message):
            flutterResult(FlutterError(code: "error", message: message, details: ""))
            break
        case MoyasarError.unexpectedError(let message):
            flutterResult(FlutterError(code: "error", message: message, details: ""))
            break
        default:
            flutterResult(FlutterError(code: "error", message: "unknown error", details: ""))
            break
        }
        navigationController?.popViewController(animated: true)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //        navigationController?.setNavigationBarHidden(true, animated: true)
        if !didStartPayment{
            flutterResult(FlutterError(code: "cancel", message: "payment canceled.", details: ""))
        }
    }
    
    
    deinit {
        navigationController?.delegate = nil
    }
}

extension PaymentHostingController : UINavigationControllerDelegate{
    
}
