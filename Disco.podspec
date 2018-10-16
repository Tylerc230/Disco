Pod::Spec.new do |s|
  s.name             = 'Disco'
  s.version          = '1.0.0'
  s.summary          = 'Thin, fluent UIViewPropertyAnimator based animation library.'

  s.description      = <<-DESC
  Disco is a lightweight wrapper around UIViewPropertyAnimator class. It supports pausing, scrubbing and 
  reversing animations, keyframeing animations.
                       DESC

  s.homepage         = 'https://github.com/tylerc230/Disco'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tyler Casselman' => 'tyler@13bit.io' }
  s.source           = { :git => 'https://github.com/tylerc230/Disco.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.1'

  s.source_files = 'Disco/Classes/**/*'
  s.swift_version = '4.0'
end
