#
Pod::Spec.new do |s|

  s.name         = "CLPCode"
  s.version      = "0.0.2"
  s.summary      = "A simple tool"
  s.homepage     = "https://github.com/carlsworld/CLPCode"
  s.license      = "MIT"
  s.author             = { "Carlson" => "ioslove@126.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/carlsworld/CLPCode.git", :tag => "0.0.2" }

  s.requires_arc = true
  s.source_files  = "CLPCode/Class/Common/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.subspec 'SimpleKit' do |sk|
	sk.ios.deployment_target = '8.0'
	sk.source_files = 'CLPCode/Class/Kit/CLSimpleKit/*.{h,m}
  end

  s.subspec 'PhotoBrowser' do |pb|
	pb.ios.deployment_target = '8.0'
	pb.source_files = 'CLPCode/Class/Kit/CLPhotoBrowser/*.{h,m}'
	pb.dependency 'SDWebImage'
  end
end
