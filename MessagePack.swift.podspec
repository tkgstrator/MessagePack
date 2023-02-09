Pod::Spec.new do |s|
  s.name         = 'NSMessagePack.swift'
  s.version      = '4.0.0'
  s.summary      = "It's like JSON, but fast and small...and Swift!"
  s.homepage     = 'https://github.com/tkgstrator/NSMessagePack.swift'
  s.license      = 'MIT'
  s.author       = { 'Alexsander Akers' => 'me@a2.io' }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/tkgstrator/NSMessagePack.swift.git', :tag => s.version.to_s }
  s.source_files = 'Sources/NSMessagePack/*.swift'
  s.swift_version = '5.2'
  s.module_name  = 'MessagePack'
end
