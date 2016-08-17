Pod::Spec.new do |s|
  s.name             = "FwiCore"
  s.version          = "v0.9.0"
  s.summary          = "FwiCore is a set of extension for Swift"
  s.description      = <<-DESC
FwiCore is a set of extension for Swift. FwiCore also provide some simple network implementation and core data.
                        DESC
  s.homepage         = "https://github.com/phuc0302/swift-core"
  s.license          = 'MIT'
  s.author           = { "Phuc, Tran Huu" => "phuc@fiisionstudio.com" }
  s.source           = { :git => "https://github.com/phuc0302/swift-core.git", :tag => s.version.to_s }

  s.requires_arc     = true

  s.ios.deployment_target = '8.0'

  s.source_files          = 'FwiCore/**/*.swift'
end
