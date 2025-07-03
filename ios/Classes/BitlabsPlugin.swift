import BLCustom
import Flutter
import UIKit

public class BitlabsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "bitlabs", binaryMessenger: registrar.messenger())
        let instance = BitlabsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        BitLabs.shared.setRewardCompletionHandler { reward in
            channel.invokeMethod("onReward", arguments: ["reward": reward])
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init": initImpl(call, result)
        case "addTag": addTagImpl(call, result)
        case "setTags": setTagsImpl(call, result)
        case "launchOfferWall": launchOfferWallImpl(result)
        case "getSurveys": getSurveysImpl(result)
        case "checkSurveys": checkSurveysImpl(result)
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
        // Assuming 'initialize' is the correct method for BitLabs Initialization
        BitLabs.shared.configure(token: token, uid: uid)
        result("BitLabs initialized")
    }
    
    private func launchOfferWallImpl(_ result: FlutterResult) {
        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController else {
            result(
                FlutterError(
                    code: "Error", message: "Unable to access UIApplication's window", details: nil)
            )
            return
        }
        // Ensure the BitLabs offer wall launch method is correctly used
        BitLabs.shared.launchOfferWall(parent: topViewController)
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
        
        BitLabs.shared.addTag(key: key, value: value)
    }
    
    private func setTagsImpl(_ call: FlutterMethodCall, _ result: FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let tags = arguments["tags"] as? [String: Any]
        else {
            result(FlutterError(code: "Error", message: "Invalid tags argument", details: nil))
            return
        }
        // Assign tags to BitLabs
        BitLabs.shared.setTags(tags)
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
    
    private func requestTrackingAuthorizationImpl(_ result: @escaping FlutterResult) {
        BitLabs.shared.requestTrackingAuthorization()
        result(true)
    }
}
