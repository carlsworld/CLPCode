#
Pod::Spec.new do |s|

  s.name         = "CLPCode"
  s.version      = "0.0.4"
  s.summary      = "A simple tool"
  s.homepage     = "https://github.com/carlsworld/CLPCode"
  s.license      = "MIT"
  s.author             = { "Carlson" => "ioslove@126.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/carlsworld/CLPCode.git", :tag => "0.0.4" }

  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
   core.ios.deployment_target = '8.0'
   core.source_files = 'CLPCode/Class/Common/**/*.{h,m}'
  end

  s.subspec 'SimpleKit' do |sk|
	sk.ios.deployment_target = '8.0'
	sk.source_files = 'CLPCode/Class/Kit/CLPSimpleKit/*.{h,m}'
  end

  s.subspec 'PhotoBrowser' do |pb|
	pb.ios.deployment_target = '8.0'
	pb.source_files = 'CLPCode/Class/Kit/CLPhotoBrowser/*.{h,m}'
	pb.dependency 'SDWebImage'
  end
end
