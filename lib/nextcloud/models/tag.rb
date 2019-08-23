module Nextcloud
  module Models
    # Tag model
    #
    # @!attribute [rw] href
    #   @return [String] tag location
    # @!attribute [rw] display_name
    #   @return [String] display name of tag
    # @!attribute [rw] user_visible
    #   @return [String] tag user visible or not
    # @!attribute [rw] user_assignable
    #   @return [String] user can assign tag or not
    # @!attribute [rw] id
    #   @return [String] ID
    class Tag
      attr_accessor :meta, :contents

      # Initiates a model instance
      #
      # @param [Hash]
      def initialize(href: nil, display_name: nil, user_visible: nil, user_assignable: nil, id: nil, skip_contents: false)

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
