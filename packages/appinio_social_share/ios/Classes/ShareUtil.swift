import Photos
import FBSDKCoreKit
import FBSDKShareKit
import Social
import TikTokOpenSDK
import MobileCoreServices



public class ShareUtil{
    
    public let SUCCESS: String = "SUCCESS"
    public let ERROR_APP_NOT_AVAILABLE: String = "ERROR_APP_NOT_AVAILABLE"
    public let ERROR_FEATURE_NOT_AVAILABLE_FOR_THIS_VERSON: String = "ERROR_FEATURE_NOT_AVAILABLE_FOR_THIS_VERSON"
    public let ERROR: String = "ERROR"
    public let NOT_IMPLEMENTED: String = "NOT_IMPLEMENTED"

    let argAttributionURL: String  = "attributionURL";
    let argImagePath: String  = "imagePath";
    let argImagesPath: String  = "imagesPath";
    let argVideosPath: String  = "videosPath";
    let argbackgroundImage: String  = "backgroundImage";
    let argMessage: String  = "message";
    let argTitle: String  = "title";
    let argstickerImage: String  = "stickerImage";
    let argAppId: String  = "appId";
    let argBackgroundTopColor: String  = "backgroundTopColor";
    let argBackgroundBottomColor: String  = "backgroundBottomColor";
    let argImages: String  = "images";
    let argVideoFile: String  = "videoFile";


    
    public func getInstalledApps(result: @escaping FlutterResult){
        let apps = [["instagram","instagram"],["facebook-stories","facebook_stories"],["whatsapp","whatsapp"],["tg","telegram"],["fb-messenger","messenger"],["tiktok","tiktok"],["instagram-stories","instagram_stories"],["twitter","twitter"],["sms","message"]]
        var output:[String: Bool] = [:]
        for app in apps {
            if(UIApplication.shared.canOpenURL(URL(string:(app[0])+"://")!)){
                if(app[0] == "facebook-stories"){
                    output["facebook"] = true

                }
                output[app[1]] = true
            }else{
                output[app[1]] = false
            }
        }
        result(output)
    }

    public func canOpenUrl(appName:String) -> Bool{
         return UIApplication.shared.canOpenURL(URL(string:appName+"://")!)
    }



    public func shareToInstagramFeed(args : [String: Any?],result: @escaping FlutterResult) {
        let filePath = args[argImagePath] as? String
        if(!isImage(filePath: filePath!)) {
            return shareVideoToInstagramFeed(args: args, result:result)
        } else{
            return shareImageToInstagramFeed(args: args, result:result)
        }
    }

    func isImage(filePath:String)->Bool{
        let ext = NSURL(fileURLWithPath: filePath).pathExtension
        let uti = UTTypeCreatePreferredIdentifierForTag(
            kUTTagClassFilenameExtension,
            ext! as CFString,
            nil)
        if UTTypeConformsTo((uti?.takeRetainedValue())!, kUTTypeImage) {
            return true
        }
        return false
    }


