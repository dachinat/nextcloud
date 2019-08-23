module Nextcloud
  class Api
    attr_reader :url, :username, :password
    protected :url
    protected :username
    protected :password

    # Gathers credentials for communicating with Nextcloud instance
    #
    # @param [Hash] args authentication credentials.
    # @option args [String] :url Nextcloud instance URL
    # @option args [String] :username Nextcloud instance administrator username
    # @option args [String] :password Nextcloud instance administrator password
    def initialize(args)
      @url = URI(args[:url] + "/ocs/v2.php/cloud/")
      @username = args[:username]
      @password = args[:password]
    end

    # Sends API request to Nextcloud
    #
    # @param method [Symbol] Request type. Can be :get, :post, :put, etc.
    # @param path [String] Nextcloud OCS API request path
    # @param params [Hash, nil] Parameters to send
    # @return [Object] Nokogiri::XML::Document
    def request(method, path, params = nil, body = nil, depth = nil, destination = nil, raw = false, json_request = false)
      response = Net::HTTP.start(@url.host, @url.port,
        use_ssl: @url.scheme == "https") do |http|
        req = Kernel.const_get("Net::HTTP::#{method.capitalize}").new(@url.request_uri + path)
        req["OCS-APIRequest"] = true
        req.basic_auth @username, @password
        req["Content-Type"] = json_request ? "application/json" : "application/x-www-form-urlencoded"

        req["Depth"] = 0 if depth
        req["Destination"] = destination if destination

        req.set_form_data(params) if params
        req.body = body if body

        http.request(req)
      end

      # if ![201, 204, 207].include? response.code
      #   raise Errors::Error.new("Nextcloud received invalid status code")
      # end
      raw ? response.body : Nokogiri::XML.parse(response.body)
    end

    # Creates Ocs API instance
    #
    # @return [Object] OcsApi
    def ocs
      OcsApi.new(url: @url, username: @username, password: @password)
    end

    # Create WebDav API instance
    #
    # @return [Object] WebdavApi
    def webdav
      WebdavApi.new(url: @url, username: @username, password: @password)
    end
  end
end
