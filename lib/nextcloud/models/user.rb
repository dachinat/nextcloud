module Nextcloud
  module Models
    # User model
    #
    # @!attribute [rw] enabled
    #   @return [String] Is an user enabled or not
    # @!attribute [rw] id
    #   @return [String] Identifier of an user
    # @!attribute [rw] quota
    #   @return [Hash] Quota of user
    # @!attribute [rw] email
    #   @return [String] E-mail address
    # @!attribute [rw] displayname
    #   @return [String] User display name
    # @!attribute [rw] phone
    #   @return [String] User phone number
    # @!attribute [rw] address
    #   @return [String] User address
    # @!attribute [rw] website
    #   @return [String] User web-site address
    # @!attribute [rw] twitter
    #   @return [String] User Twitter account
    # @!attribute [rw] groups
    #   @return [String] Groups user belongs to
    # @!attribute [rw] language
    #   @return [String] Nextcloud version for an user
    class User
      attr_accessor :meta

      # Initiates a model instance
      #
      # @param [Hash]
      def initialize(enabled: nil, id: nil, quota: nil, email: nil, displayname: nil, phone: nil, address: nil,
        website: nil,
        twitter: nil, groups: nil, language: nil)

        self.class.params.each do |v|
          instance_variable_set("@#{v}", instance_eval(v.to_s)) if instance_eval(v.to_s)
        end
      end

      @params = instance_method(:initialize).parameters.map(&:last)
      @params.each { |p| instance_eval("attr_accessor :#{p}") }

      class << self
        attr_reader :params
      end
    end
  end
end
