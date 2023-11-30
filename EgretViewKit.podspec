Pod::Spec.new do |s|
  s.name             = 'EgretViewKit'
  s.version          = '1.0.0'
  s.summary          = 'A short description of EgretViewKit.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MF-dosear/EgretViewKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '564057354@qq.com' => '564057354@qq.com' }
  s.source           = { :git => 'https://github.com/MF-dosear/EgretViewKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
    
  s.requires_arc = true
      
  valid_archs = ['arm64']

  s.pod_target_xcconfig = {
    'VALID_ARCHS[sdk=iphonesimulator*]' => ''
  }

  s.source_files = ['EgretViewKit/Classes/**/*','EgretViewKit/Libraries/**/*.{h,c}']
    
  s.subspec 'Egret' do |dm|
      dm.vendored_libraries = 'EgretViewKit/Libraries/**/*.a'
  end
    
  s.public_header_files = [
      'EgretViewKit/Classes/**/*.h'
  ]
     
  s.frameworks  = 'AdSupport'
     
  s.libraries = 'c++'
  
  s.dependency 'AFNetworking', "~> 4.0.1"
  s.dependency 'Ads-CN', "~> 5.7.1.1"

end
