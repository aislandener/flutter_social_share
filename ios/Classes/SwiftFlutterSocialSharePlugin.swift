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
            
            let backgroundAssetUri = args["backgroundAssetUri"] as? String
            let stickerAssetUri = args["stickerAssetUri"] as? String
            let topColor = args["topColor"] as? String
            let bottomColor = args["bottomColor"] as? String
            
            print("backgroundAssetUri: \(String(describing: backgroundAssetUri))")
            print("stickerAssetUri: \(String(describing: stickerAssetUri))")
            print("topColor: \(String(describing: topColor))")
            print("bottomColor: \(String(describing: bottomColor))")
            
            if(backgroundAssetUri == nil && stickerAssetUri == nil){
                resultDicticonary = "Message From Switf: backgroundAssetUri or stickerAssetUri as nil"
                result(resultDicticonary)
                return
            }
            
            let imageExtensions = ["png", "jpg"]
            var pasterboardItems:[[String:Any]] = [[String:Any]]()
            let instagramUrl = URL(string: "instagram-stories://share")
            
            if(backgroundAssetUri != nil){
                let documentExists = FileManager.default.fileExists(atPath: backgroundAssetUri!)
                print("documentExists \(documentExists)")
                if(documentExists){
                    do{
                        let url:URL? = NSURL(fileURLWithPath: backgroundAssetUri!) as URL
                        let pathExtension = url?.pathExtension
                        let background = try NSData(contentsOfFile: url!.path, options: .mappedIfSafe)
                        if(imageExtensions.contains(pathExtension!)){
                            pasterboardItems.append(contentsOf: [["com.instagram.sharedSticker.backgroundImage": background as Any]])
                            
                        }else{
                            pasterboardItems.append(contentsOf:[["com.instagram.sharedSticker.backgroundVideo": background as Any]])
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
            
            if(stickerAssetUri != nil){
                let documentExists = FileManager.default.fileExists(atPath: stickerAssetUri!)
                print("documentExists \(documentExists)")
                if(documentExists){
                    do{
                        let url:URL? = NSURL(fileURLWithPath: stickerAssetUri!) as URL
                        let pathExtension = url?.pathExtension
                        let sticker = try NSData(contentsOfFile: url!.path, options: .mappedIfSafe)
                        if(imageExtensions.contains(pathExtension!)){
                            pasterboardItems.append(contentsOf:[["com.instagram.sharedSticker.stickerImage": sticker as Any]])
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
            
            if(topColor != nil){
                pasterboardItems.append(contentsOf:[["com.instagram.sharedSticker.backgroundTopColor": topColor!]])
            }
            
            if(bottomColor != nil){
                pasterboardItems.append(contentsOf:[["com.instagram.sharedSticker.backgroundBottomColor": bottomColor!]])
            }
            
            print(String(describing: pasterboardItems))
            
            UIPasteboard.general.setItems(pasterboardItems)
            UIApplication.shared.open(instagramUrl!)
            
            result(resultDicticonary)
        default:
            result(FlutterError.init(code: "BAD_ARGS", message:"Not Implement", details: nil))
        }
        //result("iOS " + UIDevice.current.systemVersion)
    }
}
