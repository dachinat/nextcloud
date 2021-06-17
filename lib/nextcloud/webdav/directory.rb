require "net-http-report"

module Nextcloud
  module Webdav
    # WebDAV class for communicating with File/directory mgmt. service
    #
    # @!attribute [rw] directory
    #   @return [Array] Used to store model instances when querying with find or favorites
    class Directory < WebdavApi
      include Helpers
      include Properties

      attr_accessor :directory

      # Class initializer
      # Can be initialized with WebdavApi's directory method or with Nextcloud::Webdav::Directory.new(...credentials...)
      #
      # @param args [Object,Hash] Can be instance of Api or credentials list (url, username, password)
      def initialize(args)
        if args.class == Nextcloud::WebdavApi
          @api = args
        else
          super
          @api = self
        end

        @path = "/files/#{@api.username}"
      end

      # Gets a file path from fileid
      #
      # @param id [String] fileid from the file we want
      # @param scope [String] Path of file or directory to search in
      # @return [Object,Hash] Hash of error or instance of Directory model class
      def get_path_from_fileid(id, scope = '')
        response = @api.request(:search, '' , nil, GET_BY_ID(id, "#{@path}/#{scope}"))
        return has_dav_errors(response) ? has_dav_errors(response) : response.xpath('//response//href').text.match(/\/#{DAV_URL}\/files\/[^\/]*(.*)/)[1]
      end

      # Query a file, find contents of directory (including information about directory)
      #
      # @param path [String] Path of file or directory to search in
      # @return [Object,Hash] Hash of error or instance of Directory model class
      def find(path = "/")
        response = @api.request(:propfind, "#{@path}/#{path}", nil, RESOURCE)
        (has_dav_errors(response)) ? has_dav_errors(response) : directory(response)
      end

      # Query a file, find contents of directory (including information about directory) from fileid
      #
      # @param id [String] file id of the file / directory
      # @param scope [String] Path of file or directory to search in
      # @return [Object,Hash] Hash of error or instance of Directory model class
      def find_by_fileid(id, scope = '')
        path = get_path_from_fileid(id, scope)
        path.class == Hash ? path : find(path)
      end

      # Create a directory
      #
      # @param path [String] Path of new directory relative to base
      # @return [Hash] Returns status
      def create(path)
        response = @api.request(:mkcol, "#{@path}/#{path}")
        parse_dav_response(response)
      end

      # Create a directory
      #
      # @param path [String] Path of new directory relative to base
      # @return [Hash] Returns status
      def destroy(path)
        response = @api.request(:delete, "#{@path}/#{path}")
        parse_dav_response(response)
      end

      # Download a file
      #
      # @param path [String] Path of file to download
      # @return [String] Returns file contents
      def download(path)
        @api.request(:get, "#{@path}/#{path}", nil, nil, nil, nil, true)
      end

      # Upload a file
      #
      # @param path [String] Path of new upload
      # @return contents [Hash] Returns status
      def upload(path, contents)
        response = @api.request(:put, "#{@path}/#{path}", nil, contents)
        parse_dav_response(response)
      end

      # Move a file
      #
      # @param source [String] Source path relative to base
      # @param destination [String] Destination path relative to base
      # @return [Hash] Returns status
      def move(source, destination)
        response = @api.request(:move, "#{@path}/#{source}", nil, nil, nil,
          destination = "#{@api.url}#{@path}/#{destination}")
        parse_dav_response(response)
      end

      # Copy a file
      #
      # @param source [String] Source path relative to base
      # @param destination [String] Destination path relative to base
      # @return [Hash] Returns status
      def copy(source, destination)
        response = @api.request(:copy, "#{@path}/#{source}", nil, nil, nil,
          destination = "#{@api.url}#{@path}/#{destination}")
        parse_dav_response(response)
      end

      def search_by_name(name, scope = '')
        response = @api.request(:search, '' , nil, SEARCH_BY_NAME(name, "#{@path}/#{scope}"))
        return (has_dav_errors(response)) ? has_dav_errors(response) : directory(response, false)
      end

      # Make file/directory a favorite
      #
      # @param path [String] Path of file/directory (relative)
      # @return [Hash] Returns status
      def favorite(path)
        response = @api.request(:proppatch, "#{@path}/#{path}", nil, MAKE_FAVORITE)
        parse_dav_response(response)
      end

      # Unfavorite a file/directory
      #
      # @param path [String] Path of file/directory (relative)
      # @return [Hash] Returns status
      def unfavorite(path)
        response = @api.request(:proppatch, "#{@path}/#{path}", nil, UNFAVORITE)
        parse_dav_response(response)
      end

      # Shows favorite files/directories in given location
      #
      # @param path [String] Location to list favorites from
      # @return [Hash] Hash of error or array of Directory model classes
      def favorites(path = "/")
        response = @api.request(:REPORT, "#{@path}/#{path}", nil, FAVORITE)
        (has_dav_errors(response)) ? has_dav_errors(response) : directory(response, false)
      end

      private

      # Parses as turns file/directory response to model object
      #
      # @param response [Object] Nokogiri::XML::Document
      # @param skip_first [Boolean] Skip or not first element
      # @return [Object,Array] Returns Object if first element not skipped, array otherwise
      def directory(response, skip_first = true)
        response = doc_to_hash(response).try(:[], "multistatus").try(:[], "response")
        response = [response] if response.is_a? Hash

        return [] if response.nil?

        response.each_with_index do |h, index|

          prop = h["propstat"].try(:[], 0).try(:[], "prop") || h["propstat"]["prop"]

          params = {
              id: prop["id"],
              fileid: prop["fileid"],
              contenttype: prop["getcontenttype"],
              display_name: CGI.unescape(h["href"].split('/').last),
              has_preview: prop["has_preview"] == "false" ? false : true,
              lastmodified: prop["getlastmodified"],
              owner_display_name: prop["owner_display_name"],
              owner_id: prop["owner_id"],
              path: h["href"].gsub(/\/remote.php\/dav\/files\/[^\/]*\//, '/'),
              permissions: prop["permissions"],
              resourcetype: prop["resourcetype"].nil? ? "file" : "collection",
              share_types: prop["share_types"],
              size: prop["size"],
              tag: prop["getetag"],
          }

          if skip_first
            if index == 0
              @directory = Models::Directory.new(params)
            else
              @directory.add(params)
            end
          else
            @directory = [] if @directory.nil?
            @directory << Models::Directory.new(params.merge(skip_contents: true))
          end
        end
        @directory
      end
    end
  end
end
