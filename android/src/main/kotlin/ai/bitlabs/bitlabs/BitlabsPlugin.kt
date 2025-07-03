package ai.bitlabs.bitlabs

import android.app.Activity
import ai.bitlabs.sdk.BitLabs
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** BitlabsPlugin */
class BitlabsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel

  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bitlabs")
    channel.setMethodCallHandler(this)

    BitLabs.setOnRewardListener { reward ->
      channel.invokeMethod("onReward", mapOf("reward" to reward))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "init" -> initImpl(call, result)
      "setTags" -> setTagsImpl(call, result)
      "launchOfferWall" -> launchOfferWallImpl(result)
      "getSurveys" -> getSurveysImpl(result)
      "checkSurveys" -> checkSurveysImpl(result)
      else -> result.notImplemented()
    }
  }

  private fun initImpl(call: MethodCall, result: Result) = activity?.let {
    val token = call.argument<String>("token") ?: ""
    val uid = call.argument<String>("uid") ?: ""
    BitLabs.init(it, token, uid)
    BitLabs.API.init(token, uid)
    result.success("BitLabs initialised")
  } ?: result.error("Error", "Activity is null", null)

  private fun setTagsImpl(call: MethodCall, result: Result) {
    val tags = call.argument<Map<String, Any>>("tags") ?: run {
      result.error("Error", "Invalid tags argument", null)
      return
    }

    BitLabs.tags = tags.toMutableMap()
    result.success("Tags set")
  }

  private fun launchOfferWallImpl(result: Result) = activity?.let {
    BitLabs.launchOfferWall(it)
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
