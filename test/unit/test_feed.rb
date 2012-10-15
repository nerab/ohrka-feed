require 'helper'

class TestFeed < OhrkaFeedTestCase
  def setup
    @rss = mocked('setup') do
      Channel.new.to_rss
    end
  end

  def test_channel
    refute_nil(@rss)
    refute(@rss.empty?)
    assert_equal(1, xpath('//rss/channel').size)
  end

  def test_item_size
    assert_equal(19, xpath('//rss/channel/item').size)
  end

  private

  def xpath(expr)
    Nokogiri::XML(@rss).xpath(expr)
  end
end
