#
#  Be sure to run `pod spec lint MyFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "Klerio"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of MyFramework."
  spec.description  = "A complete description of MyFramework"

  spec.platform     = :ios, "12.1"

  spec.homepage     = "http://EXAMPLE/Klerio"
  spec.license      = "MIT"
  spec.author             = { "Swapnil Jagtap" => "swapnilajagtap@gmail.com" }
  #spec.source       = { :path => '.' }
  spec.source       = { :git => "https://github.com/swapnil-vuclip/Klerio.git", :tag => "1.0.1" }
  #spec.source       = { :git => "https://github.com/aliakhtar49/MyFramework.git", :commit => "2c360b814bfb2c6aa233e72df892c71c84412b22" }

  
   spec.source_files  = "Klerio"
  
  spec.exclude_files = "Classes/Exclude"
  spec.swift_version = "4.2" 
  spec.dependency 'Alamofire'
  spec.dependency 'SwiftyJSON'

#  spec.source_files  = 'Klerio/CoreDataModel.xcdatamodeld.xcdatamodeld', 'Klerio/CoreDataModel.xcdatamodeld.xcdatamodeld/*.xcdatamodel'
  spec.resources = [ 'Klerio/CoreDataModel.xcdatamodeld','Klerio/Klerio/CoreDataModel.xcdatamodeld/*.xcdatamodel']
  spec.preserve_paths = 'Klerio/CoreDataModel.xcdatamodeld'
end
