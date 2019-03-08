# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'

inhibit_all_warnings!

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

target 'QiWi' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  #loading animation
  pod 'MBProgressHUD'                                                           #MIT

  #pull refresh
  pod 'MJRefresh'                                                               #MIT

  #model
  pod 'JSONModel'                                                               #MIT

  #net
  pod 'AFNetworking'                                                            #MIT
  pod 'AFNetworking+RetryPolicy'
  pod 'SDWebImage'                                                              #MIT

  #autolayout
  pod 'Masonry'                                                                 #MIT

  #badge
  pod 'JSBadgeView'                                                             #MIT
  
  #block
  pod 'BlocksKit'
  pod 'Block-KVO', :git => "https://github.com/iMartinKiss/Block-KVO.git"
#  pod 'PromiseKit', "~> 6.0"
  
  #toast
  pod 'CRToast', '~> 0.0.7'                                                     #MIT

  #Pager
  pod 'MXSegmentedPager'
  
  #empty view
  #pod 'DZNEmptyDataSet'
  
  #syntactic
  pod 'Then'                                                                    #MIT
  
  #map sdk                                                                      #ThirdParty
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  
  pod 'BaiduMapKit'                                                             #百度地图SDK
  #view
  pod 'SwiftMessages'                                                           #MIT
  pod 'QRCode'                                                                  #MIT
  pod 'SideMenu'                                                                #MIT
  pod 'DropDown'                                                                #MIT

  #rating 
  pod 'Cosmos', '~> 16.0'                                                       #MIT
  
  #register
  pod 'NKVPhonePicker'
end
