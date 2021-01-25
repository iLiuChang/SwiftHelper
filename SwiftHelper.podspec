Pod::Spec.new do |s|
  s.name         = "SwiftHelper"
  s.version      = "1.1.0"
  s.summary      = "Extensions"
  s.homepage     = "https://github.com/iLiuChang/SwiftHelper"
  s.license      = "MIT"
  s.author       = "LiuChang"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/iLiuChang/SwiftHelper.git", :tag => s.version }
  s.source_files  =  "SwiftHelper/**/*.{swift}"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.swift_version = "5.0"
end
