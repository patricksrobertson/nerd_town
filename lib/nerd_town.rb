require "nerd_town/version"
require "nerd_town/guild"
require "faraday_middleware"

module NerdTown
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration = Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :api_key

    def http_connection
      @connection ||= Faraday.new(url: 'https://us.api.battle.net/wow/',
                                   params: {apikey: self.api_key,
                                            locale: 'en_US'}) do |faraday|
        faraday.request :url_encoded
        faraday.request :json

        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
