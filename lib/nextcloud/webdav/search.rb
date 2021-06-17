module Nextcloud
  module Webdav
    class Search < Net::HTTPRequest
      METHOD = "SEARCH"
      REQUEST_HAS_BODY = true
      RESPONSE_HAS_BODY = true
    end
  end
end
