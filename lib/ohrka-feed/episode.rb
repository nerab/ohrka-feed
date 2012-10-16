module Ohrka
  module Feed
    class Episode < Struct.new(:title, :subtitle, :url, :description, :author, :image_url, :file_size, :uuid, :pub_date, :duration)
      class << self
        # Alternative:
        # Start with /hoeren, then fetch //*[@id="next"] as long as it yields results
        def all
          result = [] unless block_given?

          xpath(fetch('eb/hoer-archiv'), "//*[starts-with(@id, 'search_element')]").map{|r| r['id'][/\d+/]}.each do |pid|
            xpath(fetch("eb/hoer-archiv/?show=1&pid=#{pid}"), '//a/@href').each do |episode_path|
              player = xpath(fetch(episode_path), '//*[@id="player"]')

              e = Episode.new
              e.title = player.xpath('//*[@id="audioSteuerung"]/h1/text()').to_s
              e.url = normalize(player.xpath('//div[3]/p[4]/a/@href'))

              info_urls = player.xpath('//*[@id="linkInfoLightbox"]/@href')

              if info_urls.any?
                info = JSON.parse(fetch(info_urls.first))
                e.description = Nokogiri::HTML(info['content']).xpath('//p[@class="bodytext"]').to_html
              end

              e.pub_date = Time.now

              if block_given?
                yield e
              else
                result << e
              end
            end
          end
          result unless block_given?
        end

        def cache
          @cache ||= Cache.new(nil, :expires_in => 15 * 60)
        end

        private

        def normalize(path)
          URI('http://www.ohrka.de').merge(path.to_s)
        end

        def fetch(path)
          cache.get(normalize(path)) do |key|
            STDERR.puts "Cache miss for #{key}"
            open(key).read
          end
        end

        def xpath(html, xpath)
          Nokogiri::HTML(html).xpath(xpath)
        end
      end
  	end
  end
end
