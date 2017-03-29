//
//  BQLShareModel.swift
//  BQLAuthEngine_Swift
//
//  Created by biqinglin on 2017/3/16.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

import UIKit

class BQLShareModel: NSObject {
    
    var text : NSString? = ""
    var title : NSString? = ""
    var describe : NSString? = ""
    var image : UIImage? = nil;
    var previewImage : UIImage? = nil
//    var previewImage : UIImage? {
//        get {
//            if previewImage == nil {
//                return image
//            }
//            if self.image == nil {
//                return nil
//            }
//            return self.previewImage
//        }
//        set {
//        }
//    }
    var urlString : NSString? = "";
    var previewUrlString : NSString? = "";
    
    /// 防止出现不存在key引起的carsh
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    /// 构造模型
    init(dictionary: [String: Any]) {
        
        super.init()
        self.setValuesForKeys(dictionary)
    }

}
