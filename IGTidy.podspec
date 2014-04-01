#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "IGTidy"
  s.version          = "0.1.0"
  s.summary          = "A short description of IGTidy."
  s.description      = <<-DESC
                       An optional longer description of IGTidy

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "http://EXAMPLE/NAME"
  s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Francis Chong" => "francis@ignition.hk" }
  s.source           = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EXAMPLE'

  s.requires_arc = true

  s.public_header_files = 'vendor/tidy-html5/include/*.h'
  s.source_files = 'Classes', 'vendor/tidy-html5/src/*.{h,c}'
  s.resources = 'Assets/*.png'

end
