require 'json'
require 'curb'

class GeoIpCurb
  SERVICE_URL     = "http://api.ipinfodb.com/v3"
  CITY_API        = "ip-city"
  COUNTRY_API     = "ip-country"
  IPV4_REGEXP     = /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/
  TIMEOUT         = 10
  ERROR_PREFIX    = "API service error"

  @@api_key = nil

  def self.api_key
    @@api_key
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  # Retreive the remote location of a given ip address.
  #
  # It takes two optional arguments:
  # * +precision+: can either be +:city+ (default) or +:country+
  # * +timeout+: number of seconds to wait before timing out
  # * +service_url+: set the service URL, in case it changes, or you want to proxy it for additional caching, etc. Add 'APIKEYPLACEHOLDER' and 'IPPLACEHOLDER' in the right places and they will be replaced accordingly.
  #
  # ==== Example:
  #   GeoIpCurb.geolocation('209.85.227.104', {:precision => :city, :timeout => 5})
  def self.geolocation(ip, options={})
    @precision   = options[:precision]   || :country
    @timeout     = options[:timeout]     || TIMEOUT
    @service_url = options[:service_url] || nil

    raise "API key must be set first: GeoIpCurb.api_key = 'YOURKEY'" if self.api_key.nil?
    raise "Invalid IP address" unless ip.to_s =~ IPV4_REGEXP
    raise "Invalid precision"  unless [:country, :city].include?(@precision)

    if @service_url then
      @service_url = @service_url.sub("APIKEYPLACEHOLDER", self.api_key)
      @service_url = @service_url.sub("IPPLACEHOLDER", ip)
      uri = @service_url
    else
      uri = "#{SERVICE_URL}/#{@precision==:country ? COUNTRY_API : CITY_API}/?key=#{self.api_key}&ip=#{ip}&format=json"
    end
    
    puts uri

    convert_keys send_request(uri)
  end

  private

  def self.send_request(uri)
    http = Curl::Easy.new(uri)
    http.timeout = @timeout
    http.perform
    JSON.parse(http.body_str)
  rescue => e
    error = {}
    error[:error_msg] = "#{ERROR_PREFIX}: #{e}."
    error
  end

  def self.convert_keys(hash)
    location = {}
    location[:ip]                 = hash["ipAddress"]
    location[:status]             = hash["statusCode"]
    location[:status_message]     = hash["statusMessage"]
    location[:country_code]       = hash["countryCode"]
    location[:country_name]       = hash["countryName"]
    if @precision == :city
      location[:region_name]      = hash["regionName"]
      location[:city]             = hash["cityName"]
      location[:zip_postal_code]  = hash["zipCode"]
      location[:latitude]         = hash["latitude"]
      location[:longitude]        = hash["longitude"]
      location[:utc_offset]       = hash["timeZone"]
    end
    location[:status]             = "ERROR" if hash[:error_msg]
    location[:status_message]     = hash[:error_msg] if hash[:error_msg]
    location
  end
end