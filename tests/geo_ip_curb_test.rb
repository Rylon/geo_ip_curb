require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class GeoIpCurbTest < Test::Unit::TestCase

  def setup
    api_config = YAML.load_file(File.dirname(__FILE__) + '/api.yml')
    GeoIpCurb.api_key = api_config['key']
  end

  def test_api_failure
    GeoIpCurb.expects(:send_request).returns({:error_msg => "#{GeoIpCurb::ERROR_PREFIX}: Im on fire!"}).once
    geolocation = GeoIpCurb.geolocation(IP_GOOGLE_US)
    
    assert_equal "ERROR", geolocation[:status]
    assert_match Regexp.new("^#{GeoIpCurb::ERROR_PREFIX}"), geolocation[:status_message]
    Mocha::Mockery.instance.stubba.unstub_all
  end
  
  def test_api_key_set
    GeoIpCurb.api_key = "my_api_key"
    assert_equal 'my_api_key', GeoIpCurb.api_key
  end
  
  def test_api_key_required
    GeoIpCurb.api_key = nil
    assert_raise RuntimeError do
      GeoIpCurb.geolocation(IP_GOOGLE_US)
    end
  end

  def test_correct_city_for_public_ip
    geolocation = GeoIpCurb.geolocation(IP_GOOGLE_US, {:precision => :city})
    assert_equal 'US',            geolocation[:country_code]
    assert_equal 'UNITED STATES', geolocation[:country_name]
    assert_equal 'CALIFORNIA',    geolocation[:region_name]
    assert_equal 'MONTEREY PARK', geolocation[:city]
  end

  def test_correct_timezone_for_public_ip
    geolocation = GeoIpCurb.geolocation(IP_GOOGLE_US, {:precision => :city})
    assert_equal '-08:00',        geolocation[:utc_offset]
  end
  
  def test_correct_timezone_for_private_ip
    geolocation = GeoIpCurb.geolocation(IP_PRIVATE, {:precision => :city})
    assert_equal '-',             geolocation[:utc_offset]
  end
  
  def test_correct_timezone_for_local_ip
    geolocation = GeoIpCurb.geolocation(IP_LOCAL, {:precision => :city})
    assert_equal '-',             geolocation[:utc_offset]
  end
  
  def test_default_to_country_precision_with_no_city
    geolocation = GeoIpCurb.geolocation(IP_GOOGLE_US)
    assert_equal 'US',            geolocation[:country_code]
    assert_equal 'UNITED STATES', geolocation[:country_name]
    assert_nil                    geolocation[:city]
  end

  def test_country_for_public_ip
    geolocation = GeoIpCurb.geolocation(IP_GOOGLE_US)
    assert_equal 'US',            geolocation[:country_code]
    assert_equal 'UNITED STATES', geolocation[:country_name]
  end
  
  def test_country_for_private_ip
    geolocation = GeoIpCurb.geolocation(IP_PRIVATE)
    assert_equal '-',             geolocation[:country_code]
    assert_equal '-',             geolocation[:country_name]
  end
  
  def test_country_for_local_ip
    geolocation = GeoIpCurb.geolocation(IP_LOCAL)
    assert_equal '-',             geolocation[:country_code]
    assert_equal '-',             geolocation[:country_name]
  end
  
  def test_country_precision_returns_no_city
    geolocation = GeoIpCurb.geolocation(IP_GOOGLE_US, {:precision => :country})
    assert_equal 'US',             geolocation[:country_code]
    assert_equal 'UNITED STATES',  geolocation[:country_name]
    assert_nil                     geolocation[:city]
  end
end