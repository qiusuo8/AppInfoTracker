Pod::Spec.new do |s|

  s.name         = "AppInfoTracker"
  s.version      = "1.0.1"
  s.summary      = "App information tracker for your iOS, OS X, and tvOS app"

  s.description  = <<-DESC
                   AppInfoTracker
                   * Install versions history.
                   * Tell you is First launch for certain version or build or today.
                   * Tell you numbers of startups for app.
                   DESC

  s.homepage     = "https://github.com/qiusuo8/AppInfoTracker"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author            = { "Zhao Zhihui" => "zhihui.zhao.jl@gmail.com" }
  s.social_media_url   = "https://github.com/qiusuo8"

  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"

  s.source       = { :git => "https://github.com/qiusuo8/AppInfoTracker.git", :tag => s.version }

  s.source_files  = ["Sources/*.swift", "Sources/AppInfoTracker.h", "Sources/AppInfoTracker.swift"]
  s.public_header_files = ["Sources/AppInfoTracker.h"]

  s.requires_arc = true
  s.framework = "Foundation"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
