Pod::Spec.new do |s|

  s.name         = "SwiftHelper"
  s.version      = "0.0.6"
  s.summary      = "项目中用的一些工具类和Extension"
  s.homepage     = "https://github.com/LiuChang712/SwiftHelper"
  s.license      = "MIT"
  s.author             = { "liuchang" => "iosliuchang@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LiuChang712/SwiftHelper.git", :tag => s.version }
  s.source_files  = "SwiftHelper", "SwiftHelper/**/*.{swift}"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency "Kingfisher"

end
