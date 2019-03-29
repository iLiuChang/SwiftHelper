Pod::Spec.new do |s|

  s.name         = "SwiftHelper"
  s.version      = "0.1"
  s.summary      = "项目中用的一些工具类和Extension"
  s.homepage     = "https://github.com/iLiuChang/SwiftHelper"
  s.license      = "MIT"
  s.author             = "LiuChang"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/iLiuChang/SwiftHelper.git", :tag => s.version }
  s.source_files  =  "SwiftHelper/**/*.{swift}"
  s.framework  = "UIKit"
  s.requires_arc = true

end
