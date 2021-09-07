import Flutter
import UIKit

public class SwiftFlutterSocialSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_social_share", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSocialSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "shareToStoryInstagram":

      var resultDicticonary: String = ""
      resultDicticonary = "Message From Switf: __"

      guard let args = call.arguments as? Dictionary<String,Any> else {
        print("Unexpected error ARGS HAVE A PROBLEM.")
        resultDicticonary = "Message From Switf: error ARGS HAVE A PROBLEM"
        result(resultDicticonary)
        return
      }

      if(args["backgroundAssetUri"] == nil && args["stickerAssetUri"] == nil){
        resultDicticonary = "Message From Switf: backgroundAssetUri or stickerAssetUri as nil"
        result(resultDicticonary)
        return
      }
      let imageExtensions = ["png", "jpg"]
      var pasterboardItems:[[String:Any]] = [[String:Any]]()
      let instagramUrl = URL(string: "instagram-stories://share")
      if(args["backgroundAssetUri"] != nil){
        let backgroundPath = args["backgroundAssetUri"] as? String
        let documentExists = FileManager.default.fileExists(atPath: backgroundPath!)
        print("documentExists \(documentExists)")
        if(documentExists){
          do{
            let url:URL? = NSURL(fileURLWithPath: backgroundPath!) as URL
            let pathExtension = url?.pathExtension
            let background = try NSData(contentsOfFile: url!.path, options: .mappedIfSafe)
            if(imageExtensions.contains(pathExtension!)){
              UIPasteboard.general.addItems([["com.instagram.sharedSticker.backgroundImage": background as Any]])
            }else{
              UIPasteboard.general.addItems([["com.instagram.sharedSticker.backgroundVideo": background as Any]])
            }
          }catch{
            print("Unexpected error converting to NSDATA:\(error).")
            resultDicticonary = "Message From Switf: error converting to NSDATA"
          }
        }else{
          print("Unexpected error DOCUMENT DOES NOT EXIST.")
          resultDicticonary = "Message From Switf: error DOCUMENT DOES NOT EXIST."
        }
      }

      if(args["stickerAssetUri"] != nil){
        let stickerPath = args["stickerAssetUri"] as? String
        let documentExists = FileManager.default.fileExists(atPath: stickerPath!)
        print("documentExists \(documentExists)")
        if(documentExists){
          do{
            let url:URL? = NSURL(fileURLWithPath: stickerPath!) as URL
            let pathExtension = url?.pathExtension
            let sticker = try NSData(contentsOfFile: url!.path, options: .mappedIfSafe)
            if(imageExtensions.contains(pathExtension!)){
              UIPasteboard.general.addItems([["com.instagram.sharedSticker.stickerImage": sticker as Any]])
            }
          }catch{
            print("Unexpected error converting to NSDATA:\(error).")
            resultDicticonary = "Message From Switf: error converting to NSDATA"
          }
        }else{
          print("Unexpected error DOCUMENT DOES NOT EXIST.")
          resultDicticonary = "Message From Switf: error DOCUMENT DOES NOT EXIST."
        }
      }

      //print(String(describing: pasterboardItems))


      //UIPasteboard.general.setItems(pasterboardItems)
      UIApplication.shared.open(instagramUrl!)



      print("backgroundAssetUri: " + String(describing: args["backgroundAssetUri"]))
      print("stickerAssetUri: " + String(describing: args["stickerAssetUri"]))
      print("topColor: " + String(describing: args["topColor"]))
      print("bottomColor: " + String(describing: args["bottomColor"]))

      result(resultDicticonary)
    default:
      result(FlutterError.init(code: "BAD_ARGS", message:"Not Implement", details: nil))
    }
    //result("iOS " + UIDevice.current.systemVersion)
  }
}
