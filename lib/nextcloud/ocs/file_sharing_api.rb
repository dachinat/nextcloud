module Nextcloud
  module Ocs
    # File sharing base class used for interfering with sharing, included federated
    #
    # @!attribute [rw] meta
    #   @return [Hash] Information about API response
    # @!attribute [rw] shareid
    #   @return [Integer] Share identifier
    class FileSharingApi < OcsApi
      include Helpers

      attr_accessor :meta, :shareid

      # Initializes API with user credentials
      #
      # @param [Hash] args authentication credentials.
      # @option args [String] :url Nextcloud instance URL
      # @option args [String] :username Nextcloud instance user username
      # @option args [String] :password Nextcloud instance user password
      def initialize(args)
        super(args)

        @url = URI(
          @url.scheme + "://" + @url.host + "/ocs/v2.php/apps/files_sharing/api/v1/"
        )
      end

      # Get information about specific share
      #
      # @param shareid [Integer]
      # @return [Hash] Information about share with meta
      def find(shareid)
        response = request(:get, "shares/#{shareid}")
        h = doc_to_hash(response, "//data/element").try(:[], "element")
        add_meta(response, h)
      end

      # Get all shares
      #
      # @return [Array] All shares of authenticated user
      def all
        response = request(:get, "shares")
        h = doc_to_hash(response, "//data").try(:[], "data").try(:[], "element")
        h = [h] if h.class == Hash
        add_meta(response, h)
      end

      # Get shares for a file or directory
      # optionally get shares including re-shares on a resource
      # or get shares for all the files in a directory
      #
      # @param path [String]
      # @param reshares [Boolean,nil]
      # @param subfiles [Boolean,nil]
      # @return [Array] Shares (may include re-shares for a file or directory) of a resource or all reshares of
      #   directory contents
      def specific(path, reshares = nil, subfiles = nil)
        response = request(:get, "shares?path=#{path}&reshares=#{reshares}&subfiles=#{subfiles}")
        h = doc_to_hash(response, "//data").try(:[], "data").try(:[], "element")
        h = [h] if h.class == Hash
        add_meta(response, h)
      end

      # Share an item
      #
      # @param path [String] Path of a file or directory to share
      # @param shareType [Integer] One of four possible values. 0 means an user, 1 means a group, 3 means a public link
      #   6 stands for federated cloud share
      # @param shareWith [String,nil] User or group identifier, can be omitted if shareType is neither 0, nor 1
      # @param publicUpload [Boolean,nil] If true, permits public uploads in directories shared by link
      # @param password [String,nil] Password-protects a share
      # @param permissions [Integer,nil] Sets permissions on a resource. 1 gives read rights, 2 update, 4 create,
      #   8 delete
      #  16 share, 31 all rights. Value should be one of previously listed.
      # @return [Object] Instance including meta response
      def create(path, shareType, shareWith, publicUpload = nil, password = nil, permissions = nil)
        args = local_variables.reduce({}) { |c, i| c[i] = eval(i.to_s); c }
        response = request(:post, "/shares", args)
        (@meta = get_meta(response)) && self
      end

      # Unshare an item
      #
      # @param shareid [Integer] Share ID
      # @return [Object] Instance with meta response
      def destroy(shareid)
        response = request(:delete, "/shares/#{shareid}")
        (@meta = get_meta(response)) && self
      end

      # Update permissions for a resource
      #
      # @param shareid [Integer] Share identifier
      # @param permissions [Integer] Must be one of the following: 1: read, 2: update, 4: create, 8: delete, 16: share,
      #   31: all rights.
      # @return [Object] Instance with meta response
      def update_permissions(shareid, permissions)
        update(shareid, "permissions", permissions)
      end

      # Update a password for a resource
      #
      # @param shareid [Integer] Share identifier
      # @param password [String] Password string
      # @return [Object] Instance with meta response
      def update_password(shareid, password)
        update(shareid, "password", password)
      end

      # Allow or disallow public uploads in a directory
      #
      # @param shareid [Integer] Share identifier
      # @param publicUpload [Boolean] True to permit public uploads in a directory, false to disallow
      # @return [Object] Instance with meta response
      def update_public_upload(shareid, publicUpload)
        update(shareid, "publicUpload", publicUpload)
      end

      # Update resource expiration date
      #
      # @param shareid [Integer] Share identifier
      # @param expireDate [String] Expiration date of a resource. Has to be in format of "YYYY-DD-MM"
      # @return [Object] Instance with meta response
      def update_expire_date(shareid, expireDate)
        update(shareid, "expireDate", expireDate)
      end

      # Wrapper to Federated Cloud Sharing API
      #
      # @!attribute [rw] meta
      #   @return [Hash] Information about API response
      class FederatedCloudShares
        include Helpers

        attr_accessor :meta

        # Creates Federated Cloud Sharing class instance
        #
        # @param api [Object] Api object
        def initialize(api)
          @api = api
        end

        # List accepted Federated Cloud Shares
        #
        # @return [Array] List of accepted Federated Cloud Shares
        def accepted
          response = @api.request(:get, "/remote_shares")
          h = doc_to_hash(response, "//data").try(:[], "data").try(:[], "element")
          h = [h] if h.class == Hash
          add_meta(response, h)
        end

        # List pending requests of Federated Cloud Shares
        #
        # @return [Array] List of pending Federated Cloud Shares
        def pending
          response = @api.request(:get, "/remote_shares/pending")
          h = doc_to_hash(response, "//data").try(:[], "data").try(:[], "element")
          h = [h] if h.class == Hash
          add_meta(response, h)
        end

        # Accept a request of a Federated Cloud Share
        #
        # @param shareid [Integer] Federated Cloud Share identifier
        # @return [Object] Instance with meta response
        def accept(shareid)
          response = @api.request(:post, "/remote_shares/pending/#{shareid}")
          (@meta = get_meta(response)) && self
        end

        # Decline a request of a Federated Cloud Share
        #
        # @param shareid [Integer] Federated Cloud Share identifier
        # @return [Object] Instance with meta response
        def decline(shareid)
          response = @api.request(:delete, "/remote_shares/pending/#{shareid}")
          (@meta = get_meta(response)) && self
        end

        # Delete an accepted Federated Cloud Share
        #
        # @param shareid [Integer] Federated Cloud Share identifier
        # @return [Object] Instance with meta response
        def destroy(shareid)
          response = @api.request(:delete, "/remote_shares/#{shareid}")
          (@meta = get_meta(response)) && self
        end

        # Information about accepted Federated Cloud Share
        #
        # @param shareid [Integer] Federated Cloud Share identifier
        # @return [Hash] Information about Federated Cloud Share with meta response
        def find(shareid)
          response = @api.request(:get, "/remote_shares/#{shareid}")
          h = doc_to_hash(response, "//data").try(:[], "data")
          add_meta(response, h)
        end
      end

      # Initiates a Federated Cloud Sharing class
      def federated
        FederatedCloudShares.new(self)
      end

      private

      # Update a resource
      #
      # @param shareid [Integer] Share identifier
      # @param key [String] Option to update
      # @param value [String] Setting to update to
      # @return [Object] Instance with meta information
      def update(shareid, key, value)
        response = request(:put, "/shares/#{shareid}", "#{key}": value)
        (@meta = get_meta(response)) && self
      end
    end
  end
end
