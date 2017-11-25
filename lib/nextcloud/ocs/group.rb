module Nextcloud
  module Ocs
    # Class with Nextcloud group operation features
    #
    # @!attribute [rw] meta
    #   @return [Hash] Information about API response
    # @!attribute [rw] groupid
    #   @return [String,nil] Group identifier
    class Group < OcsApi
      include Helpers

      attr_accessor :meta, :groupid

      # Initializes a class
      #
      # @param api [Object] Api instance
      # @param groupid [String,nil] Group identifier
      def initialize(args, groupid = nil)
        @groupid = groupid if groupid

        if args.class == Nextcloud::OcsApi
          @api = args
        else
          super(args)
          @api = self
        end
      end

      # Sets group (useful if class is initiated without OcsApi.group)
      #
      # @param groupid [String] Group identifier
      # @return [Obeject] self
      def set(groupid)
        @groupid = groupid
        self
      end

      # Search for a group
      #
      # @param str [String] Search query
      # @return [Array] Found groups list
      def search(str)
        response = @api.request(:get, "groups?search=#{str}")
        parse_with_meta(response, "//data/groups/element")
      end

      # List all groups
      #
      # @return [Array] All groups
      def all
        search("")
      end

      # Create a group
      #
      # @param groupid [String] Group identifier
      # @return [Object] Instance with meta information
      def create(groupid)
        response = @api.request(:post, "groups", groupid: groupid)
        (@meta = get_meta(response)) && self
      end

      # Get members of a group
      #
      # @return [Array] List of group members
      def members
        response = @api.request(:get, "groups/#{@groupid}")
        parse_with_meta(response, "//data/users/element")
      end

      # Get sub-admins of a group
      #
      # @return [Array] List of group sub-admins
      def subadmins
        response = @api.request(:get, "groups/#{@groupid}/subadmins")
        parse_with_meta(response, "//data/element")
      end

      # Remove a group
      #
      # @param groupid [String] Group identifier
      # @return [Object] Instance with meta information
      def destroy(groupid)
        response = @api.request(:delete, "groups/#{groupid}")
        (@meta = get_meta(response)) && self
      end
    end
  end
end
