package com.mylabaih.moyasar.moyasar

import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.window.OnBackInvokedCallback
import com.moyasar.android.sdk.PaymentConfig
import com.moyasar.android.sdk.PaymentResult
import com.moyasar.android.sdk.PaymentSheet
import com.moyasar.android.sdk.PaymentSheetResultCallback

class PaymentMiddleManActivity : AppCompatActivity(), PaymentSheetResultCallback {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val paymentConfig = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra<PaymentConfig>("config", PaymentConfig::class.java)
        } else {
            intent.getParcelableExtra<PaymentConfig>("config")
        }
        if (paymentConfig == null) {
            error(PaymentResult.Failed(Error()))
            finish()
            return;
        }
        val paymentSheet = PaymentSheet(this, this, paymentConfig)
        paymentSheet.present()
    }

    override fun onResult(result: PaymentResult) {
        when (result) {
            is PaymentResult.Completed -> success(result)
            is PaymentResult.Failed -> error(result)
            PaymentResult.Canceled -> canceled()
        }
        finish()
    }

    private fun success(result: PaymentResult.Completed) {
        val intent = Intent()
        intent.putExtra("result", result.payment)
        intent.putExtra("erred", false)
        setResult(RESULT_OK, intent)
    }

    private fun error(result: PaymentResult.Failed) {
        val intent = Intent()
        intent.putExtra("erred", true)
        intent.putExtra("error", result.error)
        setResult(RESULT_OK, intent)
    }

    override fun onBackPressed() {
        canceled()
        super.onBackPressed()
    }

    private fun canceled() {
        setResult(RESULT_CANCELED)
    }
}