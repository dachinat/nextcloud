require "net-http-report"

module Nextcloud
  module Webdav
    # WebDAV class for communicating with Tag mgmt. service
    #
    # @!attribute [rw] tag
    #   @return [Array] Used to store model instances when querying with find or favorites
    class Tag < WebdavApi
      include Helpers
      include Properties

      attr_accessor :tag

      # Class initializer
      # Can be initialized with WebdavApi's tag method or with Nextcloud::Webdav::Tag.new(...credentials...)
      #
      # @param args [Object,Hash] Can be instance of Api or credentials list (url, username, password)
      def initialize(args)
        if args.class == Nextcloud::WebdavApi
          @api = args
        else
          super
          @api = self
        end

        @path = "/systemtags"
      end

      # List system tags
      #
      # @return [Object,Hash] Hash of error or instance of Tag model class
      def list()
        response = @api.request(:propfind, @path, nil, TAG)
        (has_dav_errors(response)) ? has_dav_errors(response) : tag(response)
      end

      private

      # Parses as turns tag response to model object
      #
      # @param response [Object] Nokogiri::XML::Document
      # @param skip_first [Boolean] Skip or not first element
      # @return [Object,Array] Returns Object if first element not skipped, array otherwise
      def tag(response, skip_first = true)
        response = doc_to_hash(response).try(:[], "multistatus").try(:[], "response")
        response = [response] if response.is_a? Hash

        return [] if response.nil?

        response.each_with_index do |h, index|

          prop = h["propstat"].try(:[], 0).try(:[], "prop") || h["propstat"]["prop"]

          params = {
              href: h["href"],
              display_name: prop["display_name"],
              user_visible: prop["user_visible"] == "false" ? false : true,
              user_assignable: prop["user_assignable"] == "false" ? false : true,
              id: prop["id"],
          }

          if skip_first
            if index == 0
              @tag = Models::Tag.new(params)
            else
              @tag.add(params)
            end
          else
            @tag = [] if @tag.nil?
            @tag << Models::Tag.new(params.merge(skip_contents: true))
          end
        end
        @tag
      end
    end
  end
end
