Pod::Spec.new do |s|

  s.name         = "SwiftHelper"
  s.version      = "0.0.1"
  s.summary      = "项目中用的一些工具类和Extension"
  s.homepage     = "https://github.com/LiuChang712/SwiftHelper"
  s.license      = "MIT"
  s.author             = { "LiuChang" => "helloliuchang@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LiuChang712/SwiftHelper.git", :tag => "0.0.1" }
  s.source_files  = "SwiftHelper/**/*.{h,m}"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency "Kingfisher"

end
