source 'https://rubygems.org'
gemspec

gem 'maxminddb'
gem 'down'
logstash_path = ENV['LOGSTASH_PATH'] || '/usr/share/logstash'

if Dir.exist?(logstash_path)
  gem 'logstash-core', :path => "#{logstash_path}/logstash-core"
  gem 'logstash-core-plugin-api', :path => "#{logstash_path}/logstash-core-plugin-api"
end

