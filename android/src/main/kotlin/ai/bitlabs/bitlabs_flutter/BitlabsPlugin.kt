package ai.bitlabs.bitlabs_flutter

import android.app.Activity
import ai.bitlabs.sdk.BitLabs
import ai.bitlabs.sdk.offerwall.Offerwall
import ai.bitlabs.sdk.util.OnOfferwallClosedListener
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** BitlabsPlugin */
class BitlabsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var offerwall: Offerwall

    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bitlabs")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> initImpl(call, result)
            "setTags" -> setTagsImpl(call, result)
            "addTag" -> addTagImpl(call, result)
            "launchOfferWall" -> launchOfferWallImpl(result)
            "getSurveys" -> getSurveysImpl(result)
            "checkSurveys" -> checkSurveysImpl(result)
            "openOffer" -> openOfferImpl(call, result)
            "openMagicReceiptsOffer" -> openMagicReceiptsOfferImpl(call, result)
            "openMagicReceiptsMerchant" -> openMagicReceiptsMerchantImpl(call, result)
            else -> result.notImplemented()
        }
    }

    private fun initImpl(call: MethodCall, result: Result) = activity?.let {
        val token = call.argument<String>("token") ?: ""
        val uid = call.argument<String>("uid") ?: ""
        offerwall = BitLabs.OFFERWALL.create(token, uid)

        offerwall.onOfferwallClosedListener = OnOfferwallClosedListener { totalReward ->
            channel.invokeMethod("onReward", mapOf("reward" to totalReward))
        }

        BitLabs.API.init(token, uid)
        result.success("BitLabs initialised")
    } ?: result.error("Error", "Activity is null", null)

    private fun setTagsImpl(call: MethodCall, result: Result) {
        val tags = call.argument<Map<String, Any>>("tags") ?: run {
            result.error("Error", "Invalid tags argument", null)
            return
        }

        offerwall.tags.putAll(tags.toMutableMap())
        result.success("Tags set")
    }

    private fun addTagImpl(call: MethodCall, result: Result) {
        val key = call.argument<String>("key") ?: run {
            result.error("Error", "Invalid key argument", null)
            return
        }
        val value = call.argument<String>("value") ?: run {
            result.error("Error", "Invalid value argument", null)
            return
        }

        offerwall.tags[key] = value
        result.success("Tag added")
    }

    private fun launchOfferWallImpl(result: Result) = activity?.let {
        offerwall.launch(it)
        result.success("Offerwall launched")
    } ?: result.error("Error", "Activity is null", null)

    private fun getSurveysImpl(result: Result) = BitLabs.API.getSurveys(
        { surveys ->
            val surveysMap = surveys.map { survey -> survey.toMap() }
            result.success(surveysMap)
        },
        { exception -> result.error("Error", exception.message, null) }
    )

    private fun checkSurveysImpl(result: Result) = BitLabs.API.checkSurveys(
        { surveysExist -> result.success(surveysExist) },
        { exception -> result.error("Error", exception.message, null) }
    )

    private fun openOfferImpl(call: MethodCall, result: Result) = activity?.let {
        val offerId = call.argument<String>("offerId") ?: run {
            result.error("Error", "Invalid offerId argument", null)
            return
        }
        offerwall.openOffer(it, offerId)
        result.success("Offer opened")
    } ?: result.error("Error", "Activity is null", null)

    private fun openMagicReceiptsOfferImpl(call: MethodCall, result: Result) = activity?.let {
        val offerId = call.argument<String>("offerId") ?: run {
            result.error("Error", "Invalid offerId argument", null)
            return
        }
        offerwall.openMagicReceiptsOffer(it, offerId)
        result.success("Magic Receipts Offer opened")
    } ?: result.error("Error", "Activity is null", null)

    private fun openMagicReceiptsMerchantImpl(call: MethodCall, result: Result) = activity?.let {
        val merchantId = call.argument<String>("merchantId") ?: run {
            result.error("Error", "Invalid merchantId argument", null)
            return
        }
        offerwall.openMagicReceiptsMerchant(it, merchantId)
        result.success("Magic Receipts Merchant opened")
    } ?: result.error("Error", "Activity is null", null)

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ActivityAware methods
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
