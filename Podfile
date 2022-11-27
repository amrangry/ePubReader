# source 'https://github.com/CocoaPods/Specs.git'
# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
use_frameworks!
#install! 'cocoapods', :warn_for_unused_master_specs_repo => false
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false, :warn_for_unused_master_specs_repo => false

target 'EpubBookReader' do
  # Comment the next line if you don't want to use dynamic frameworks

  #Pods for EpubBookReader
  
#Readium
pod 'R2Shared', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/2.4.0/Support/CocoaPods/ReadiumShared.podspec'
pod 'R2Streamer', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/2.4.0/Support/CocoaPods/ReadiumStreamer.podspec'
pod 'R2Navigator', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/2.4.0/Support/CocoaPods/ReadiumNavigator.podspec'
pod 'ReadiumOPDS', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/2.4.0/Support/CocoaPods/ReadiumOPDS.podspec'

# Required for R2Streamer.
pod 'GCDWebServer', podspec: 'https://raw.githubusercontent.com/readium/GCDWebServer/master/GCDWebServer.podspec'

pod 'GRDB.swift'
pod 'Kingfisher'
pod 'MBProgressHUD'
pod 'SwiftSoup'

# Network
pod 'Alamofire', :inhibit_warnings => true #, '~> 5.2.2' #5.5.0

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            #config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO' # issue while signing BarcodeScanner via xCode 14.0.1 ref:https://github.com/hyperoslo/BarcodeScanner/issues/215
            #config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO' # issue to run while running for simulator need to use User Defined Settin (VALID_ARCHS)
            #config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
#            config.build_settings['SWIFT_2.4.0'] = '5.1.4'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
