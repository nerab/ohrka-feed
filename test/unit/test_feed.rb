require 'helper'

class TestFeed < OhrkaFeedTestCase
  def test_feed
    mocked('test_feed') do
      ch = Channel.new
      rss = ch.to_rss
      refute_nil(rss)
      refute(rss.empty?)
      assert_equal('', rss)
    end
  end
end