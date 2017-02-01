Pod::Spec.new do |spec|

    spec.name              = 'catalyze-ios-sdk'
    spec.version           = '4.1.0'
    spec.summary           = 'SDK for interacting with the Catalyze API'
    spec.homepage          = 'https://github.com/catalyzeio/catalyze-ios-sdk'
    spec.license           = {
        :type => 'Apache License, Version 2.0',
        :file => 'LICENSE'
    }
    spec.authors           = {
        'Josh Ault' => 'josh@catalyze.io'
    }
    spec.source            = {
        :git => 'https://github.com/catalyzeio/catalyze-ios-sdk.git',
        :tag => spec.version.to_s
    }
    spec.source_files      = 'catalyze-ios-sdk/*.{h,m}'
    spec.requires_arc      = true
    spec.platform = :ios, '7.0'
    spec.dependency 'AFNetworking', '~> 3.0'
		# The AFNetworkActivityLogger requires the following setup in your podfile
		# pod 'AFNetworkActivityLogger', :git => 'https://github.com/AFNetworking/AFNetworkActivityLogger.git', :branch => '3_0_0'
    # pod 'catalyze-ios-sdk', :path => 'path_to/catalyze-ios-sdk'
		spec.dependency 'AFNetworkActivityLogger'
end
