# -*- encoding: utf-8 -*-
require 'helper'

class TestEnclosure < OhrkaFeedTestCase
  def setup
    @enclosure = mocked('setup') do
      Enclosure.new('http://www.ohrka.de/fileadmin/audio/Helme%20Heine/HH%20Website.mp3')
    end

    refute_nil(@enclosure)
  end

  def test_size
    assert_equal(1828176, @enclosure.size)
  end

  def test_date
    assert_equal('Thu, 28 Jun 2012 12:29:42 +0000', @enclosure.date.rfc2822)
  end

  def test_uuid
    assert_equal('188800a-1be550-4c3877c677980', @enclosure.uuid)
  end

  def test_type
    assert_equal('audio/mpeg', @enclosure.type)
  end
end
