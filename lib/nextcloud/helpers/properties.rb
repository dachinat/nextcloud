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
    end
  end
end
