module Nextcloud
  module Helpers
    module Properties
      # Body to send to receive item properties
      RESOURCE = '<?xml version="1.0"?>
        <d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns">
          <d:prop>
            <d:getlastmodified />
            <d:getetag />
            <d:resourcetype />
            <d:getcontenttype />
            <d:getcontentlength />
            <oc:id />
            <oc:fileid />
            <oc:permissions />
            <oc:size />
            <nc:has-preview />
            <oc:favorite />
            <oc:comments-href />
            <oc:comments-count />
            <oc:comments-unread />
            <oc:owner-id />
            <oc:owner-display-name />
            <oc:share-types />
            <nc:has-preview />
          </d:prop>
        </d:propfind>'.freeze

      # Body to send to add an item to favorites
      MAKE_FAVORITE = '<?xml version="1.0"?>
        <d:propertyupdate xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns">
          <d:set>
            <d:prop>
              <oc:favorite>1</oc:favorite>
            </d:prop>
          </d:set>
        </d:propertyupdate>'.freeze

      # Body to send to unfavorite an item
      UNFAVORITE = '<?xml version="1.0"?>
        <d:propertyupdate xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns">
          <d:set>
            <d:prop>
              <oc:favorite>0</oc:favorite>
            </d:prop>
          </d:set>
        </d:propertyupdate>'.freeze

      # Body to send for receiving favorites
      FAVORITE = '<?xml version="1.0"?>
        <oc:filter-files  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns" xmlns:nc="http://nextcloud.org/ns">
          <oc:filter-rules>
            <oc:favorite>1</oc:favorite>
          </oc:filter-rules>
          <d:prop>
            <d:getlastmodified />
            <d:getetag />
            <d:getcontenttype />
            <d:resourcetype />
            <oc:fileid />
            <oc:permissions />
            <oc:size />
            <d:getcontentlength />
            <nc:has-preview />
            <oc:favorite />
            <oc:comments-unread />
            <oc:owner-display-name />
            <oc:share-types />
          </d:prop>
        </oc:filter-files>'.freeze

      # Body to send to retrive tags properties
      TAG = '<?xml version="1.0" encoding="utf-8" ?>
        <a:propfind xmlns:a="DAV:" xmlns:oc="http://owncloud.org/ns">
          <a:prop>
            <!-- Retrieve the display-name, user-visible, and user-assignable properties -->
            <oc:display-name/>
            <oc:user-visible/>
            <oc:user-assignable/>
            <oc:id/>
          </a:prop>
        </a:propfind>'.freeze

      # Body to send to retrive comment properties
      COMMENT = '<?xml version="1.0"?>
    		<oc:filter-comments
    			xmlns:d="DAV:"
    			xmlns:oc="http://owncloud.org/ns"
    			xmlns:nc="http://nextcloud.org/ns"
    			xmlns:ocs="http://open-collaboration-services.org/ns">
    			<oc:limit>20</oc:limit>
    			<oc:offset>0</oc:offset>
    		</oc:filter-comments>'.freeze
    end

    #Body to send to get item by fileid
    def GET_BY_ID(id, scope)
      "<?xml version=\"1.0\"?>
      <d:searchrequest xmlns:d=\"DAV:\" xmlns:oc=\"http://owncloud.org/ns\" xmlns:nc=\"http://nextcloud.org/ns\">
        <d:basicsearch>
          <d:select>
            <d:prop>
              <d:getlastmodified />
              <d:getetag />
              <d:resourcetype />
              <d:getcontenttype />
              <d:getcontentlength />
              <oc:id />
              <oc:fileid />
              <oc:permissions />
              <oc:size />
              <nc:has-preview />
              <oc:favorite />
              <oc:comments-href />
              <oc:comments-count />
              <oc:comments-unread />
              <oc:owner-id />
              <oc:owner-display-name />
              <oc:share-types />
              <nc:has-preview />
            </d:prop>
          </d:select>
          <d:from>
            <d:scope>
              <d:href>#{scope}</d:href>
              <d:depth>infinity</d:depth>
            </d:scope>
          </d:from>
          <d:where>
            <d:eq>
              <d:prop>
                <oc:fileid/>
              </d:prop>
              <d:literal>#{id}</d:literal>
            </d:eq>
          </d:where>
          <d:orderby/>
        </d:basicsearch>
      </d:searchrequest>"
    end

    #Body to send to get files by name
    def SEARCH_BY_NAME(name, scope)
      "<?xml version=\"1.0\"?>
      <d:searchrequest xmlns:d=\"DAV:\" xmlns:oc=\"http://owncloud.org/ns\" xmlns:nc=\"http://nextcloud.org/ns\">
        <d:basicsearch>
          <d:select>
            <d:prop>
              <d:getlastmodified />
              <d:getetag />
              <d:resourcetype />
              <d:getcontenttype />
              <d:getcontentlength />
              <oc:id />
              <oc:fileid />
              <oc:permissions />
              <oc:size />
              <nc:has-preview />
              <oc:favorite />
              <oc:comments-href />
              <oc:comments-count />
              <oc:comments-unread />
              <oc:owner-id />
              <oc:owner-display-name />
              <oc:share-types />
              <nc:has-preview />
            </d:prop>
          </d:select>
          <d:from>
            <d:scope>
              <d:href>#{scope}</d:href>
              <d:depth>infinity</d:depth>
            </d:scope>
          </d:from>
          <d:where>
            <d:like>
              <d:prop>
                <d:displayname/>
              </d:prop>
              <d:literal>%#{name}%</d:literal>
            </d:like>
          </d:where>
          <d:orderby/>
        </d:basicsearch>
      </d:searchrequest>"
    end

    #Body to send to modify existing comment
    def MODIFY_COMMENT(message)
      "<?xml version=\"1.0\"?>
  			<d:propertyupdate
  				xmlns:d=\"DAV:\"
  				xmlns:oc=\"http://owncloud.org/ns\">
  			<d:set>
  				<d:prop>
  					<oc:message>#{message}</oc:message>
  				</d:prop>
  			</d:set>
			</d:propertyupdate>"
    end
  end
end
