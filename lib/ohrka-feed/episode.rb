module Ohrka
  module Feed
    class Episode < Struct.new(:title, :subtitle, :url, :description, :author, :image_url, :file_size, :uuid, :pub_date, :duration, :keywords)
      class << self
        # Alternative:
        # Start with /hoeren, then fetch //*[@id="next"] as long as it yields results
        def all
          result = [] unless block_given?

          xpath(fetch('eb/hoer-archiv'), "//*[starts-with(@id, 'search_element')]").map{|r| r['id'][/\d+/]}.each do |pid|
            xpath(fetch("eb/hoer-archiv/?show=1&pid=#{pid}"), '//a/@href').each do |episode_path|
              episode = fetch(episode_path)
              player = xpath(episode, '//*[@id="player"]')

              e = Episode.new
              e.title = player.xpath('//*[@id="audioSteuerung"]/h1/text()').to_s
              e.url = normalize(player.xpath('//*[@id="mp3File"]/@href'))

              unless e.url.to_s =~ /\.mp3$/
                STDERR.puts "Skipping #{e.url}"
                next
              end

              e.image_url = normalize(player.xpath('//*[@id="audioSteuerung"]/img/@src'))
              e.duration  = player.xpath('//*[@id="PlayerTime"]/text()').to_s.strip
              e.keywords  = xpath(episode, '//html/head/meta[@name = "keywords"]/@content').first.to_s
              info_urls   = player.xpath('//*[@id="linkInfoLightbox"]/@href')

              if info_urls.any?
                info = JSON.parse(fetch(info_urls.first))
                e.description = Nokogiri::HTML(info['content']).xpath('//p[@class="bodytext"]').to_html
              end

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
          URI('http://www.ohrka.de').merge(URI.escape(path.to_s))
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

      def enclosure
        self.class.cache.get(url) do |key|
          STDERR.puts "Cache miss for enclosure at #{key}"
          Enclosure.new(key)
        end
      end
  	end
  end
end
