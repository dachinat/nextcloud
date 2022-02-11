module Nextcloud
  module Models
    # Comment model
    #
    # @!attribute [rw] href
    #   @return [String] comment URI
    # @!attribute [rw] id
    #   @return [String] ID
    # @!attribute [rw] parentId
    #   @return [String] parent comment ID
    # @!attribute [rw] topmostParentId
    #   @return [String] topmost parent comment ID
    # @!attribute [rw] childrenCount
    #   @return [String] child comment count
    # @!attribute [rw] verb
    #   @return [String] 'comment'
    # @!attribute [rw] actorType
    #   @return [String] type of the comment poster
    # @!attribute [rw] actorId
    #   @return [String] ID of comment poster
    # @!attribute [rw] creationDateTime
    #   @return [String] creation date
    # @!attribute [rw] latestChildDateTime
    #   @return [String] creatin date of latest child comment
    # @!attribute [rw] objectType
    #   @return [String] type of object this comment is on
    # @!attribute [rw] objectId
    #   @return [String] ID of object this comment is on
    # @!attribute [rw] message
    #   @return [String] comment message
    # @!attribute [rw] actorDisplayName
    #   @return [String] display name of comment poster
    # @!attribute [rw] isUnread
    #   @return [String] whether comment is unread
    # @!attribute [rw] mentions
    #   @return [String] (?) list of people mentioned

    class Comment
      attr_accessor :meta, :contents

      # Initiates a model instance
      #
      # @param [Hash]
      def initialize(
        href: nil,
        id: nil,
        parent_id: nil,
        topmost_parent_id: nil,
        children_count: nil,
        verb: nil,
        actor_type: nil,
        actor_id: nil,
        creation_datetime: nil,
        latest_child_datetime: nil,
        object_type: nil,
        object_id: nil,
        message: nil,
        actor_display_name: nil,
        is_unread: nil,
        mentions: nil,
        skip_contents: false
      )

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
        @contents << self.class.new(args.merge(skip_contents: true))
      end
    end
  end
end
