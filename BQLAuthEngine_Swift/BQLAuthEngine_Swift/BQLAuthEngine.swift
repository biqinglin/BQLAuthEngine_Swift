//
//  BQLAuthEngine.swift
//  BQLAuthEngine_Swift
//
//  Created by biqinglin on 2017/3/16.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

import UIKit
/*
 ***************************************************************
            说明和OC版一样，其中方法大同小异，请移步OC版查看~~~
            注意下：需要在didFinishLaunchingWithOptions return之前注册方法：BQLAuthEngine.single.registerApp()
 ***************************************************************
*/
public let QQ_APPID : String = ""
public let QQ_APPKEY : String = ""

public let WECHAT_APPID : String = ""
public let WECHAT_APPSECRET : String = ""

public let SINA_APPKEY : String = ""
public let SINA_APPSECRET : String = ""
public let SINA_REDIRECTURI : String = ""
public let SINA_OBJECTID : String = ""

enum AuthErrorCode: String {
    case common            = "通用错误"
    case authDeny          = "授权失败"
    case userCancel        = "用户取消"
    case sendFail          = "发送失败"
    case unKnow            = "未知错误"
    case noNetWork         = "没有网络"
    case parameterEmpty    = "参数缺失"
    case noWeiBoApp        = "没有微博客户端"
}

enum QQShareScene : NSInteger {
    case session = 0        /**<分享至好友>*/
    case zone               /**<分享至空间>*/
}

enum WechatShareScene : Int {
    case session = 0    /**<分享至会话>*/
    case timeline       /**<分享至朋友圈>*/
    case favorite       /**<分享至收藏>*/
}

final class BQLAuthEngine: NSObject ,WBHttpRequestDelegate,TencentSessionDelegate,WXApiDelegate,WeiboSDKDelegate{

    // 定义闭包
    typealias BQLAuthSuccessBlock = (_ response : Any?) -> Void
    typealias BQLAuthFailureBlock = (_ error : String?) -> Void
    // 单例
    static let single = BQLAuthEngine()
    // 私有化init
    private override init() { }
    
    func registerApp() {
        
        tencentOAuth = TencentOAuth.init(appId: QQ_APPID, andDelegate: BQLAuthEngine.single)
        // 注册
        WXApi.registerApp(WECHAT_APPID)
        #if DEBUG
            WeiboSDK.enableDebugMode(true)
        #else
            WeiboSDK.enableDebugMode(false)
        #endif
        WeiboSDK.registerApp(SINA_APPKEY)
        WXApi.registerApp(WECHAT_APPID)
        #if DEBUG
            WeiboSDK.enableDebugMode(true)
        #else
            WeiboSDK.enableDebugMode(false)
        #endif
        WeiboSDK.registerApp(SINA_APPKEY)
    }
    // 定义闭包属性以及其他属性
    private var successBlock : BQLAuthSuccessBlock?
    private var failureBlock : BQLAuthFailureBlock?
    private var tencentOAuth : TencentOAuth?
    
    var qq_open_id : String {
        get {
            let rqq_open_id = readDataFromLocal(key: "qq_open_id")
            return rqq_open_id == nil ? "" : rqq_open_id as! String
        }
        set {
            saveDataToLocal(key: "qq_open_id", value: newValue)
        }
    }
    
    var qq_token : String {
        get {
            let rqq_token = readDataFromLocal(key: "qq_token")
            return rqq_token == nil ? "" : rqq_token as! String
        }
        set {
            saveDataToLocal(key: "qq_token", value: newValue)
        }
    }
    
    var wechat_open_id : String {
        get {
            let rwechat_open_id = readDataFromLocal(key: "wechat_open_id")
            return rwechat_open_id == nil ? "" : rwechat_open_id as! String
        }
        set {
            saveDataToLocal(key: "wechat_open_id", value: newValue)
        }
    }
    
    var wechat_token : String {
        get {
            let rwechat_token = readDataFromLocal(key: "wechat_token")
            return rwechat_token == nil ? "" : rwechat_token as! String
        }
        set {
            saveDataToLocal(key: "wechat_token", value: newValue)
        }
    }
    
    var weibo_open_id : String {
        get {
            let rweibo_open_id = readDataFromLocal(key: "weibo_open_id")
            return rweibo_open_id == nil ? "" : rweibo_open_id as! String
        }
        set {
            saveDataToLocal(key: "weibo_open_id", value: newValue)
        }
    }
    
