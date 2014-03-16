$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'pi-sys/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'pi-sys'
  s.version     = PiSys::VERSION
  s.date        = '2014-03-13'
  s.summary     = 'Raspbian system status'
  s.description = 'Retrieve Raspbian OS system resource status.'
  s.authors     = ['José Airosa']
  s.email       = 'me@joseairosa.com'
  s.files       = %w(lib/pi-sys.rb)

  s.files = Dir['{app,config,db,lib}/**/*'] + %w(LICENSE README.md)

  s.add_dependency 'usagewatch'

  s.add_development_dependency 'pry-plus', '~> 1.0.0'
  s.add_development_dependency 'rake', '~> 10.1.0'
  s.add_development_dependency 'rspec', '~> 2.14.1'
end
