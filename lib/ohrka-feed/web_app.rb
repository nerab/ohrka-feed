# -*- encoding: utf-8 -*-

module Ohrka
  module Feed
    class WebApp
      def call(env)
        [ 200,
          {"Content-Type" => 'application/rss+xml'},
          [Channel.new.to_rss]
        ]
      end
    end
  end
end
