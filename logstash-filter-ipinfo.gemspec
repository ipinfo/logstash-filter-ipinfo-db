Gem::Specification.new do |s|
  s.name          = 'logstash-filter-ipinfo'
  s.version       = '0.1.2'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Logstash Filter Plugin for Ipinfo'
  s.description   = ''
  s.homepage      = 'https://ipinfo.io'
  s.authors       = ['Muhammad Awais Murad']
  s.email         = 'awais@ipinfo.io'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency "down"
  s.add_runtime_dependency "maxminddb"
  s.add_development_dependency 'logstash-devutils'
end
