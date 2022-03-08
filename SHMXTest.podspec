Pod::Spec.new do |s|
  s.name             = 'SHMXTest'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SHMXTest.'

  s.description      = <<~DESC
    TODO: Add long description of the pod here.
  DESC

  s.homepage         = 'https://github.com/bobandiga/SHMXTest'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'bobandiga' => 'shmx.dev@gmail.com' }
  s.source           = { git: 'https://github.com/bobandiga/SHMXTest.git', tag: s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.0', '5.1']
  s.frameworks = 'XCTest', 'UIKit'

  s.source_files = 'SHMXTest/Classes/**/*'

  s.resource_bundles = {
      'SHMXTest' => ['SHMXTest/Assets/*.png']
  }

  s.test_spec 'Tests' do |ts|
    ts.requires_app_host = true
    ts.resources = "#{s.name}/Tests/Resources/Stubs/**/*.{json,png}"
    ts.source_files = "#{s.name}/Tests/**/*.swift"
  end
end
