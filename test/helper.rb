require 'minitest/autorun'
require 'ohrka-feed'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr'
  c.hook_into :webmock
end

class OhrkaFeedTestCase < MiniTest::Unit::TestCase
  include Ohrka::Feed

  def mocked(cassette, &block)
    VCR.use_cassette("#{self.class.name}_#{cassette}", :record => :new_episodes){block.call}
  end
end