    var weibo_token : String {
        get {
            let rweibo_token = readDataFromLocal(key: "weibo_token")
            return rweibo_token == nil ? "" : rweibo_token as! String
        }
        set {
            saveDataToLocal(key: "weibo_token", value: newValue)
        }
    }
    
    var weibo_expirationDate : NSDate {
        get {
            let rweibo_expirationDate = readDataFromLocal(key: "weibo_expirationDate")
            return rweibo_expirationDate == nil ? NSDate.init() : rweibo_expirationDate as! NSDate
        }
        set {
            saveDataToLocal(key: "weibo_expirationDate", value: newValue)
        }
    }
    
    // 方法
    func isWXAppInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
    
    func isQQInstalled() -> Bool {
        return QQApiInterface.isQQInstalled()
    }
    
    func isWeiboAppInstalled() -> Bool {
        return WeiboSDK.isWeiboAppInstalled()
    }
    
    func isCanShareInWeiboAPP() -> Bool {
        return WeiboSDK.isCanShareInWeiboAPP()
    }
    
    func auth_qq_login(success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success
        self.failureBlock = failure
        tencentOAuth!.authorize(["get_user_info", "get_simple_userinfo", "add_t"])
    }
    
    func auth_qq_share_text(model : BQLShareModel, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success
        self.failureBlock = failure
        if checkObjectNotNull(object: model.text) {
            let textObject = QQApiTextObject.object(withText: model.text as! String)
            let req = SendMessageToQQReq.init(content: textObject as! QQApiObject)
            handleSendResult(code: QQApiInterface.send(req))
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享文本缺失，请填写model.text")
                return
            }
        }
    }
    
    func auth_qq_share_image(model : BQLShareModel, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success
        self.failureBlock = failure
        if checkObjectNotNull(object: model.image) {
            let preData = checkObjectNotNull(object: model.previewImage) ? UIImagePNGRepresentation(model.previewImage!) : UIImagePNGRepresentation(model.image!)
            let imageObject = QQApiImageObject.object(with: UIImagePNGRepresentation(model.image!), previewImageData: preData, title: model.title as! String, description: model.describe as! String)
            let req = SendMessageToQQReq.init(content: imageObject as! QQApiObject)
            handleSendResult(code: QQApiInterface.send(req))
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享图片缺失，请填写model.image")
                return
            }
        }
    }
    
    func auth_qq_share_link(model : BQLShareModel, scene : QQShareScene, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success
        self.failureBlock = failure
        if checkObjectNotNull(object: model.urlString) {
            var newsObject : QQApiNewsObject
            if checkObjectNotNull(object: model.previewUrlString) {
                newsObject = QQApiNewsObject.object(with: URL.init(string: model.urlString as! String), title: model.title as! String, description: model.describe as! String, previewImageURL: URL.init(string: model.previewUrlString as! String)) as! QQApiNewsObject
            }
            else {
                if checkObjectNotNull(object: model.previewImage) {
                    newsObject = QQApiNewsObject.object(with: URL.init(string: model.urlString as! String), title: model.title as! String, description: model.describe as! String, previewImageData: UIImagePNGRepresentation(model.previewImage!)) as! QQApiNewsObject
                }
                else {
                    newsObject = QQApiNewsObject.object(with: URL.init(string: model.urlString as! String), title: model.title as! String, description: model.describe as! String, previewImageURL: nil) as! QQApiNewsObject
                }
            }
            let req = SendMessageToQQReq.init(content: newsObject)
            var sent : QQApiSendResultCode
            if(scene == .session) {
                sent = QQApiInterface.send(req)
            }
            else {
                sent = QQApiInterface.sendReq(toQZone: req)
            }
            handleSendResult(code: sent)
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享链接地址缺失,请填写model.urlString")
                return
            }
        }
    }
    
    func handleSendResult(code : QQApiSendResultCode) -> Void {
        
        // 具体错误在这里打断点查看code对应的错误码
        if code == EQQAPISENDSUCESS {
            guard self.successBlock == nil else {
                self.successBlock!(code as Any?)
                return
            }
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.common.rawValue)
                return
            }
        }
    }
    
    func tencentDidLogin() {
        
        if tencentOAuth!.accessToken != nil && 0 != tencentOAuth!.accessToken.characters.count {
            qq_token = (tencentOAuth!.accessToken!)
            qq_open_id = (tencentOAuth!.openId)!
            if !(tencentOAuth!.getUserInfo()) {
                guard self.failureBlock == nil else {
                    self.failureBlock!(AuthErrorCode.common.rawValue)
                    return
                }
            }
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.authDeny.rawValue)
                return
            }
        }
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
        guard self.failureBlock == nil else {
            cancelled ? self.failureBlock!(AuthErrorCode.userCancel.rawValue) : self.failureBlock!(AuthErrorCode.authDeny.rawValue)
            return
        }
    }
    
    func tencentDidNotNetWork() {
        
        guard self.failureBlock == nil else {
            self.failureBlock!(AuthErrorCode.noNetWork.rawValue)
            return
        }
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        
        guard self.successBlock == nil else {
            self.successBlock!(response.jsonResponse)
            return
        }
    }
    
    func auth_wechat_login(success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success;
        self.failureBlock = failure;
        let req = SendAuthReq.init()
        req.scope = "snsapi_userinfo"
        req.state = "dsfjdfwfhwjfhwihfiuewhfwefhweiu"
        WXApi.send(req)
    }
    
    func auth_wechat_share_text(model : BQLShareModel, scene : WechatShareScene, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success;
        self.failureBlock = failure;
        if checkObjectNotNull(object: model.text) {
            let req = SendMessageToWXReq.init()
            req.text = model.text as! String
            req.bText = true
            req.scene = Int32(scene.rawValue)
            WXApi.send(req)
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享文本缺失,请填写model.text")
                return
            }
        }
    }
    
    func auth_wechat_share_image(model : BQLShareModel, scene : WechatShareScene, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success;
        self.failureBlock = failure;
        if checkObjectNotNull(object: model.image) {
            let message = WXMediaMessage.init()
            if model.previewImage != nil {
                message.setThumbImage(model.previewImage)
            }
            let imageObject = WXImageObject.init()
            imageObject.imageData = UIImagePNGRepresentation(model.image!)
            message.mediaObject = imageObject
            let req = SendMessageToWXReq.init()
            req.message = message
            req.bText = false
            req.scene = Int32(scene.rawValue)
            WXApi.send(req)
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享图片缺失,请填写model.image")
                return
            }
        }
    }
    
    func auth_wechat_share_link(model : BQLShareModel, scene : WechatShareScene, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success;
        self.failureBlock = failure;
        if checkObjectNotNull(object: model.urlString) {
            let message = WXMediaMessage.init()
            if model.title != nil {
                message.title = model.title as! String
            }
            if model.describe != nil {
                message.description = model.describe as! String
            }
            if model.previewImage != nil {
                message.setThumbImage(model.previewImage)
            }
            let linkObject = WXWebpageObject.init()
            linkObject.webpageUrl = model.urlString as! String
            message.mediaObject = linkObject
            let req = SendMessageToWXReq.init()
            req.message = message
            req.bText = false
            req.scene = Int32(scene.rawValue)
            WXApi.send(req)
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享链接缺失,请填写model.urlString")
                return
            }
        }
    }
    
    func auth_wechat_share_music(model : BQLShareModel, scene : WechatShareScene, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success;
        self.failureBlock = failure;
        if checkObjectNotNull(object: model.urlString) {
            let message = WXMediaMessage.init()
            if model.title != nil {
                message.title = model.title as! String
            }
            if model.describe != nil {
                message.description = model.describe as! String
            }
            if model.previewImage != nil {
                message.setThumbImage(model.previewImage)
            }
            let musicObject = WXMusicObject.init()
            musicObject.musicUrl = model.urlString as! String
            message.mediaObject = musicObject
            let req = SendMessageToWXReq.init()
            req.message = message
            req.bText = false
            req.scene = Int32(scene.rawValue)
            WXApi.send(req)
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享链接缺失,请填写model.urlString")
                return
            }
        }
    }
    
    func auth_wechat_share_video(model : BQLShareModel, scene : WechatShareScene, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success;
        self.failureBlock = failure;
        if checkObjectNotNull(object: model.urlString) {
            let message = WXMediaMessage.init()
            if model.title != nil {
                message.title = model.title as! String
            }
            if model.describe != nil {
                message.description = model.describe as! String
            }
            if model.previewImage != nil {
                message.setThumbImage(model.previewImage)
            }
            let videoObject = WXVideoObject.init()
            videoObject.videoUrl = model.urlString as! String
            message.mediaObject = videoObject
            let req = SendMessageToWXReq.init()
            req.message = message
            req.bText = false
            req.scene = Int32(scene.rawValue)
            WXApi.send(req)
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享链接缺失,请填写model.urlString")
                return
            }
        }
    }
    
    func onResp(_ resp: BaseResp!) {
        
        if resp is SendAuthResp {
            completeAuth(resp: resp as! SendAuthResp)
        }
        else if resp is SendMessageToWXResp {
            completeShare(resp: resp as! SendMessageToWXResp)
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.common.rawValue)
                return
            }
        }
    }
    
    private func completeAuth(resp : SendAuthResp) {
        
        let code = resp.code as String
        let tokenUrl : URL = URL.init(string: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + WECHAT_APPID + "&secret=" + WECHAT_APPSECRET + "&code=" + code + "&grant_type=authorization_code")!
        let session = URLSession.init(configuration: URLSessionConfiguration.ephemeral)
        let task = session.dataTask(with: tokenUrl, completionHandler: {(data, response, error) in
    
            if error == nil {
                
                let tokenHttpResp = response as! HTTPURLResponse
                if tokenHttpResp.statusCode == 200 {
                    do {
                        let tokenJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        let token : String = tokenJson["access_token"] as! String
                        let openid : String = tokenJson["openid"] as! String
                        self.wechat_token = token
                        self.wechat_open_id = openid
                        let infoUrl : URL = URL.init(string: "https://api.weixin.qq.com/sns/userinfo?access_token=" + token + "&openid=" + openid)!
                        let infoTask = session.dataTask(with: infoUrl, completionHandler: {(data, response, error) in
                            
                            do {
                                let infoJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                                if self.successBlock != nil {
                                    self.successBlock!(infoJson)
                                }
                            }
                            catch {
                                guard self.failureBlock == nil else {
                                    self.failureBlock!(error.localizedDescription)
                                    return
                                }
                            }
                        })
                        infoTask.resume()
                    }
                    catch {
                        guard self.failureBlock == nil else {
                            self.failureBlock!(error.localizedDescription)
                            return
                        }
                    }
                }
                else {
                    guard self.failureBlock == nil else {
                        self.failureBlock!(error!.localizedDescription)
                        return
                    }
                }
            }
            else {
                guard self.failureBlock == nil else {
                    self.failureBlock!(error!.localizedDescription)
                    return
                }
            }
        })
        task.resume()
    }
    
    private func completeShare(resp : SendMessageToWXResp) {
        if resp.errCode == 0 {
            guard self.successBlock == nil else {
                self.successBlock!(resp.errCode as Any)
                return
            }
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.common.rawValue)
                return
            }
        }
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        
        if response is WBAuthorizeResponse {
            let authorizeResponse = response as! WBAuthorizeResponse
            let open_id = authorizeResponse.userID as String
            let token = authorizeResponse.accessToken as String
            let expir = authorizeResponse.expirationDate as NSDate
            weibo_open_id = open_id
            weibo_token = token
            weibo_expirationDate = expir
            let uid = response.userInfo["uid"] as! String
            _ = WBHttpRequest.init(url: "https://api.weibo.com/2/users/show.json", httpMethod: "GET", params: ["access_token":token,"uid":uid], delegate: BQLAuthEngine.single, withTag: "0318")
        }
        if response is WBSendMessageToWeiboResponse {
            
            if response.statusCode == WeiboSDKResponseStatusCode.success {
                guard self.successBlock == nil else {
                    self.successBlock!("微博分享成功~")
                    return
                }
            }
            else {
                guard self.failureBlock == nil else {
                    self.failureBlock!("请参考头文件中的微博错误码" + "\(response.statusCode)")
                    return
                }
            }
        }
    }
    
    func request(_ request: WBHttpRequest!, didFinishLoadingWithResult result: String!) {
        
        let data = result.data(using: .utf8)
        do {
            let userInfo = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            guard self.successBlock == nil else {
                self.successBlock!(userInfo)
                return
            }
        }
        catch {
            guard self.failureBlock == nil else {
                self.failureBlock!("未得到微博回应")
                return
            }
        }
    }
    
    func auth_sina_login(success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success
        self.failureBlock = failure
        let request = WBAuthorizeRequest.init()
        request.redirectURI = SINA_REDIRECTURI
        request.scope = "all"
        WeiboSDK.send(request)
    }
    
    func auth_sina_share_text(model : BQLShareModel, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success
        self.failureBlock = failure
        if isCanShareInWeiboAPP() {
            if checkObjectNotNull(object: model.text) {
                let message = WBMessageObject.init()
                message.text = model.text as! String
                let req = WBSendMessageToWeiboRequest.init()
                req.message = message
                WeiboSDK.send(req)
            }
            else {
                guard self.failureBlock == nil else {
                    self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享文本缺失,请填写model.text")
                    return
                }
            }
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.noWeiBoApp.rawValue)
                return
            }
        }
    }
    
    func auth_sina_share_link(model : BQLShareModel, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success
        self.failureBlock = failure
        if isCanShareInWeiboAPP() {
            if checkObjectNotNull(object: model.urlString) {
                let authRequest = WBAuthorizeRequest.init()
                authRequest.redirectURI = "https://api.weibo.com/oauth2/default.html"
                authRequest.scope = "all"
                let message = WBMessageObject.init()
                if checkObjectNotNull(object: model.text) {
                    message.text = (model.text as! String) + (model.urlString as! String)
                }
                else {
                    message.text = model.urlString as! String
                }
                if checkObjectNotNull(object: model.image) {
                    let imageObject = WBImageObject.init()
                    imageObject.imageData = UIImagePNGRepresentation(model.image!)
                    message.imageObject = imageObject
                }
                let request = WBSendMessageToWeiboRequest.request(withMessage: message, authInfo: authRequest, access_token: nil) as! WBSendMessageToWeiboRequest
                WeiboSDK.send(request)
            }
            else {
                guard self.failureBlock == nil else {
                    self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享链接缺失,请填写model.urlString")
                    return
                }
            }
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.noWeiBoApp.rawValue)
                return
            }
        }
    }
    
    func auth_sina_share_image(model : BQLShareModel, success : @escaping BQLAuthSuccessBlock, failure : @escaping BQLAuthFailureBlock) -> Void {
        
        self.successBlock = success
        self.failureBlock = failure
        if isCanShareInWeiboAPP() {
            if checkObjectNotNull(object: model.image) {
                let message = WBMessageObject.init()
                if checkObjectNotNull(object: model.text) {
                    message.text = model.text as! String
                }
                let imageObject = WBImageObject.init()
                imageObject.imageData = UIImagePNGRepresentation(model.image!)
                message.imageObject = imageObject
                let request = WBSendMessageToWeiboRequest.request(withMessage: message) as! WBSendMessageToWeiboRequest
                WeiboSDK.send(request)
            }
            else {
                guard self.failureBlock == nil else {
                    self.failureBlock!(AuthErrorCode.parameterEmpty.rawValue + "：分享图片缺失,请填写model.image")
                    return
                }
            }
        }
        else {
            guard self.failureBlock == nil else {
                self.failureBlock!(AuthErrorCode.noWeiBoApp.rawValue)
                return
            }
        }
    }
    
    private func checkObjectNotNull(object: Any?) -> Bool {
        
        guard object != nil else {
            return false
        }
        guard !(object is NSNull) else {
            return false
        }
        guard !(object is String) else {
            
            if (object as! String).isEmpty {
                return false
            }
            return true
        }
        guard !(object is NSDictionary) else {
            
            if (object as! NSDictionary).count <= 0 {
                return false
            }
            return true
        }
        guard !(object is NSArray) else {
            
            if (object as! NSArray).count <= 0 {
                return false
            }
            return true
        }
        guard !(object is NSNumber) else {
            return true
        }
        return true
    }
    
    /// 存储数据到本地
    ///
    /// - parameter key:   key
    /// - parameter value: the value that you want to save
    func saveDataToLocal(key: String, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize() }
    
    /// 从本地读取数据
    ///
    /// - parameter key: key
    ///
    /// - returns: the value with the key you want
    func readDataFromLocal(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key) }

}
