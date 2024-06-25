//
//  ApiPayment+Extension.swift
//  moyasar
//
//  Created by LaBaih on 27/09/2022.
//

import Foundation
import MoyasarSdk

extension NSDictionary{
    func toPaymentRequest() -> PaymentRequest{
        return PaymentRequest(
            amount: self.int(forKey: "amount"),
            currency: "SAR",
            description: self.value(forKey: "description") as? String ?? "",
            metadata: self.value(forKey: "meta_data") as? [String:String] ?? [:]
        )
    }
    
    func int(forKey key: String)->Int{
        return value(forKey: key) as? Int ?? 0
    }
}

extension ApiPayment{
    func dictionary() ->[String:Any]{
        let source = NSMutableDictionary()
    
        switch self.source{
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
            "id" : id,
            "status" : status,
            "amount" : amount,
            "amountFormat" : amountFormat,
            "fee" : fee,
            "feeFormat" : feeFormat ?? "",
            "currency" : currency,
            "refunded" : refunded,
            "source" :  [
                "type": source.value(forKey: "type"),
                "name": source.value(forKey:"name"),
                "number": source.value(forKey:"number"),
                "company": source.value(forKey: "company"),
                "gateway_id": source.value(forKey:"gateway_id"),
                "reference_number":source.value(forKey:"referenceNumber"),
                "token": source.value(forKey:"token"),
                "message": source.value(forKey:"message"),
                "transaction_url": source.value(forKey:"transactionUrl")
            ],
            "refundedAt" : refundedAt ?? "",
            "refundedFormat" : refundedFormat ?? "",
            "captured" : captured,
            "capturedAt" : capturedAt ?? "",
            "capturedFormat" : capturedFormat ?? "",
            "voidedAt" : voidedAt ?? "",
            "description" : description ?? "",
            "invoiceId" : invoiceId ?? "",
            "ip" : ip ?? "",
            "callbackUrl" : callbackUrl ?? "",
            "createdAt" : createdAt,
            "updatedAt" : updatedAt,
            "metaData" : metadata ?? [:] ]
        return paymentResponse
    }
}
