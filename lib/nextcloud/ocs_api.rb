module Nextcloud
  class OcsApi < Api
    # Initiates User class
    #
    # @param userid [Ingteger,nil] Nextcloud user userid
    # @return [Object] User instance
    def user(userid = nil)
      Ocs::User.new(self, userid)
    end

    # Initiates Group class
    #
    # @param groupid [Ingteger,nil] Nextcloud group groupid
    # @return [Object] Group instance
    def group(groupid = nil)
      Ocs::Group.new(self, groupid)
    end

    # Initiates App class
    #
    # @param appid [Ingteger,nil] Nextcloud app appid
    # @return [Object] Application instance
    def app(appid = nil)
      Ocs::App.new(self, appid)
    end

    # Initiates File Sharing class
    #
    # @return [Object] File Sharing instance
    def file_sharing
      Ocs::FileSharingApi.new(url: @url, username: @username, password: @password)
    end
  end
end