    public func shareToTiktok(args : [String: Any?],result: @escaping FlutterResult){
        let imagesPath = args[argImagesPath] as? [String]
        let videosPath = args[argVideosPath] as? [String]

        let tiktokMaxSharingMedias = 12; //ShareMediaContent docs: https://developers.tiktok.com/doc/video-kit-ios-video-kit-with-swift
        var imagesSize = (imagesPath == nil || imagesPath!.isEmpty) ? 0 : (imagesPath!.count > tiktokMaxSharingMedias ? tiktokMaxSharingMedias : imagesPath!.count)
        var videosSize = (videosPath == nil || videosPath!.isEmpty) ? 0 : (videosPath!.count > tiktokMaxSharingMedias ? tiktokMaxSharingMedias : videosPath!.count)

        let request = TikTokOpenSDKShareRequest()

        request.mediaType = imagesSize > 0 ? TikTokOpenSDKShareMediaType.image : TikTokOpenSDKShareMediaType.video
        request.localIdentifiers = []
        
        if(imagesSize > 0) {
            for i in 0...imagesSize - 1 {
                let imagePath = imagesPath![i]
                let imageURL = URL(fileURLWithPath: imagePath)
                PHPhotoLibrary.shared().performChanges({
                    let assetCreationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageURL)
                    let assetPlaceholder = assetCreationRequest?.placeholderForCreatedAsset
                    let localIdentifier = assetPlaceholder?.localIdentifier ?? "";
                    request.localIdentifiers.append(localIdentifier)

                    if(request.localIdentifiers.count >= imagesSize) {
                        DispatchQueue.main.async {
                            request.send(completionBlock: { response in
                              print("Response from TikTok")
                              print(response.errCode.rawValue)
                              print(response.shareState.rawValue)
                            })
                        }
                        result(self.SUCCESS)
                    }
                }) { (success, error) in
                    if success {
                        print("Asset creation successful!")
                    } else {
                        print("Asset creation failed: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
            return;
        }
        
        if(videosSize > 0) {
            for i in 0...videosSize - 1 {
                let videoPath = videosPath![i]
                let videoURL = URL(fileURLWithPath: videoPath)
                PHPhotoLibrary.shared().performChanges({
                    let assetCreationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                    let assetPlaceholder = assetCreationRequest?.placeholderForCreatedAsset
                    let localIdentifier = assetPlaceholder?.localIdentifier ?? "";
                    request.localIdentifiers.append(localIdentifier)
                    
                    if(request.localIdentifiers.count >= videosSize) {
                        DispatchQueue.main.async {
                            request.send(completionBlock: { response in
                              print("Response from TikTok")
                              print(response.errCode.rawValue)
                              print(response.shareState.rawValue)
                            })
                        }
                        result(self.SUCCESS)
                    }
                }) { (success, error) in
                    if success {
                        print("Asset creation successful!")
                    } else {
                        print("Asset creation failed: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
            return;
        }
    }


    func shareVideoToInstagramFeed(args : [String: Any?],result: @escaping FlutterResult) {
        let videoFile = args[argImagePath] as? String
        let backgroundVideoUrl = URL(fileURLWithPath: videoFile!)
        let videoData = try? Data(contentsOf: backgroundVideoUrl) as NSData

        getLibraryPermissionIfNecessary { granted in

            guard granted else {
                result(self.ERROR)
                return
            }
        }

        PHPhotoLibrary.shared().performChanges({

            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath = "\(documentsPath)/\(Date().description).mp4"

            videoData!.write(toFile: filePath, atomically: true)
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
        },
        completionHandler: { success, error in

            if success {

                let fetchOptions = PHFetchOptions()

                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

                let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)

                if let lastAsset = fetchResult.firstObject {

                    let localIdentifier = lastAsset.localIdentifier
                    let urlFeed = "instagram://library?LocalIdentifier=" + localIdentifier

                    guard
                        let url = URL(string: urlFeed)
                    else {

                        result(self.ERROR_APP_NOT_AVAILABLE)
                        return
                    }
                    DispatchQueue.main.async {

                        if UIApplication.shared.canOpenURL(url) {

                            if #available(iOS 10.0, *) {

                                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                                    result(self.SUCCESS)
                                })
                            }
                            else {

                                UIApplication.shared.openURL(url)
                                result(self.SUCCESS)
                            }
                        }
                        else {

                            result(self.ERROR)
                        }
                    }
                }
            }
            else if let error = error {

                print(error.localizedDescription)
            }
            else {

                result(self.ERROR)
            }
        })
    }

    func shareImageToInstagramFeed(args : [String: Any?],result: @escaping FlutterResult) {
            let videoFile = args[argImagePath] as? String
            let backgroundVideoUrl = URL(fileURLWithPath: videoFile!)
            let videoData = try? Data(contentsOf: backgroundVideoUrl) as NSData

            getLibraryPermissionIfNecessary { granted in

                guard granted else {
                    result(self.ERROR)
                    return
                }
            }


            PHPhotoLibrary.shared().performChanges({

                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath:String
                     filePath = "\(documentsPath)/\(Date().description).jpeg"


                videoData!.write(toFile: filePath, atomically: true)
                    PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: filePath))

            },
            completionHandler: { success, error in

                if success {

                    let fetchOptions = PHFetchOptions()

                    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                    let type:PHAssetMediaType;
                        type = PHAssetMediaType.image


                    let fetchResult = PHAsset.fetchAssets(with: type, options: fetchOptions)

                    if let lastAsset = fetchResult.firstObject {

                        let localIdentifier = lastAsset.localIdentifier
                        let urlFeed = "instagram://library?LocalIdentifier=" + localIdentifier

                        guard
                            let url = URL(string: urlFeed)
                        else {

                            result(self.ERROR_APP_NOT_AVAILABLE)
                            return
                        }
                        DispatchQueue.main.async {

                            if UIApplication.shared.canOpenURL(url) {

                                if #available(iOS 10.0, *) {

                                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                                        result(self.SUCCESS)
                                    })
                                }
                                else {

                                    UIApplication.shared.openURL(url)
                                    result(self.SUCCESS)
                                }
                            }
                            else {

                                result(self.ERROR)
                            }
                        }
                    }
                }
                else if let error = error {

                    print(error.localizedDescription)
                }
                else {

                    result(self.ERROR)
                }
            })
        }

    func getLibraryPermissionIfNecessary(completionHandler: @escaping  (Bool) -> Void) {

        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized)
        }
    }


    public func shareToSystem(args : [String: Any?],result: @escaping FlutterResult) {
                       let text = args[argMessage] as? String
                       let filePath = args[argImagePath] as? String
                       let activityViewController = UIActivityViewController(activityItems: [text!,URL(fileURLWithPath: filePath!)], applicationActivities: nil)
                       UIApplication.topViewController()?.present(activityViewController, animated: true, completion: nil)
                       result(SUCCESS)
    }
    
    
    func copyToClipboard(args : [String: Any?],result: @escaping FlutterResult){
        let message = args[self.argMessage] as? String
        UIPasteboard.general.string = message!
        result(SUCCESS)
    }
    
    
    
    func shareToWhatsApp(args : [String: Any?],result: @escaping FlutterResult)  {
        let message = args[self.argMessage] as? String
        let whatsURL = "whatsapp://send?text="+message!
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        let whatsAppURL  = NSURL(string: whatsURL.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        if UIApplication.shared.canOpenURL(whatsAppURL! as URL)
        {
            UIApplication.shared.openURL(whatsAppURL! as URL)
            result(SUCCESS);
        }
        else
        {
            result(ERROR_APP_NOT_AVAILABLE);
        }
    }

    func showShareFacebookDialog(content: FBSDKShareKit.SharingContent, delegate: SharingDelegate, result: @escaping FlutterResult) {
        do {
            let dialog = ShareDialog(
                viewController: UIApplication.shared.windows.first!.rootViewController,
                content: content,
                delegate: delegate
            )
            try dialog.validate()
            dialog.show()
            result(self.SUCCESS)
        } catch let error {
           result(ERROR)
           print(error.localizedDescription)
        }
    }
    
    func shareToFacebookPost(args : [String: Any?], result: @escaping FlutterResult, delegate: SharingDelegate) {
        let message = args[self.argMessage] as? String
        let imagesPath = args[self.argImagesPath] as? [String]
        let videosPath = args[self.argVideosPath] as? [String]
        let videoPath = videosPath != nil && !videosPath!.isEmpty ? videosPath![0] : nil;
        
        var imagesSize = (imagesPath == nil || imagesPath!.isEmpty) ? 0 : imagesPath!.count
        let videosSize = (videosPath == nil || videosPath!.isEmpty) ? 0 : 1
        let facebookMaxSharingMedias = 20; //ShareMediaContent docs: https://developers.facebook.com/docs/sharing/android

        if(imagesSize + videosSize > facebookMaxSharingMedias) {
            imagesSize = imagesSize - (imagesSize + videosSize - facebookMaxSharingMedias);
        }
        
        let content = ShareMediaContent()
        if(message != nil) {
            content.hashtag = Hashtag(message!)
        }

        if(imagesSize > 0) {
            for i in 0...imagesSize - 1 {
                let imagePath = imagesPath![i]
                let photo = SharePhoto(image: UIImage.init(contentsOfFile: imagePath)!, isUserGenerated: true)
                content.media.append(photo)
            }
            if(videosSize == 0) {
                showShareFacebookDialog(content: content, delegate: delegate, result: result)
                return
            }
        }

        if(videoPath != nil) {
            let videoURL = URL(fileURLWithPath: videoPath!)
            var videoAssetUrl: URL?

            PHPhotoLibrary.shared().performChanges({
                let assetCreationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                let assetPlaceholder = assetCreationRequest?.placeholderForCreatedAsset
                 let localIdentifier = assetPlaceholder?.localIdentifier ?? "";
                let localIdentifierPrefix = String(localIdentifier.prefix(36))

                videoAssetUrl = URL(string: "assets-library://asset/asset.mp4?id="+localIdentifierPrefix+"&ext=mp4")

                DispatchQueue.main.async {
                    let video = ShareVideo(videoURL: videoAssetUrl!);
                    content.media.append(video)
                    self.showShareFacebookDialog(content: content, delegate: delegate, result: result)

                    // Deleting video asks user for confirmation so it doesn't make sense.
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
//                            PHPhotoLibrary.shared().performChanges({
//                                PHAssetChangeRequest.deleteAssets(assets)
//                            })
//                        }
                }
            }) { (success, error) in
                if success {
                    print("Asset creation successful!")
                } else {
                    print("Asset creation failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
        
    
    func shareToTelegram(args : [String: Any?],result: @escaping FlutterResult) {
        let message = args[self.argMessage] as? String
        
        guard let telegramURL = URL(string: "https://telegram.me") else {
            result(ERROR_APP_NOT_AVAILABLE)
            return
        }
        
        guard let mess = message else {
            result(ERROR)
            return
        }
        
        if (UIApplication.shared.canOpenURL(telegramURL)) {
            let urlString = "tg://msg?text=\(mess)"
            let tgUrl = URL.init(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            
            if UIApplication.shared.canOpenURL(tgUrl!) {
                UIApplication.shared.openURL(tgUrl!)
                result(SUCCESS)
            } else {
                result(ERROR_APP_NOT_AVAILABLE)
            }
        } else {
            result(ERROR_APP_NOT_AVAILABLE)
        }
    }
    


    public func shareToInstagramDirect(args : [String: Any?],result: @escaping FlutterResult){
        if #available(iOS 10, *){
            let message = args[self.argMessage] as? String
            let urlString = "instagram://sharesheet?text=\(message!)"
            if(!canOpenUrl(appName: "instagram")){
                result(ERROR_APP_NOT_AVAILABLE)
                return
            }
            if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                result(SUCCESS)
            }else{
                result(ERROR)
            }
        }else{
            result(ERROR_FEATURE_NOT_AVAILABLE_FOR_THIS_VERSON)
        }
    }
    
    
    
    
    public func shareToMessenger(args : [String: Any?],result: @escaping FlutterResult){
        if #available(iOS 10, *){
            let message = args[self.argMessage] as? String
            let urlString = "fb-messenger://share/?link=\(message!)"
            if(!canOpenUrl(appName: "fb-messenger")){
                result(ERROR_APP_NOT_AVAILABLE)
                return
            }
            if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                result(SUCCESS)
            }else{
                result(ERROR)
            }
        }else{
            result(ERROR_FEATURE_NOT_AVAILABLE_FOR_THIS_VERSON)
        }
    }
    
    public func shareToSms(args : [String: Any?],result: @escaping FlutterResult){
        let message = args[self.argMessage] as? String
        if #available(iOS 10, *){
            let urlString = "sms:?&body=\(message!)"
            if(!canOpenUrl(appName: "sms")){
                result(ERROR_APP_NOT_AVAILABLE)
                return
            }
            let tgUrl = URL.init(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            UIApplication.shared.open(tgUrl!, options: [:], completionHandler: nil)
        }
        result(SUCCESS)
    }
    
    public func shareToFacebookStory(args : [String: Any?],result: @escaping FlutterResult) {
        let appId = args[self.argAppId] as? String
        let imagePath = args[self.argbackgroundImage] as? String
        let argVideoFile = args[self.argVideoFile] as? String
        let imagePathSticker = args[self.argstickerImage] as? String
        let backgroundTopColor = [args[self.argBackgroundTopColor] as? String] as? [String?]
        let backgroundBottomColor =  [args[self.argBackgroundBottomColor] as? String] as? [String?]
        let attributionURL =  args[self.argAttributionURL] as? String

    
        guard let facebookURL = URL(string: "facebook-stories://share") else {
            result(ERROR_APP_NOT_AVAILABLE)
            return
        }
        
        
        if (UIApplication.shared.canOpenURL(facebookURL)) {
            var backgroundImage: UIImage?;
            if(!(imagePath==nil)){
                backgroundImage =  UIImage.init(contentsOfFile: imagePath!)
            }
            var stickerImage: UIImage?;
            if(!(imagePathSticker==nil)){
                stickerImage =  UIImage.init(contentsOfFile: imagePathSticker!)
            }
            var backgroundVideoData:Any?;
            if(!(argVideoFile==nil)){
                let backgroundVideoUrl = URL(fileURLWithPath: argVideoFile!)
                backgroundVideoData = try? Data(contentsOf: backgroundVideoUrl)
            }

                let pasteboardItems = [
                    [
                        "com.facebook.sharedSticker.attributionURL": [attributionURL ?? ""],
                        "com.facebook.sharedSticker.stickerImage": stickerImage ?? "",
                        "com.facebook.sharedSticker.backgroundVideo": backgroundVideoData ?? "",
                        "com.facebook.sharedSticker.backgroundImage": backgroundImage ?? "",
                        "com.facebook.sharedSticker.backgroundTopColor": backgroundTopColor ?? [String](),
                        "com.facebook.sharedSticker.backgroundBottomColor": (backgroundBottomColor ?? [String]()) as Any,
                        "com.facebook.sharedSticker.appID": appId as Any,
                    ]
                ]
                if #available(iOS 10, *){
                    let pasteboardOptions = [
                        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
                    ]
                    UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
                    UIApplication.shared.open(facebookURL, options: [:])
                }
                result(self.SUCCESS)
                return
        } else {
            result(ERROR_APP_NOT_AVAILABLE)
        }
    }
    
    
    func shareToTwitter(args : [String: Any?],result: @escaping FlutterResult) {
        let title = args[self.argMessage] as? String
        let image = args[self.argImagePath] as? String
        if(!canOpenUrl(appName: "twitter")){
            result(ERROR_APP_NOT_AVAILABLE)
            return
        }
        
        
        let composeCtl = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        composeCtl?.add(URL(string: title!))
        if(!(image==nil)){
            composeCtl?.add(UIImage.init(contentsOfFile: image!))
        }
        composeCtl?.setInitialText(title!)
        UIApplication.topViewController()?.present(composeCtl!,animated:true,completion:nil);
        result(SUCCESS)
    }
    
    
    func shareToInstagramStory(args : [String: Any?],result: @escaping FlutterResult) {
        if #available(iOS 10.0, *){
            let imagePath = args[self.argbackgroundImage] as? String
            let argVideoFile = args[self.argVideoFile] as? String
            let imagePathSticker = args[self.argstickerImage] as? String
            let backgroundTopColor = args[self.argBackgroundTopColor] as? String
            let backgroundBottomColor =  args[self.argBackgroundBottomColor] as? String
            let attributionURL =  args[self.argAttributionURL] as? String

            
            guard let instagramURL = URL(string: "instagram-stories://share") else {
                result(ERROR_APP_NOT_AVAILABLE)
                return
            }
            
     
            if (UIApplication.shared.canOpenURL(instagramURL)) {
                var backgroundImage: UIImage?;
                if(!(imagePath==nil)){
                    backgroundImage =  UIImage.init(contentsOfFile: imagePath!)
                }
                var stickerImage: UIImage?;
                if(!(imagePathSticker==nil)){
                    stickerImage =  UIImage.init(contentsOfFile: imagePathSticker!)
                }
                var backgroundVideoData:Any?;
                if(!(argVideoFile==nil)){
                    let backgroundVideoUrl = URL(fileURLWithPath: argVideoFile!)
                    backgroundVideoData = try? Data(contentsOf: backgroundVideoUrl)
                }
                let pasteboardItems = [
                    [
                        "com.instagram.sharedSticker.attributionURL": attributionURL ?? "",
                        "com.instagram.sharedSticker.stickerImage": stickerImage ?? "",
                        "com.instagram.sharedSticker.backgroundVideo": backgroundVideoData ?? "",
                        "com.instagram.sharedSticker.backgroundImage": backgroundImage ?? "",
                        "com.instagram.sharedSticker.backgroundTopColor": backgroundTopColor ?? "",
                        "com.instagram.sharedSticker.backgroundBottomColor": backgroundBottomColor ?? "",
                    ]
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)
                ]
                UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
                UIApplication.shared.open(instagramURL, options: [:])
                result(self.SUCCESS)
            } else {
                result(ERROR_APP_NOT_AVAILABLE)
            }
        }else{
            result(ERROR_FEATURE_NOT_AVAILABLE_FOR_THIS_VERSON)
        }
        
    }
    
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

class TransparentViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
}
