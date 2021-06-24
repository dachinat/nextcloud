module Nextcloud
  class OcsApi < Api
    include Helpers
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

    def generate_app_password
      tmp_url = @url
      @url = URI(@url.scheme + "://" + @url.host + "/ocs/v2.php/core/")
      response = request(:get, "getapppassword")
      meta = get_meta(response)

      @url = tmp_url

      if meta && meta['statuscode'] && meta['statuscode'] == "200"
        return "#{response.xpath('//data/apppassword/text()')}"
      else
        throw "Error while getting app password : #{meta['message'] || 'unkown'}"
      end
    end

    # Initiates Group Folder class
    #
    # @return [Object] Group Folder instance
    def group_folder
      Ocs::GroupFolder.new(url: @url, username: @username, password: @password)
    end

    def status
      get_meta(request(:get, "users/#{@username}"))
    end
  end
end
