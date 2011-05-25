## 0.4.0

* Changed the API used from v2 to v3.
* Dropped support for requesting a timezone as the v3 API does not support this.
  This also means the attributes timezone_name, utc_offset and dst are no longer
  available.
* Modified the tests to support the new API.
* Any service errors now result in the status attribute being set to ERROR with
  status_message containing the error message.
* Switched from Rspec to Test::Unit.
* Added a rake task to run all unit tests.

## 0.3.2

* Renamed gem to GeoIpCurb to allow release alongside the existing GeoIp gem after agreeing this with the original author.
* Replaced Net::HTTP with Curb which handles DNS failure timeouts better.
* Added a timeout option to be passed when calling geolocation.
* Handle service failures gracefully.
* Added a test to ensure error handling of service failures works.

## 0.3.1

* Switches to bundler for gem deployment
* Uses Rspec 2.x from now on

## 0.3.0

* Added support for API key requirement (Thanks to seanconaty and luigi)
* Explicit gem dependency for json and removed rubygems requirement (idris) (http://tomayko.com/writings/require-rubygems-antipattern)
* Removed deprecated GeoIpCurb#remote_geolocation method

## 0.2.0

* Added support for timezone information. Use the optional {:timezone => true|false} option
* Added support for country lookup. This will result in a faster reply since less queries need
  to be done at ipinfodb's side. Use the optional {:precision => :city|:country} option
* API change: GeoIpCurb.remote_geolocation(ip) is deprecated in favor of GeoIpCurb.geolocation(ip)

## 0.1.1

* Removed time zone information since this has been deprecated with the service

## 0.1.0

* Initial commit
