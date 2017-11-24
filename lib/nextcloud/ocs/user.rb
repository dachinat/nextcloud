module Nextcloud
  module Ocs
    # Class includes User provisioning fetures, including User group operations
    #
    # @!attribute [rw] meta
    #   @return [Hash] Information about API response
    # @!attribute [rw] userid
    #   @return [String,nil] User identifier
    class User < OcsApi
      include Helpers

      attr_accessor :meta, :userid

      # Class initializer
      #
      # @param api [Object] Api instance
      # @param userid [String,nil] User identifier
      def initialize(args, userid = nil)
        @userid = userid if userid

        if args.class == Nextcloud::OcsApi
          @api = args
        else
          super(args)
          @api = self
        end
      end

      # Sets user (useful if class is initiated without OcsApi.user)
      #
      # @param userid [String] User identifier
      # @return [Obeject] self
      def set(userid)
        @userid = userid
        self
      end

      # Retrieve information about an user
      #
      # @param userid [String]
      # @return [Object] User instance
      def find(userid)
        response = @api.request(:get, "users/#{userid}")

        enabled = response.xpath("//data/enabled").text
        id = response.xpath("//data/id").text
        quota = response.xpath("//data/quota/*").each_with_object({}) do |node, quota|
          quota[node.name] = node.text
        end
        email = response.xpath("//data/email").text
        displayname = response.xpath("//data/displayname").text
        phone = response.xpath("//data/phone").text
        address = response.xpath("//data/address").text
        website = response.xpath("//data/website").text
        twitter = response.xpath("//data/twitter").text
        groups = []
        response.xpath("//data/groups/element").each do |prop|
          groups << prop.text
        end

        language = response.xpath("//data/language").text

        user = Nextcloud::Models::User.new(enabled: enabled, id: id, quota: quota, email: email,
                                           displayname: displayname, phone: phone, address: address, website: website,
                                           twitter: twitter, groups: groups, language: language)
        (user.meta = get_meta(response)) && user
      end

      # Retrieve all users
      #
      # @return [Array] List of all users
      def all
        response = @api.request(:get, "users")

        users = [].tap do |users|
          response.xpath("//element").each do |prop|
            id = prop.text
            users << Nextcloud::Models::User.new(id: id)
          end
        end

        meta = get_meta(response)

        users.send(:define_singleton_method, :meta) { meta } && users
      end

      # Add a new user
      #
      # @param userid [String] User identifier
      # @param password [String] User password
      # @return [Object] Instance with meta response
      def create(userid, password)
        response = @api.request(:post, "users", userid: userid, password: password)
        (@meta = get_meta(response)) && self
      end

      # Update a parameter of an user
      #
      # @param userid [String] User identifier
      # @param key [String] Parameter to update. Can be quota, displayname, phone, address, website, twitter or password
      # @param value [String] Value to update to
      # @return [Object] Instance with meta information
      def update(userid, key, value)
        response = @api.request(:put, "users/#{userid}", key: key, value: value)
        (@meta = get_meta(response)) && self
      end

      # Disable an user
      #
      # @param userid [String] User identifier
      # @return [Object] Instance with meta information
      def disable(userid)
        response = @api.request(:put, "users/#{userid}/disable")
        (@meta = get_meta(response)) && self
      end

      # Enable an user
      #
      # @param userid [String] User identifier
      # @return [Object] Instance with meta information
      def enable(userid)
        response = @api.request(:put, "users/#{userid}/enable")
        (@meta = get_meta(response)) && self
      end

      # Remove an user account
      #
      # @param userid [String] User identifier
      # @return [Object] Instance with meta information
      def destroy(userid)
        response = @api.request(:delete, "users/#{userid}")
        (@meta = get_meta(response)) && self
      end

      # Class covering User group operations
      #
      # @!attribute [rw] meta
      #   @return [Hash] Information about API response
      # @!attribute [rw] groupid
      #   @return [String,nil] Group identifier
      class Group < User
        include Helpers

        attr_accessor :userid, :groupid, :meta

        # Initializes an User Group instance
        #
        # @param api [Object] Api instance
        # @param userid [String] User identifier
        # @param groupid [String,nil] Group identifier
        def initialize(api, userid, groupid = nil)
          @api = api
          @userid = userid
          @groupid = groupid if groupid
        end

        # Add an user to a group
        #
        # @param groupid [String] Group to add user to
        # @return [Object] Instance with meta information
        def create(groupid)
          response = @api.request(:post, "users/#{@userid}/groups", groupid: groupid)
          (@meta = get_meta(response)) && self
        end

        # Remove user from a group
        #
        # @param groupid [String] Group to remove user from
        # @return [Object] Instance with meta information
        def destroy(groupid)
          response = @api.request(:delete, "users/#{@userid}/groups", groupid: groupid)
          (@meta = get_meta(response)) && self
        end

        # Make an user subadmin of a group
        #
        # @return [Object] Instance with meta information
        def promote
          response = @api.request(:post, "users/#{@userid}/subadmins", groupid: @groupid)
          (@meta = get_meta(response)) && self
        end

        # Remove an user from group subadmins
        #
        # @return [Object] Instance with meta information
        def demote
          response = @api.request(:delete, "users/#{@userid}/subadmins", groupid: @groupid)
          (@meta = get_meta(response)) && self
        end
      end

      # Initialize a group class
      #
      # @param groupid [String,nil] Group identifier
      def group(groupid = nil)
        Group.new(@api, @userid, groupid)
      end

      # List groups that user belongs to
      #
      # @return [Array] User groups
      def groups
        response = @api.request(:get, "users/#{@userid}/groups")
        parse_with_meta(response, "//data/groups/element")
      end

      # List groups that user sub-admins
      #
      # @return [Array] User sub-admin groups
      def subadmin_groups
        response = @api.request(:get, "users/#{@userid}/subadmins")
        parse_with_meta(response, "//data/element")
      end

      # Resend welcome e-mail letter to a user
      #
      # @param userid [String]
      # @return [Object] Instance with meta information
      def resend_welcome(userid)
        response = @api.request(:post, "users/#{userid}/welcome")
        (@meta = get_meta(response)) && self
      end
    end
  end
end
