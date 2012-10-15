require 'rubygems'
require 'bundler'
Bundler.require

require 'ohrka-feed'

use Rack::CommonLogger
use Rack::ShowExceptions
use Rack::ShowStatus

run Ohrka::Feed::WebApp.new
