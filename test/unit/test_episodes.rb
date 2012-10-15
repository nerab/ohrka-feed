require 'helper'

class TestEpisodes < OhrkaFeedTestCase
  def setup
    @episodes = mocked('setup') do
      Episode.all
    end
  end

  def test_size
    assert_equal(19, @episodes.count)
  end

  def test_streaming
  	count = 0

	mocked('setup') do
      Episode.all do |e|
      	count += 1
      end
    end 

    assert_equal(19, count)
  end
end
