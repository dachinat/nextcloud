require "net-http-report"

module Nextcloud
  module Webdav
    #
    # Class for communicating with Tag mgmt. service
    #
    class Tags
      include Helpers
      include Properties

      # Remote end of Tags API
      TAGS_URL = "/systemtags".freeze

      # Initializes a Tags API
      #
      # @params args [Hash] Hash with url, username and password
      def initialize(api)
        @api = api
        @path = TAGS_URL
      end

      # List system tags
      #
      # @return [Object,Hash] Hash of error or instance of Tag model class
      def list()
        response = @api.request(:propfind, @path, nil, TAG)
        (has_dav_errors(response)) ? has_dav_errors(response) : build_result(response)
      end

      # Create a tag
      #
      # @param display_name [String] display name of tag
      # @param user_visible [Boolean] is user visible or not
      # @param user_assignable [Boolean] is user assignable or not
      # @return [Hash] Returns status
      def create(display_name, user_visible, user_assignable)
        body = {name: display_name, userVisible: user_visible, userAssignable: user_assignable}.to_json
        response = @api.request(:post, @path, nil, body, nil, nil, false, 'application/json')
        parse_dav_response(response)
      end

      # Delete a tag
      #
      # @param tag_id [Integer] id of a tag
      # @return [Hash] Returns status
      def destroy(tag_id)
        response = @api.request(:delete, "#{@path}/#{tag_id}")
        parse_dav_response(response)
      end

      def file(fileid)
        Webdav::TagRelations.new(@api, 'files', fileid)
      end

      private

      # Parses as turns tag response to array of model objects
      #
      # @param response [Object] Nokogiri::XML::Document
      # @param skip_first [Boolean] Skip or not first element
      # @return [Object,Array] Returns Object if first element not skipped, array otherwise
      def build_result(response, skip_first = true)
        response = doc_to_hash(response).try(:[], "multistatus").try(:[], "response")
        response = [response] if response.is_a? Hash

        return [] if response.nil?

        start_index = skip_first ? 1 : 0
        result = []
        response[start_index..-1].each do |h|

          prop = h["propstat"].try(:[], 0).try(:[], "prop") || h["propstat"]["prop"]

          params = {
              href: h["href"],
              display_name: prop["display_name"],
              user_visible: prop["user_visible"] == "false" ? false : true,
              user_assignable: prop["user_assignable"] == "false" ? false : true,
              id: prop["id"],
          }
          result << Models::Tag.new(params.merge(skip_contents: true))
        end
        return result
      end
    end
  end
end
