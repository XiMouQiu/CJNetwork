Pod::Spec.new do |s|
  s.name         = "CJNetwork"
  s.version      = "0.0.7"
  s.summary      = "一个AFNetworking应用的封装"
  s.homepage     = "https://github.com/dvlproad/CJNetwork"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dvlproad/CJNetwork.git", :tag => "CJNetwork_0.0.7" }
  s.source_files  = "CJNetwork/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.subspec 'CJNetworkMonitor' do |ss|
    ss.source_files = "CJNetwork/CJNetworkMonitor/**/*.{h,m}"
    ss.dependency 'AFNetworking', '~> 3.1.0'
  end

  s.subspec 'CJRequestUtil' do |ss|
    ss.source_files = "CJNetwork/CJRequestUtil/**/*.{h,m}"
  end

  s.subspec 'CJCacheManager' do |ss|
    ss.source_files = "CJCacheManager/**/*.{h,m}"
  end

  # 请求缓存
  s.subspec 'AFHTTPSessionManager+CJCacheRequest' do |ss|
    ss.source_files = "CJNetwork/AFHTTPSessionManager+CJCacheRequest/**/*.{h,m}"

    ss.dependency 'CJNetwork/CJNetworkMonitor'
    ss.dependency 'CJNetwork/CJCacheManager'
    ss.dependency 'SVProgressHUD', '~> 1.1.3'
  end

  # 版本检查（子类会自称父类的s.dependency）
  s.subspec 'AFHTTPSessionManager+CJCheckVersion' do |ss|
    ss.source_files = "CJNetwork/AFHTTPSessionManager+CJCheckVersion/**/*.{h,m}"
    ss.dependency 'CJNetwork/CJNetworkMonitor'
  end

  # 文件上传（子类会自称父类的s.dependency）
  s.subspec 'AFHTTPSessionManager+CJUploadFile' do |ss|
    ss.source_files = "CJNetwork/AFHTTPSessionManager+CJUploadFile/**/*.{h,m}"
    ss.dependency 'CJNetwork/CJNetworkMonitor'
  end

end