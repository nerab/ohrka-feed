# -*- encoding: utf-8 -*-

module Ohrka
  module Feed
    class WebApp
      def call(env)
        channel = Channel.new

        [ 200,
          {
            'Content-Type'  => 'application/rss+xml',
            'Last-Modified' => channel.episodes.first.enclosure.date.rfc2822
          },
          [channel.to_rss]
        ]
      end
    end
  end
end
