#
#  Be sure to run `pod spec lint MyFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

# Pod::Spec.new do |spec|

#   spec.name         = "Klerio"
#   spec.version      = "1.0.0"
#   spec.summary      = "A short description of MyFramework."
#   spec.description  = "A complete description of MyFramework"

#   spec.platform     = :ios, "12.1"

#   spec.homepage     = "http://EXAMPLE/Klerio"
#   spec.license      = "MIT"
#   spec.author             = { "Swapnil Jagtap" => "swapnilajagtap@gmail.com" }
#   #spec.source       = { :path => '.' }
#   spec.source       = { :git => "https://github.com/swapnil-vuclip/Klerio.git", :tag => "1.0.1" }
#   #spec.source       = { :git => "https://github.com/aliakhtar49/MyFramework.git", :commit => "2c360b814bfb2c6aa233e72df892c71c84412b22" }

  
#    spec.source_files  = "Klerio"
  
#   spec.exclude_files = "Classes/Exclude"
#   spec.swift_version = "4.2" 
#   spec.dependency 'Alamofire'
#   spec.dependency 'SwiftyJSON'

# #  spec.source_files  = 'Klerio/CoreDataModel.xcdatamodeld.xcdatamodeld', 'Klerio/CoreDataModel.xcdatamodeld.xcdatamodeld/*.xcdatamodel'
#   spec.resources = [ 'Klerio/CoreDataModel.xcdatamodeld','Klerio/Klerio/CoreDataModel.xcdatamodeld/*.xcdatamodel']
#   spec.preserve_paths = 'Klerio/CoreDataModel.xcdatamodeld'
# end



Pod::Spec.new do |s|

  s.platform     = :ios, '12.1'
    
  s.exclude_files = 'Classes/Exclude'
  s.swift_version = '4.2' 
  #s.dependency 'Alamofire'
  #s.dependency 'SwiftyJSON'

#  spec.source_files  = 'Klerio/CoreDataModel.xcdatamodeld.xcdatamodeld', 'Klerio/CoreDataModel.xcdatamodeld.xcdatamodeld/*.xcdatamodel'
  s.resources = [ 'Klerio/Klerio/CoreDataModel.xcdatamodeld','Klerio/Klerio/CoreDataModel.xcdatamodeld/*.xcdatamodel']
  s.preserve_paths = 'Klerio/Klerio/CoreDataModel.xcdatamodeld'



    s.name             = 'Klerio'
    s.version          = '1.0.6'
    s.summary          = 'A highly customisable and reusable iOS circular slider.'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    JOCircularSlider is a highly customisable and reusable iOS circular slider that mimics the behaviour of a knob control. It uses no preset images and every one of its components is drawn completely in code making it extremely adaptable to every design and theme.
    It's written in Swift 4.2 and it's 100% IBDesignable and all parameters are IBInspectable.
    You can control almost every aspect of the slider's design: Size, colors, direction (clockwise/anti-clockwise), etc...
    DESC

    s.homepage         = 'https://github.com/swapnil-vuclip/Klerio'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Swapnil Jagtap' => 'swapnilajagtap@gmail.com' }
    # spec.source       = { :git => 'https://github.com/swapnil-vuclip/Klerio.git', :tag => '1.0.1' }
    s.source           = { :git => 'https://github.com/swapnil-vuclip/Klerio.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/ouraigua'

    s.ios.deployment_target = '10.0'

    # s.framework = "XCTest"
    s.dependency 'Alamofire', '~> 4.9.1'
    s.dependency 'SwiftyJSON', '~>5.0.0'

    s.source_files  = "Klerio/**/*.{h,m,swift}"



    # s.source_files = 'Klerio/Classes/**/*'

    # s.documentation_url = 'http://ouraigua.com/github/jocircularslider/docs/index.html'

end
