require "net-http-report"

module Nextcloud
  module Webdav
    #
    # Class for communicating with Tag mgmt. service
    #
    class TagRelations < Tags
      include Helpers
      include Properties

      # Remote end of Tags API
      TAGS_RELATIONS_URL = "/systemtags-relations".freeze

      # Class initializer
      # Can be initialized with WebdavApi's tag method or with Nextcloud::Webdav::Tag.new(...credentials...)
      #
      # @param api Instance of Api
      def initialize(api, scope, id)
        @api = api
        @path = "#{TAGS_RELATIONS_URL}/#{scope}/#{id}"
      end

      # List tags assigned to file
      # ==> inherited from Tags

      undef_method :create

      # Add tag to file
      #
      # @param tag_id [Integer] id of a tag
      # @return [Hash] Returns status
      def add(tag_id)
        response = @api.request(:put, "#{@path}/#{tag_id}", nil, "{}")
        parse_dav_response(response)
      end

      # Delete a tag
      #
      # @param tag_id [Integer] id of a tag
      # @return [Hash] Returns status
      alias remove destroy

    end
  end
end
