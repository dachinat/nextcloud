module Nextcloud
  module Ocs
    # Group Folder class used for interfering with group folders
    #
    # @!attribute [rw] meta
    #   @return [Hash] Information about API response
    class GroupFolder < OcsApi
      include Helpers

      attr_accessor :meta

      # Application initializer
      #
      # @param [Hash] args authentication credentials.
      # @option args [String] :url Nextcloud instance URL
      # @option args [String] :username Nextcloud instance user username
      # @option args [String] :password Nextcloud instance user password
      def initialize(args)
        super(args)

        @url = URI(
          @url.scheme + "://" + @url.host + "/apps/groupfolders/"
        )
      end

      # List all folders
      #
      # @return [Array] All group folders
      def folders
        response = request(:get, "folders")
        h = doc_to_hash(response, "//data").try(:[], "data").try(:[], "element")
        h = [h] if h.class == Hash
        add_meta(response, h)
      end

      # Return ID of folder given by name
      #
      # @param name [String] Folder name
      # @return [Integer] Folder ID
      def get_folder_id(name)
        response = request(:get, "folders")
        h = doc_to_hash(response, "//data").try(:[], "data").try(:[], "element")
        group = h.select {|folder| folder["mount_point"] == name }&.first
        unless group.nil?
          return group['id']
        end
      end

      # Get information about a group folder
      #
      # @param folderid [Integer]
      # @return [Hash] Information about a group folder
      def find(folderid)
        response = request(:get, "folders/#{folderid}")
        h = doc_to_hash(response, "//data").try(:[], "data")
        add_meta(response, h)
      end

      # Create a group folder
      #
      # @param mountpoint [String] Mountpoint
      # @return [Hash] Hash with created group folder
      def create(mountpoint)
        args = local_variables.reduce({}) { |c, i| c[i] = binding.local_variable_get(i); c }
        response = request(:post, "folders", args)
        h = doc_to_hash(response, "//data").try(:[], "data")
        add_meta(response, h)
      end

      # Destroy a group folder
      #
      # @param mountpoint [String] Mountpoint
      # @return [Bool] True on success
      def destroy(folderid)
        response = request(:delete, "folders/#{folderid}")
        h = doc_to_hash(response, "//data").try(:[], "data")
        return h == '1'
      end

      # Give a group access to a folder
      #
      # @param folderid [Integer] FolderId to modify
      # @param group [String] Group which should get access to the folder
      # @return [Bool] True on success
      def give_access(folderid, group)
        args = local_variables.reduce({}) { |c, i| c[i] = binding.local_variable_get(i); c }
        response = request(:post, "folders/#{folderid}/groups", args)
        h = doc_to_hash(response, "//data").try(:[], "data")
        return h == '1'
      end

      # Remove access from a group to a folder
      # @param folderid [Integer] FolderId to modify
      # @param group [String] Group which should be removed to get access to the folder
      # @return [Bool] True on success
      def remove_access(folderid, group)
        response = request(:delete, "folders/#{folderid}/groups/#{group}")
        h = doc_to_hash(response, "//data").try(:[], "data")
        return h == '1'
      end

      # Set the permissions a group has in a folder
      #	  PERMISSION_CREATE = 4;
      #   PERMISSION_READ = 1;
      #   PERMISSION_UPDATE = 2;
      #   PERMISSION_DELETE = 8;
      #   PERMISSION_SHARE = 16;
	    #   PERMISSION_ALL = 31;
      #
      # @param folderid [Integer] FolderId to modify
      # @param group [String] Group for which the permissions should be changed
      # @param permissions [String] The new permissions for the group as bitmask of permissions constants
      # @return [Bool] True on success
      def set_permissions(folderid, group, permissions)
        args = local_variables.reduce({}) { |c, i| c[i] = binding.local_variable_get(i); c }
        response = request(:post, "folders/#{folderid}/groups/#{group}", args)
        h = doc_to_hash(response, "//data").try(:[], "data")
        return h == '1'
      end

      # Set the quota for a folder
      #
      # @param folderid [Integer] FolderId to modify
      # @param quota [Integer] The new quota for the folder in bytes, use -3 for unlimited 
      # @return [Bool] True on success
      def set_quota(folderid, quota)
        args = local_variables.reduce({}) { |c, i| c[i] = binding.local_variable_get(i); c }
        response = request(:post, "folders/#{folderid}/quota", args)
        h = doc_to_hash(response, "//data").try(:[], "data")
        return h == '1'
      end

      # Change the name of a folder
      #
      # @param folderid [Integer] FolderId to modify
      # @param mountpoint [String] The new folder name
      # @return [Bool] True on success
      def rename_folder(folderid, mountpoint)
        args = local_variables.reduce({}) { |c, i| c[i] = binding.local_variable_get(i); c }
        response = request(:post, "folders/#{folderid}/mountpoint", args)
        h = doc_to_hash(response, "//data").try(:[], "data")
        return h == '1'
      end
    end
  end
end
