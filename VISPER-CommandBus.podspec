Pod::Spec.new do |s|
  s.name             = "VISPER-CommandBus"
  s.version          = "0.1.4"
  s.summary          = "A command bus implementation for the visper application framework"

  s.description      = <<-DESC
                        A command bus implementation for the visper application framework.
                       DESC

  s.homepage         = "https://github.com/barteljan/VISPER-CommandBus"
  s.license          = 'MIT'
  s.author           = { "Jan Bartel" => "barteljan@yahoo.de" }
  s.source           = { :git => "https://github.com/barteljan/VISPER-CommandBus.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

end
