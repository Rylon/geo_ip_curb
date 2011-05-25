require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :development

require 'test/unit'
require 'geo_ip_curb'

IP_GOOGLE_US = '209.85.227.104'
IP_PRIVATE = '10.0.0.1'
IP_LOCAL = '127.0.0.1'