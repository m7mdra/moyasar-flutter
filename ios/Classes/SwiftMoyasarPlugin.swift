import Flutter
import UIKit
import MoyasarSdk
import SwiftUI
import PassKit
public class SwiftMoyasarPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "moyasar", binaryMessenger: registrar.messenger())
        let instance = SwiftMoyasarPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    var supportedNetworks: [PKPaymentNetwork] = [.visa,.mada,.masterCard]
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "start" {
            setupApiKey(call,result)
            startPayment(call, result: result)
        } else if call.method == "applePayAuthorization" {
            result(canMakePayment())
        } else if call.method == "setupPayment"{
            PKPassLibrary().openPaymentSetup()
        } else if call.method == "applePay"{
            
            if canMakePayment(){
                setupApiKey(call, result)
                let appDelegate = UIApplication.shared.delegate
                if let navigationController = appDelegate?.window??.rootViewController as? UINavigationController{
                    let controller = ApplePayViewController()
                    controller.supportedNetworks = supportedNetworks
                    controller.flutterResult = result
                    controller.methodCall = call
                    controller.modalPresentationStyle = .overCurrentContext
                    navigationController.present(controller, animated: true)
                }else{
                    result(FlutterError(code: "apple002", message: "Unable to start payment", details: ""))
                }
            }else{
                result(FlutterError(code: "apple001", message: "apple payment is not setup", details: ""))
            }
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
    func startPayment(_ call:FlutterMethodCall, result: @escaping FlutterResult){
        let appDelegate = UIApplication.shared.delegate
        if let navigationController = appDelegate?.window??.rootViewController as? UINavigationController{
            let controller = PaymentHostingController(methodCall: call, flutterResult: result)
            navigationController.pushViewController(controller, animated: false)
        }
    }
    
    private func canMakePayment() -> Bool{
        return PKPaymentAuthorizationViewController.canMakePayments() &&
        PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks)
    }
    
    private func setupApiKey(_ call:FlutterMethodCall,_ result: @escaping FlutterResult){
        let args = call.arguments as? NSDictionary
        let apiKey = args?.value(forKey: "api_key") as? String
        if let apiKey = apiKey{
            try? Moyasar.setApiKey(apiKey)
            let baseUrl = args?.value(forKey: "base_url") as? String
            if let url = baseUrl{
                Moyasar.baseUrl = url
            }
        }else{
            result(FlutterError(code: "error", message: "Api key not set", details: ""))
        }
    }
    
}



