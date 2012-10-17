# -*- encoding: utf-8 -*-
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

  def test_items_size
    assert_equal(19, xpath('//rss/channel/item').size)
  end

  def test_item_14
    assert_equal('Axel Hacke liest: "Weitermachen!"', title(14))
    assert_equal('http://www.ohrka.de/uploads/media/pl_zahnbuerste_02.png', image_url(14))
    assert_equal('5406720', enclosure(14)['length'])
    assert_equal('http://www.ohrka.de/fileadmin/audio/Axel%20Hacke.mp3', enclosure(14)['url'])
    assert_equal('audio/mpeg', enclosure(14)['type'])
    assert_equal('00:05:00', duration(14))
  end

  def test_item_3
    assert_equal('Ole Goldfuß', title(3))
    assert_equal('http://www.ohrka.de/uploads/media/pl_goldfuss2_01.png', image_url(3))
  end

  def test_item_8
    assert(keywords(1) =~ /^(?=.*anke)(?=.*engelke)(?=.*dschungelbuch).*/)
  end

  private

  def xpath(expr, node = @rss)
    Nokogiri::XML(node).xpath(expr)
  end

  def item(i)
    xpath("//rss/channel/item[#{i}]")
  end

  def title(i)
    item(i).xpath('title/text()').first.to_s
  end

  def image_url(i)
    item(i).xpath('itunes:image/@href').first.to_s
  end

  def enclosure(i)
    enclosure = item(i).xpath('enclosure').first
  end

  def duration(i)
    item(i).xpath('itunes:duration/text()').first.to_s
  end

  def keywords(i)
    item(i).xpath('itunes:keywords/text()').first.to_s
  end
end
