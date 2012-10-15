module Ohrka
  module Feed  	
    class Episode < Struct.new(:title, :subtitle, :url, :description, :author, :image_url, :file_size, :uuid, :pub_date, :duration)
      class << self
        def all
          result = [] unless block_given?

          extract_xpath('eb/hoer-archiv', "//*[starts-with(@id, 'search_element')]").map{|r| r['id'][/\d+/]}.each do |pid|
            extract_xpath("eb/hoer-archiv/?show=1&pid=#{pid}", '//a/@href').each do |episode_path|

              player = extract_xpath(episode_path, '//*[@id="player"]')

              e = Episode.new
              e.title = player.xpath('//*[@id="audioSteuerung"]/h1/text()').to_s
              e.url = normalize(player.xpath('//div[3]/p[4]/a/@href'))

              info_urls = player.xpath('//*[@id="linkInfoLightbox"]/@href')

              if info_urls.any?
                json = extract_json(info_urls.first)
                e.description = Nokogiri::HTML(json['content']).xpath('//p[@class="bodytext"]').to_html
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

        private

        def normalize(path)
          "http://www.ohrka.de/#{path}" # TODO Use URI
        end

        def fetch(path)
          open(normalize(path))
        end

        def extract_xpath(path, xpath)
          Nokogiri::HTML(fetch(path)).xpath(xpath)
        end

        def extract_json(path)
          JSON.parse(fetch(path).read)
        end
      end
  	end
  end
end