require 'net/http'

module Ohrka
  module Feed
    class Enclosure < Struct.new(:date, :uuid, :size, :type)
      # Use a head request to fetch the following mapped data:
      #
      # date => Last-Modified: Thu, 28 Jun 2012 12:29:42 GMT
      # uuid => ETag: "188800a-1be550-4c3877c677980"
      # size => Content-Length: 1828176
      # type => Content-Type: audio/mpeg
      def initialize(url)
        uri = URI(url)

        Net::HTTP.start(uri.host, uri.port) do |http|
          STDERR.puts "Fetching headers for #{uri}"
          headers = http.head(uri.request_uri)

          if headers['Last-Modified']
            self.date = DateTime.parse(headers['Last-Modified'])
          else
            STDERR.puts "Warning: No 'Last-Modified' header found for #{uri}"
            self.date = DateTime.now
          end

          if headers['ETag']
            self.uuid = headers['ETag'][/\"(.*)\"/,1]
          else
            STDERR.puts "Warning: No 'ETag' header found for #{uri}"
            self.uuid = SecureRandom.uuid
          end

          self.size = headers['Content-Length'].to_i
          self.type = headers['Content-Type']
        end
      end
    end
  end
end
