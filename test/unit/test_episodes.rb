require 'helper'

class TestEpisodes < OhrkaFeedTestCase
  def setup
    @episodes = mocked('setup') do
      Episode.all
    end
  end

  def test_size
    assert_equal(194, @episodes.count)
  end
end
