Pod::Spec.new do |spec|
  spec.name         = 'ImageLoaderPod'
  spec.version      = '1.0.0'
  spec.summary      = 'A local Swift library with XIB'
  spec.homepage     = 'https://example.com/ImageLoaderPod'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'hoannk' => 'hoannk310@email.com' }
  spec.source       = { :path => '.' }
  spec.platform     = :ios, '13.0'
  spec.swift_version = '5.0'
  spec.source_files  = 'Sources/**/*.swift'
  spec.resource_bundles = {
    'MyAwesomePodResources' => ['Sources/**/*.xib', 'Sources/Assets.xcassets']
  }
end
