require 'helper'

class TestCache < MiniTest::Unit::TestCase
  include Ohrka::Feed

  def setup
    @cache = Cache.new(nil, :expires_in => 5)
  end

  def test_get_block
    assert_equal('foobar', @cache.get('foo'){|key| "#{key}bar"})
    assert_equal('foobar', @cache.get('foo'))
  end

  def test_get
    refute(@cache.get('foo'))
  end

  def test_set
    refute(@cache.get('bar'))
    @cache.set('bar', 'foot')
    assert_equal('foot', @cache.get('bar'))
  end

  def test_block_precedence
    @cache.set('foot', 'something')
    assert_equal('foobaz', @cache.get('foot'){|key| 'foobaz'})
    assert_equal('foobaz', @cache.get('foot'))
  end

  def test_block_precedence_nil
    @cache.set('footz', 'something')
    refute(@cache.get('footz'){})
  end
end
