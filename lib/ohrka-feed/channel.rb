# -*- encoding: utf-8 -*-

module Ohrka
  module Feed  	
  	class Channel
      include ERB::Util # for h() in the ERB template
      TemplateNotFoundError = Class.new(StandardError)

      def initialize
        channel_template = File.join(File.dirname(__FILE__), '..', '..', 'templates', 'ohrka.rss.erb')

        begin
          @erb_template = ERB.new(File.new(channel_template).read, 0, "%<>")
        rescue Errno::ENOENT => e
          raise TemplateNotFoundError.new(e.message)
        end
      end

      def to_rss
        @erb_template.result(binding)
      end

      def episodes
        Episode.all
      end
  	end
  end
end
