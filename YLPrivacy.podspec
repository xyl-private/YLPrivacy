Pod::Spec.new do |spec|

spec.name         = "YLPrivacy"
spec.version      = "0.0.3"
spec.summary      = "iOS 隐私权限授权"

spec.description  = <<-DESC
iOS 隐私许可状态,设置权限的许可
DESC
spec.homepage     = "https://github.com/xyl-private/YLPrivacy"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author       = { "村雨灬龑" => "xyl_private@163.com" }
spec.ios.deployment_target = "9.0"



spec.source       = { :git => "https://github.com/xyl-private/YLPrivacy.git", :tag => "#{spec.version}" }

spec.requires_arc = true
spec.default_subspec = 'All'

spec.subspec 'All' do |all|
    all.source_files = 'YLPrivacy/*.{h,m}'
end

spec.subspec 'Base' do |base|
base.source_files = 'YLPrivacy/YLPrivacyPermissionSetting.{h,m}','YLPrivacy/YLPrivacyPermission.{h,m}','YLPrivacy/YLPrivacyConstantMacro.{h,m}'
end

spec.subspec 'Camera' do |camera|
camera.source_files = 'YLPrivacy/YLPrivacyPermissionCamera.{h,m}'
end

spec.subspec 'Photo' do |photo|
photo.source_files = 'YLPrivacy/YLPrivacyPermissionPhotos.{h,m}'
end

spec.subspec 'Contact' do |contact|
contact.source_files = 'YLPrivacy/YLPrivacyPermissionContacts.{h,m}'
end

spec.subspec 'Location' do |location|
location.source_files = 'YLPrivacy/YLPrivacyPermissionLocation.{h,m}'
end

spec.subspec 'Reminder' do |reminder|
reminder.source_files = 'YLPrivacy/YLPrivacyPermissionReminders.{h,m}'
end

spec.subspec 'Calendar' do |calendar|
calendar.source_files = 'YLPrivacy/YLPrivacyPermissionCalendar.{h,m}'
end

spec.subspec 'Microphone' do |microphone|
microphone.source_files = 'YLPrivacy/YLPrivacyPermissionMicrophone.{h,m}'
end

spec.subspec 'Health' do |health|
health.source_files = 'YLPrivacy/YLPrivacyPermissionHealth.{h,m}'
end

spec.subspec 'Net' do |net|
net.source_files = 'YLPrivacy/YLPrivacyPermissionNet.{h,m}','YLPrivacy/NetReachability.{h,m}','YLPrivacy/YLPrivacyPermissionData.{h,m}'
end

spec.subspec 'Tracking' do |tracking|
tracking.source_files = 'YLPrivacy/YLPrivacyPermissionTracking.{h,m}'
end

spec.subspec 'Notification' do |notification|
notification.source_files = 'YLPrivacy/YLPrivacyPermissionNotification.{h,m}'
end

end
