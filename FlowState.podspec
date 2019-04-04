#
# Be sure to run `pod lib lint FlowState.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlowState'
  s.version          = '1.5.0'
  s.summary          = 'Make easy, composable ViewController Flow Coordinators with FlowState.'

  s.description      = <<-DESC
Make easy, composable ViewController Flow Coordinators with FlowState.
FlowState is a simple, swifty, block based answer to composing ViewController Flows.
Create flows simply by composing steps for a flow of ViewControllers in a single file.
FlowState handles most Flow cases including asyncronous tasks, and routing content.

Get in that Flow State
                       DESC

  s.homepage         = 'https://github.com/buba447/FlowState'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'buba447' => 'buba447@gmail.com' }
  s.source           = { :git => 'https://github.com/buba447/FlowState.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/thewithra'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  s.source_files = 'FlowState/Classes/**/*'

end
