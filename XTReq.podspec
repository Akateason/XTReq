Pod::Spec.new do |s|

  s.name         = "XTReq"
  s.version      = "4.3.1"
  s.summary      = "a iOS Request lib, based on AFNetworking ."
  s.description  = "Based on AFNetworing and sqlite encapsulation, simple APIs and persistent storage requests."
                  

  s.homepage     = "https://github.com/Akateason/XTReq"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "teason" => "akateason@qq.com" }
  

  
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/Akateason/XTReq.git", :tag => s.version }



  s.source_files  =
  "XTReq/XTReq",
  "XTReq/XTReq/Cache",
  "XTReq/XTReq/Transport",
  "XTReq/XTReq/Transport/Downloader",
  "XTReq/XTReq/Transport/Uploader"

  s.public_header_files =
  "XTReq/XTReq/*.h",
  "XTReq/XTReq/Cache/*.h",
  "XTReq/XTReq/Transport/*.h",
  "XTReq/XTReq/Transport/Downloader/*.h",
  "XTReq/XTReq/Transport/Uploader/*.h"
    
  s.framework  = "CoreServices"
    
  s.dependency  "AFNetworking","4.0.0"
  s.dependency  "XTFMDB"
  s.dependency  "YYModel"
  s.dependency  "SVProgressHUD"
  s.dependency  "ReactiveObjC"

end
