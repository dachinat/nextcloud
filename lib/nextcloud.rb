require "net/https"
require "nokogiri"

require "nextcloud/version/nextcloud"
require "nextcloud/errors/nextcloud"

require "nextcloud/helpers/nextcloud"
require "nextcloud/helpers/properties"

require "nextcloud/api"

require "nextcloud/ocs_api"
require "nextcloud/ocs/user"
require "nextcloud/ocs/group"
require "nextcloud/ocs/app"
require "nextcloud/ocs/file_sharing_api"

require "nextcloud/webdav_api"
require "nextcloud/webdav/directory"

require "nextcloud/models/user"
require "nextcloud/models/directory"

# Namespace for Nextcloud OCS API communication
module Nextcloud
  class << self
    # Access to OCS API from base instance
    #
    # @param [Hash] args authentication credentials.
    # @option args [String] :url Nextcloud instance URL
    # @option args [String] :username Nextcloud instance administrator username
    # @option args [String] :password Nextcloud instance administrator password
    def ocs(args)
      OcsApi.new(args)
    end

    # Access to WebDAV API from base instance
    #
    # @param [Hash] args authentication credentials.
    # @option args [String] :url Nextcloud instance URL
    # @option args [String] :username Nextcloud instance administrator username
    # @option args [String] :password Nextcloud instance administrator password
    def webdav(args)
      WebdavApi.new(args)
    end
  end
end
