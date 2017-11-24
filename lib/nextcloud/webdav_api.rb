module Nextcloud
  class WebdavApi < Api
    # Remote end of WebDAV API
    DAV_URL = "remote.php/dav".freeze

    # Initializes a WebDAV API
    #
    # @params args [Hash] Hash with url, username and password
    def initialize(args)
      super
      @url = URI(@url.scheme + "://" + @url.host + "/" + DAV_URL)
    end

    # Initiates WebDAV Directory class
    #
    # @return [Object] WebDAV Directory instance
    def directory
      Webdav::Directory.new(self)
    end
  end
end
