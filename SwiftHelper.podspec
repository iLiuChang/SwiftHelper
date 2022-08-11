Pod::Spec.new do |s|
  s.name         = "SwiftHelper"
  s.version      = "3.1.0"
  s.summary      = "Some extensions in Swift."
  s.homepage     = "https://github.com/iLiuChang/SwiftHelper"
  s.license      = "MIT"
  s.authors            = { "iLiuChang" => "iliuchang@foxmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/iLiuChang/SwiftHelper.git", :tag => s.version }
  s.framework  = "UIKit"
  s.requires_arc = true
  s.swift_version = "4.0"
  s.subspec "Foundation" do |ss|
    ss.source_files = "SwiftHelper/Foundation/*.{swift}"
  end
  s.subspec "UIKit" do |ss|
    ss.source_files = "SwiftHelper/UIKit/*.{swift}"
  end
end
