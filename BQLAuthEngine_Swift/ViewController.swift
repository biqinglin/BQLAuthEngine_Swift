//
//  ViewController.swift
//  BQLAuthEngine_Swift
//
//  Created by biqinglin on 2017/3/16.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    // QQ登录
    @IBAction func qq_login(_ sender: Any) {
        
        BQLAuthEngine.single.auth_qq_login(success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // QQ文本分享
    @IBAction func qq_text_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["text":"i am a text"])
        BQLAuthEngine.single.auth_qq_share_text(model: model, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // QQ图片分享
    @IBAction func qq_image_share(_ sender: Any) {
    
        let model = BQLShareModel.init(dictionary: ["image":UIImage.init(named: "qqf")!,
                                                    "title":"i am a title",
                                                    "describe":"i am a describe"])
        BQLAuthEngine.single.auth_qq_share_image(model: model, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // QQ链接分享
    @IBAction func qq_link_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["previewImage":UIImage.init(named: "qqf")!,
                                                    "title":"i am a title",
                                                    "describe":"i am a describe",
                                                    "urlString":"https://github.com/biqinglin"])
        BQLAuthEngine.single.auth_qq_share_link(model: model, scene: .session, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微信登录
    @IBAction func wechat_login(_ sender: Any) {
        
        BQLAuthEngine.single.auth_wechat_login(success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微信文本分享
    @IBAction func wechat_text_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["text":"i am a text"])
        BQLAuthEngine.single.auth_wechat_share_text(model: model, scene: .session, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微信图片分享
    @IBAction func wechat_image_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["image":UIImage.init(named: "qqf")!])
        BQLAuthEngine.single.auth_wechat_share_image(model: model, scene: .session, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微信链接分享
    @IBAction func wechat_link_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["title":"support me",
                                                    "describe":"support me and start me,thanks~",
                                                    "previewImage":UIImage.init(named: "wechatf")!,
                                                    "urlString":"https://github.com/biqinglin"])
        BQLAuthEngine.single.auth_wechat_share_link(model: model, scene: .session, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微信视频分享
    @IBAction func wechat_video_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["title":"support me",
                                                    "describe":"support me and start me,thanks~",
                                                    "previewImage":UIImage.init(named: "wechatf")!,
                                                    "urlString":"https://github.com/biqinglin"])
        BQLAuthEngine.single.auth_wechat_share_video(model: model, scene: .session, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微信音频分享
    @IBAction func wechat_audio_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["title":"support me",
                                                    "describe":"support me and start me,thanks~",
                                                    "previewImage":UIImage.init(named: "wechatf")!,
                                                    "urlString":"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4B880E697A0E68980E69C89222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696334382E74632E71712E636F6D2F586B30305156342F4141414130414141414E5430577532394D7A59344D7A63774D4C6735586A4C517747335A50676F47443864704151526643473444442F4E653765776B617A733D2F31303130333334372E6D34613F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D30222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31342E71716D757369632E71712E636F6D2F33303130333334372E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E4B880E697A0E68980E69C89222C22736F6E675F4944223A3130333334372C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E5B494E581A5222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D313574414141416A41414141477A4C36445039536A457A525467304E7A38774E446E752B6473483833344843756B5041576B6D48316C4A434E626F4D34394E4E7A754450444A647A7A45304F513D3D2F33303130333334372E6D70333F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D3026616D703B73747265616D5F706F733D35227D"])
        BQLAuthEngine.single.auth_wechat_share_music(model: model, scene: .session, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微博登录
    @IBAction func sina_login(_ sender: Any) {
        
        BQLAuthEngine.single.auth_sina_login(success: { (response) in
            
            print(response!)
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微博文本分享
    @IBAction func sina_text_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["text":"i am a text"])
        BQLAuthEngine.single.auth_sina_share_text(model: model, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微博链接分享
    @IBAction func sina_link_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["text":"i am a text",
                                                    "urlString":"https://github.com/biqinglin",
                                                    "image":UIImage.init(named: "weibo")!])
        BQLAuthEngine.single.auth_sina_share_link(model: model, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    // 微博图片分享
    @IBAction func sina_image_share(_ sender: Any) {
        
        let model = BQLShareModel.init(dictionary: ["text":"i am a text",
                                                    "image":UIImage.init(named: "weibo")!])
        BQLAuthEngine.single.auth_sina_share_image(model: model, success: { (response) in
            
            print("success")
            
        }) { (error) in
            
            print("error" + error!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

