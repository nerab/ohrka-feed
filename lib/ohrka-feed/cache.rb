module Ohrka
  module Feed
    class Cache
      def initialize(server, options = {})
        begin
          @backend = Dalli::Client.new(server, options)
          @backend.flush # provoke connection
        rescue
          STDERR.puts "No memcache service available at #{server.inspect}, falling back to Hash."
          @backend = {}
        end
      end

      def get(name, &block)
        set(name, block.call(name)) if block_given?
        @backend.get(name)
      end

      def set(name, value)
        @backend.set(name, value)
      end
    end
  end
end
