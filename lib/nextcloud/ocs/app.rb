module Nextcloud
  module Ocs
    # Application class used for interfering with app specific actions
    #
    # @!attribute [rw] meta
    #   @return [Hash] Information about API response
    # @!attribute [rw] appid
    #   @return [Integer] Application identifier
    class App < OcsApi
      include Helpers

      attr_accessor :meta, :appid

      # Application initializer
      #
      # @param api [Object] Api instance
      # @param appid [Integer,nil] Application identifier
      def initialize(args, appid = nil)
        @appid = appid if appid

        if args.class == Nextcloud::OcsApi
          @api = args
        else
          super(args)
          @api = self
        end
      end

      # Sets app (useful if class is initiated without OcsApi.app)
      #
      # @param userid [String] User identifier
      # @return [Obeject] self
      def set(appid)
        @appid = appid
        self
      end

      # List enabled applications
      #
      # @return [Array] List of applications that are enabled on an instance
      def enabled
        filter("enabled")
      end

      # List disabled applications
      #
      # @return [Array] List of applications that are disabled on an instance
      def disabled
        filter("disabled")
      end

      # Get information about an applicaiton
      #
      # @param appid [Integer] Application identifier
      # @return [Hash] Application information
      def find(appid)
        response = @api.request(:get, "apps/#{appid}")
        h = doc_to_hash(response, "//data")["data"]
        add_meta(response, h)
      end

      # Enable an application
      #
      # @return [Object] Instance with meta response
      def enable
        response = @api.request(:post, "apps/#{@appid}")
        (@meta = get_meta(response)) && self
      end

      # Disable an application
      #
      # @return [Object] Instance with meta response
      def disable
        response = @api.request(:delete, "apps/#{@appid}")
        (@meta = get_meta(response)) && self
      end

      private

      # Retrieve enabled or disabled applications
      #
      # @param filter [String] Either enabled or disabled
      # @return [Array] List of applications with meta method
      def filter(filter)
        response = @api.request(:get, "apps?filter=#{filter}")
        parse_with_meta(response, "//data/apps/element")
      end
    end
  end
end
