module Nextcloud
  module Models
    # Directory model
    #
    # @!attribute [rw] href
    #   @return [String] File/directory location
    # @!attribute [rw] lastmodified
    #   @return [String] Last modification time of file/directory
    # @!attribute [rw] tag
    #   @return [Hash] Etag
    # @!attribute [rw] resourcetype
    #   @return [String] Type of a resource
    # @!attribute [rw] contenttype
    #   @return [String] Type of content
    # @!attribute [rw] contentlength
    #   @return [String] Length of content
    # @!attribute [rw] id
    #   @return [String] ID
    # @!attribute [rw] fileid
    #   @return [String] Fileid
    # @!attribute [rw] permissions
    #   @return [String] Permissions
    # @!attribute [rw] has_preview
    #   @return [String] Has preview or not
    # @!attribute [rw] favorite
    #   @return [String] Is favorited or not
    # @!attribute [rw] comments_href
    #   @return [String] Address of comments
    # @!attribute [rw] comments_count
    #   @return [String] Comments count
    # @!attribute [rw] comments_unread
    #   @return [String] Unread comments
    # @!attribute [rw] owner_id
    #   @return [String] Id of owner
    # @!attribute [rw] owner_display_name
    #   @return [String] Display name of owner
    # @!attribute [rw] share_types
    #   @return [String] Share types
    class Directory
      attr_accessor :meta, :contents

      # Initiates a model instance
      #
      # @param [Hash]
      def initialize(href: nil, lastmodified: nil, tag: nil, resourcetype: nil, contenttype: nil, contentlength: nil,
        id: nil, fileid: nil, permissions: nil, size: nil, has_preview: nil, favorite: nil,
        comments_href: nil, comments_count: nil, comments_unread: nil, owner_id: nil,
        owner_display_name: nil, share_types: nil, skip_contents: false)

        self.class.params.each do |v|
          instance_variable_set("@#{v}", instance_eval(v.to_s)) if instance_eval(v.to_s)
        end

        remove_instance_variable (:@skip_contents) if skip_contents
      end

      @params = instance_method(:initialize).parameters.map(&:last)
      @params.each { |p| instance_eval("attr_accessor :#{p}") }

      class << self
        attr_reader :params
      end

      # Adds content to collection
      #
      # @param [Hash]
      # @return [Array] Contents array
      def add(args)
        @contents = [] if @contents.nil?
        @contents << self.class.new(**args.merge(skip_contents: true))
      end
    end
  end
end
