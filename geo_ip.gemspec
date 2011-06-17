# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'geo_ip_curb'
  s.version     = '0.4.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ryan Conway']
  s.summary     = 'Retrieve the geolocation of an IP address using the the ipinfodb.com v3 API service using Curb.'
  s.description = 'A call to the v3 API over at ipinfodb.com will be done to retrieve the geolocation based on the IP address. No need to include a database file in the application.'

  s.files         = Dir['README.rdoc', 'CHANGES', 'LICENSE', 'lib/**/*']
  s.test_files    = Dir.glob('test/**/*')
  s.require_paths = ['lib']

  s.add_dependency 'json', '~> 1.4.6'
  s.add_dependency 'curb', '~> 0.7.15'
  s.add_development_dependency 'mocha', '~> 0.9.12'  
end
