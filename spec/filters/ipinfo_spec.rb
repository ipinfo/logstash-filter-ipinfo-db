# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/ipinfo"

describe LogStash::Filters::Ipinfo do
  describe "ipinfo lookup test" do
    config <<-CONFIG
      filter {
        ipinfo {
          source => "ip"
        }
      }
    CONFIG

    sample("ip" => "173.9.34.107") do
      insist { subject.get("ipinfo") }.include?("country")
    end
  end
end
