# encoding: utf-8
require "logstash/filters/base"
require 'down'
require 'maxminddb'
# require 'open-uri'
# require "fileutils"
$MMDB_FILE_DOWNLOAD_URL = "https://ipinfo.io/data/free/country_asn.mmdb?token=4ca1f6f7f6a4ae"
$MMDB_FILE_NAME = "country_asn.mmdb"
# This ipinfo filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an ipinfo.
class LogStash::Filters::Ipinfo < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   ipinfo {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "ipinfo"

  # The field containing the IP address or hostname to map via ipinfo. If
  # this field is an array, only the first value will be used.
  config :source, :validate => :string, :required => true

  # The field to write the JSON into. If not specified, the source
  # field will be overwritten.
  config :target, :validate => :string, :default => "ipinfo"

  # Tags the event on failure to look up ipinfo information. This can be used in later analysis.
  config :tag_on_failure, :validate => :array, :default => ["_ipinfo_lookup_failure"]

  public
  def register
    # Add instance variables
    setup_database
  end # def register

  public
  def filter(event)
    @logger.debug? && @logger.debug("Running ipinfo lookup", :event => event)
    ip = event.get(@source)

    begin
      ret = @db.lookup(ip)
      event.set(@target, ret.to_hash)
      filter_matched(event)
    rescue => e
      tag_unsuccessful_lookup(event)
    end
  end # def filter

  def tag_unsuccessful_lookup(event)
    @logger.debug? && @logger.debug("IP #{event.get(@source)} was not found in the database", :event => event)
    @tag_on_failure.each{|tag| event.tag(tag)}
  end

  def setup_database
    if !File.exist?($MMDB_FILE_NAME)
      tempfile = Down.download($MMDB_FILE_DOWNLOAD_URL)
      FileUtils.mv(tempfile.path, "./#{tempfile.original_filename}")
    end
    # Load .mmdb file in MaxMindDB reader
    @db = MaxMindDB.new("./#{$MMDB_FILE_NAME}", MaxMindDB::LOW_MEMORY_FILE_READER)
  end

end # class LogStash::Filters::Ipinfo
