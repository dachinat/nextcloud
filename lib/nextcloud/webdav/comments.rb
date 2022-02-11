require "net-http-report"

module Nextcloud
  module Webdav
    #
    # Class for communicating with Comments API
    #
    class Comments
      include Helpers
      include Properties

      # Remote end of Tags API
      COMMENTS_URL = "/comments".freeze

      # Initializes a Tags API
      #
      # @params args [Hash] Hash with url, username and password
      def initialize(api, scope)
        @api = api
        @scope = scope
        @path = "#{COMMENTS_URL}/#{scope}"
      end

      # List system tags
      #
      # @return [Object,Hash] Hash of error or instance of Tag model class
      def list(id)
        response = @api.request(:report, "#{@path}/#{id}", nil, COMMENT)
        (has_dav_errors(response)) ? has_dav_errors(response) : build_result(response)
      end

      # Add comment
      #
      # @param id [Integer] the object ID to add comment to
      # @param message [String] the comment message
      # @return [Hash] Returns status
      def add(id, message)
        body = {
          actorId: @api.username,
          actorType: "users",
          message: message,
          objectType: @scope,
          verb: "comment"
        }.to_json
        response = @api.request(:post, "#{@path}/#{id}", nil, body, nil, nil, false, 'application/json')
        parse_dav_response(response)
      end

      # Modify comment
      #
      # @param id [Integer] the object ID to modify comment on
      # @param comment_id [Integer] id of comment to modify
      # @param message [String] the new comment message
      # @return [Hash] Returns status
      def modify(id, comment_id, message)
        response = @api.request(:proppatch, "#{@path}/#{id}/#{comment_id}", nil, MODIFY_COMMENT(message)) #, nil, nil, false, 'application/json')
        parse_dav_response(response)
      end

      # Delete a tag
      #
      # @param id [Integer] the object ID to remove comment from
      # @param tag_id [Integer] id of comment to remove
      # @return [Hash] Returns status
      def remove(id, comment_id)
        response = @api.request(:delete, "#{@path}/#{id}/#{comment_id}")
        parse_dav_response(response)
      end

      private

      # Parses as turns comment response to array of model objects
      #
      # @param response [Object] Nokogiri::XML::Document
      # @param skip_first [Boolean] Skip or not first element
      # @return [Array] Returns array of models
      def build_result(response, skip_first = false)
        response = doc_to_hash(response).try(:[], "multistatus").try(:[], "response")
        response = [response] if response.is_a? Hash

        return [] if response.nil?

        start_index = skip_first ? 1 : 0
        result = []
        response[start_index..-1].each do |h|

          prop = h["propstat"].try(:[], 0).try(:[], "prop") || h["propstat"]["prop"]

          params = {
              href: h["href"],
              id: prop["id"],
              parent_id: prop["parentId"],
              topmost_parent_id:  prop["topmostParentId"],
              children_count:  prop["childrenCount"],
              verb:  prop["verb"],
              actor_type:  prop["actorType"],
              actor_id:  prop["actorId"],
              creation_datetime:  prop["creationDateTime"],
              latest_child_datetime:  prop["latestChildDateTime"],
              object_type:  prop["objectType"],
              object_id:  prop["objectId"],
              message:  prop["message"],
              actor_display_name:  prop["actorDisplayName"],
              is_unread:  prop["isUnread"] == "false" ? false : true,
              mentions:  prop["mentions"],
              skip_contents: false
          }
          result << Models::Comment.new(params.merge(skip_contents: true))
        end
        return result
      end
    end
  end
end
