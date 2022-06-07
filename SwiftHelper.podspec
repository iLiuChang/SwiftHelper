Pod::Spec.new do |s|
  s.name         = "SwiftHelper"
  s.version      = "1.3.0"
  s.summary      = "Some extensions in Swift."
  s.homepage     = "https://github.com/iLiuChang/SwiftHelper"
  s.license      = "MIT"
  s.author       = "LiuChang"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/iLiuChang/SwiftHelper.git", :tag => s.version }
  s.source_files  =  "SwiftHelper/**/*.{swift}"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.swift_version = "4.2"
end
