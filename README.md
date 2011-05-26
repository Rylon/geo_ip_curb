# GeoIpCurb

Retrieve the geolocation of an IP address using the [ipinfodb.com](http://ipinfodb.com/) v3 API service using Curb.

As of 8th November 2010, the service is asking that all users [register](http://ipinfodb.com/register.php) for an API key.

Consider making a donation to [ipinfodb.com](http://ipinfodb.com/) at [http://ipinfodb.com/donate.php](http://ipinfodb.com/donate.php).

## Usage

### Set API key
    GeoIpCurb.api_key = "YOUR_API_KEY"

This must be done before making the geolocation call.

### Retrieve geolocation
    GeoIpCurb.geolocation(ip_address)

### Example

    # 209.85.227.104 = google.be (US)
    GeoIpCurb.geolocation('209.85.227.104')

returns:

    {
      :status           =>"OK", 
      :status_message   =>"", 
      :country_code     =>"US", 
      :ip               =>"209.85.227.104", 
      :country_name     =>"UNITED STATES"
    }

### Additional details

There is an option to only retrieve additional information about the city and the timezone. This results in a slower response from the service since more queries need to be done.

    GeoIpCurb.geolocation('209.85.227.104', {:precision => :city})

returns:

    {
      :utc_offset       =>"-08:00", 
      :status           =>"OK", 
      :zip_postal_code  =>"91754", 
      :latitude         =>"34.0505", 
      :status_message   =>"", 
      :longitude        =>"-118.13", 
      :country_code     =>"US", 
      :ip               =>"209.85.227.104", 
      :city             =>"MONTEREY PARK", 
      :country_name     =>"UNITED STATES", 
      :region_name      =>"CALIFORNIA"
    }

### Timeout

It is possible to set a timeout for all requests. By default it is ten seconds, but you can easily set a different value by passing a timeout option:

    GeoIpCurb.geolocation('209.85.227.104', {:timeout => 5}) 

### Reserved / Private / Local IPs

Passing reserved, private or local IPs, such as 127.0.0.1 will return '-' for all location data, for example:

    GeoIpCurb.geolocation('127.0.0.1')

returns:

    {
      :status_message   =>"", 
      :status           =>"OK",
      :ip               =>"127.0.0.1",
      :country_code     =>"-",
      :country_name     =>"-",
    }

### Errors

Any errors received when calling the API will result in the :status and :status_message attributes being set with relevant information, for example, in the case of service failure:

    GeoIpCurb.geolocation('209.85.227.104')

returns:

    {
      :status_message   =>"api.ipinfodb.com service error: \"Couldn't connect to server\".", 
      :status           =>"ERROR",
      :ip               =>nil,
      :country_code     =>nil,
      :country_name     =>nil,
    }

## Getting it

GeoIpCurb can be installed as a Ruby Gem:

    gem install geo_ip_curb

### Rails

#### Bundler enabled (Rails 3.0.x and 2.3.x)

In your Gemfile:

    gem 'geo_ip_curb', '~> 0.3.2'

Then create an initializer `config/initializers/geo_ip` (or name it whatever you want):

    GeoIpCurb.api_key = "YOUR_API_KEY"

#### Pre-bundler (Rails 2.3.x or older)

In your `config/environment.rb`:

    config.gem 'geo_ip', :version => '~> 0.3.2'

Then create an initializer `config/initializers/geo_ip` (or name it whatever you want):

    GeoIpCurb.api_key = "YOUR_API_KEY"

## Testing

Set up your API key first for the test suite by creating a tests/api.yml file. Follow the example in tests/api.yml.example. Then run the tests with:

    rake test:units

## Contributors

This project was originally based on the GeoIP gem written by [jeroenj](https://github.com/jeroenj/geo_ip).

* [jeroenj](https://github.com/jeroenj)
* [seanconaty](https://github.com/seanconaty)
* [luigi](https://github.com/luigi)
* [idris](https://github.com/idris)

## Bugs

Please report them on the [Github issue tracker](https://github.com/rylon/geo_ip_curb/issues)
for this project.

If you have a bug to report, please include the following information:

* **Version information for your environment, for example, Rails, Ruby and RubyGems.**
* Stack trace and error message.

You may also fork this project on Github and create a pull request.
Do not forget to include tests.

## Copyright

Copyright (c) 2010-2011 Ryan Conway. See LICENSE for details.