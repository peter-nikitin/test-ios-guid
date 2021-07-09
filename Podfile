# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def mindbox
  pod 'Mindbox'
end

target 'Test-Guid' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Test-Guid
 # Add Mindbox SDK
 mindbox
  
 target 'MindboxNotificationServiceExtension' do
   mindbox
 end
 
 target 'MindBoxNotificationContent' do
   mindbox
 end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    case target.name
    when 'Mindbox'
      target.build_configurations.each do |config|
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
      end
    end
  end
end