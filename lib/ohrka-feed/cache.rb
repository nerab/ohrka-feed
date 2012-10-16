module Ohrka
  module Feed
    class Cache
      def initialize(server, options = {})
        begin
          @backend = Dalli::Client.new(server, options)
          @backend.get('dummy') # provoke connection
        rescue
          STDERR.puts "No memcache service available at #{server.inspect}, falling back to Hash."
          @backend = {}
        end
      end

      #
      # If a block is passed, it will be executed upon cache miss.
      #
      def get(name, &block)
        cached = @backend.get(name)

        if block_given? && cached.nil?
          cached = block.call(name)
          set(name, cached)
        end

        cached
      end

      def set(name, value)
        @backend.set(name, value.respond_to?(:read) ? value.read : value)
      end

      def flush
        @backend.flush
      end
    end
  end
end
