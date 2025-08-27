import BLCustom
import Flutter
import UIKit

public class BitlabsPlugin: NSObject, FlutterPlugin {
    var offerwall: Offerwall?
    
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let ch = FlutterMethodChannel(name: "bitlabs", binaryMessenger: registrar.messenger())
        let instance = BitlabsPlugin(channel: ch)
        registrar.addMethodCallDelegate(instance, channel: ch)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init": initImpl(call, result)
        case "addTag": addTagImpl(call, result)
        case "setTags": setTagsImpl(call, result)
        case "launchOfferWall": launchOfferWallImpl(result)
        case "getSurveys": getSurveysImpl(result)
        case "checkSurveys": checkSurveysImpl(result)
        case "openOffer": openOfferImpl(call, result)
        case "openMagicReceiptsOffer": openMagicReceiptsOfferImpl(call, result)
        case "openMagicReceiptsMerchant": openMagicReceiptsMerchantImpl(call, result)
        case "requestTrackingAuthorization": requestTrackingAuthorizationImpl(result)
        default: result(FlutterMethodNotImplemented)
        }
    }

    private func initImpl(_ call: FlutterMethodCall, _ result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let token = arguments["token"] as? String,
              let uid = arguments["uid"] as? String
        else {
            result(FlutterError(code: "Error", message: "Invalid arguments", details: nil))
            return
        }
        
        offerwall = BitLabs.OFFERWALL.create(token: token, uid: uid)
        
        offerwall?.offerwallClosedHandler = { reward in
            self.channel.invokeMethod("onReward", arguments: ["reward": reward])
        }
        result("BitLabs initialized")
    }

    private func launchOfferWallImpl(_ result: FlutterResult) {
        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController else {
            result(FlutterError(code: "Error", message: "Unable to access UIApplication's window", details: nil))
            return
        }

        offerwall?.launch(parent: topViewController)
        result("Offer wall launched")
    }

    private func addTagImpl(_ call: FlutterMethodCall, _ result:FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let key = arguments["key"] as? String,
              let value = arguments["value"] as? String
        else {
            result(FlutterError(code: "Error", message: "Invalid arguments", details: nil))
            return
        }

        offerwall?.tags[key] = value
    }

    private func setTagsImpl(_ call: FlutterMethodCall, _ result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let tags = arguments["tags"] as? [String: Any]
        else {
            result(FlutterError(code: "Error", message: "Invalid tags argument", details: nil))
            return
        }

        offerwall?.tags = tags
        result("Tags set")
    }

    private func getSurveysImpl(_ result: @escaping FlutterResult) {
        BitLabs.shared.getSurveys { response in
            switch response {
            case .failure(let error):
                result(FlutterError(code: "Error", message: "Get Surveys \(error)", details: nil))

            case .success(let surveys):
                if let data = try? JSONEncoder().encode(surveys),
                   let json = try? JSONSerialization.jsonObject(with: data, options: [])
                {
                    result(json)
                }

                result(FlutterError(code: "Error", message: "Couldn't Serialize the surveys", details: nil))
            }
        }
    }

    private func checkSurveysImpl(_ result: @escaping FlutterResult) {
        BitLabs.shared.checkSurveys { response in
            switch response {
            case .failure(let error):
                result(FlutterError(code: "Error", message: "Check Surveys \(error)", details: nil))

            case .success(let surveysExist):
                result(surveysExist)
            }
        }
    }

    private func openOfferImpl(_ call: FlutterMethodCall, _ result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let offerId = arguments["offerId"] as? String,
              let topViewController = UIApplication.shared.keyWindow?.rootViewController
        else {
            result(FlutterError(code: "Error", message: "Invalid arguments", details: nil))
            return
        }

        offerwall?.openOffer(withId: offerId, parent: topViewController)
        result("Offer opened")
    }

    private func openMagicReceiptsOfferImpl(_ call: FlutterMethodCall, _ result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let receiptId = arguments["offerId"] as? String,
              let topViewController = UIApplication.shared.keyWindow?.rootViewController
        else {
            result(FlutterError(code: "Error", message: "Invalid arguments", details: nil))
            return
        }

        offerwall?.openMagicReceiptsOffer(withId: receiptId, parent: topViewController)
        result("Magic Receipts Offer opened")
    }

    private func openMagicReceiptsMerchantImpl(_ call: FlutterMethodCall, _ result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let merchantId = arguments["merchantId"] as? String,
              let topViewController = UIApplication.shared.keyWindow?.rootViewController
        else {
            result(FlutterError(code: "Error", message: "Invalid arguments", details: nil))
            return
        }

        offerwall?.openMagicReceiptsMerchant(withId: merchantId, parent: topViewController)
        result("Magic Receipts Merchant opened")
    }

    private func requestTrackingAuthorizationImpl(_ result: @escaping FlutterResult) {
        offerwall?.requestTrackingAuthorization()
        result(true)
    }
}
