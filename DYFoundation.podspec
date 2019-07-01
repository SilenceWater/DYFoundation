Pod::Spec.new do |s|
s.name             = 'DYFoundation'
s.version          = '0.1.0'
s.summary          = 'A short description of DYNetwork.'

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/SilenceWater/DYFoundation'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { '昌' => 'dyzhcs' }
s.source           = { :git => 'https://github.com/SilenceWater/DYFoundation.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'


s.source_files = 'DYFoundation/Classes/**/*.{h,m}'
s.public_header_files = 'DYFoundation.h'


#s.dependency 'AFNetworking'


end
