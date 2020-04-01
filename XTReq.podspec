#
#  Be sure to run `pod spec lint XTReq.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "XTReq"
  s.version      = "4.0.9"
  s.summary      = "基于AFNetworking,代码最少,支持缓存的多种方案"
  s.description  = "Based on AFNetworing and sqlite encapsulation, simple APIs and persistent storage requests."
                  

  s.homepage     = "https://github.com/Akateason/XTReq"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "teason" => "akateason@qq.com" }
  
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #
  
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/Akateason/XTReq.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

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
