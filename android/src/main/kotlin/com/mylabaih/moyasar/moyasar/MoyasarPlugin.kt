package com.mylabaih.moyasar.moyasar

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultCallback
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.moyasar.android.sdk.*
import com.moyasar.android.sdk.payment.models.Payment
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MoyasarPlugin */
class MoyasarPlugin : FlutterPlugin, MethodCallHandler, PaymentSheetResultCallback, ActivityAware {

    private lateinit var channel: MethodChannel
    private var flutterResult: Result? = null
    private var activity: FlutterFragmentActivity? = null
    private val activityResultCallback = ActivityResultCallback<ActivityResult> {

        if (it.resultCode == Activity.RESULT_OK) {
            val data = it.data
            if(data!=null) {
                if (!data.getBooleanExtra("erred", false)) {
                    handleSuccess(data)
                } else {
                    handleErrors(data)
                }
            }else{
                flutterResult?.error("cancel", "Payment canceled", "")
            }
        } else {
            flutterResult?.error("cancel", "Payment canceled", "")
        }
    }
    private var activityResultLauncher: ActivityResultLauncher<Intent>? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "moyasar")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d("MEGA", "onMethodCall: ${call.method} ${call.arguments}")
        when (call.method) {
            "start" -> {
                this.flutterResult = result
                beginPayment(call)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun beginPayment(
        call: MethodCall,
    ) {

        val map = call.arguments<Map<String, Any>>()
        Log.d("MEGA", "beginPayment: $map")
        assert(activity != null) {
            "activity null."
        }
        if (map != null && map.containsKey("api_key")) {
            val baseUrl = map["base_url"]?.toString()

            val config = PaymentConfig(
                (map["amount"].toString().toDouble()).toInt(),
                currency = map["currency"].toString(),
                description = map["description"]?.toString() ?: "",
                metadata = @Suppress("UNCHECKED_CAST")
                (map["meta_data"] as? Map<String, String> ?: mapOf()),
                apiKey = map["api_key"].toString(),
                baseUrl = if (baseUrl != null && baseUrl.isNotEmpty()) baseUrl else "https://api.moyasar.com/"
            )
            val intent = Intent(activity!!, PaymentMiddleManActivity::class.java)
            intent.putExtra("config", config)
            activityResultLauncher?.launch(intent)

        } else {
            flutterResult?.error("error", "Api key not set", "")
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onResult(result: PaymentResult) {

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as? FlutterFragmentActivity
        activityResultLauncher = activity?.registerForActivityResult(
            ActivityResultContracts.StartActivityForResult(),
            activityResultCallback
        )
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity as? FlutterFragmentActivity
        activityResultLauncher = activity?.registerForActivityResult(
            ActivityResultContracts.StartActivityForResult(),
            activityResultCallback
        )

    }

    override fun onDetachedFromActivity() {
        activity = null
    }


    @Suppress("DEPRECATION")
    private fun handleSuccess(data: Intent) {
        val payment = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            data.getParcelableExtra("result", Payment::class.java)
        } else {
            data.getParcelableExtra<Payment>("result")
        }

        if (payment != null) {
            Log.d("MEGA", "handleSuccess: $payment")
            flutterResult?.success(
                mapOf(
                    "id" to payment.id,
                    "status" to payment.status,
                    "amount" to payment.amount,
                    "amountFormat" to "",
                    "fee" to payment.fee,
                    "feeFormat" to "",
                    "currency" to payment.currency,
                    "refunded" to payment.refunded,
                    "source" to mapSource(payment),
                    "refundedAt" to (payment.refundedAt ?: ""),
                    "refundedFormat" to (""),
                    "captured" to payment.captured,
                    "capturedAt" to (payment.capturedAt ?: ""),
                    "capturedFormat" to "",
                    "voidedAt" to (payment.voidedAt ?: ""),
                    "description" to (payment.description ?: ""),
                    "invoiceId" to (payment.invoiceId ?: ""),
                    "ip" to (payment.ip ?: ""),
                    "callbackUrl" to (payment.callbackUrl ?: ""),
                    "createdAt" to payment.createdAt,
                    "updatedAt" to payment.updatedAt,
                    "metaData" to (payment.metadata ?: mapOf<String, Any>())
                )
            )
        } else {
            flutterResult?.error("error", "payment did not complete", "")
        }
    }

    private fun mapSource(payment: Payment) =
        mapOf<String, Any?>(
            "type" to payment.source["type"],
            "company" to payment.source["company"],
            "name" to payment.source["name"],
            "number" to payment.source["number"],
            "gateway_id" to payment.source["gateway_id"],
            "reference_number" to payment.source["reference_number"],
            "token" to payment.source["token"],
            "message" to payment.source["message"],
            "transaction_url" to payment.source["transaction_url"],
        )

    @Suppress("DEPRECATION")
    private fun handleErrors(data: Intent) {
        val error = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            data.getSerializableExtra("error", Throwable::class.java)
        } else {
            data.getSerializableExtra("error") as Throwable
        }
        flutterResult?.error("error", error?.localizedMessage, error?.message)
    }


}

//PaymentResponse
// {id: dc199ede-b83c-4287-9adf-75aaf72cb947
// status: paid
// amount: 100
// amountFormat: 1.00 SAR
// fee: 0
// feeFormat: 0.00 SAR
// currency: SAR
// refunded: 0
// source: {type: creditcard,
// name: creditcard, number: creditcard, gateWay: null, referenceNumber: null, token: null, message: null, transactionUrl: null}	refundedAt: 	refundedFormat: 0.00 SAR	captured: 0	capturedAt: 	capturedFormat: 0.00 SAR	voidedAt: 	description: SAR	invoiceId: 	ip: 130.164.168.254	callbackUrl: https://sdk.moyasar.com/return	createdAt: 2022-09-26T11:30:50.029Z	updatedAt: 2022-09-26T11:30:50.029Z	metaData: {sdk: ios}}