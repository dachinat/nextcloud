require "active_support"
require "active_support/core_ext/hash"
require "json"

module Nextcloud
  # Helper methods that are used through lib
  module Helpers
    # Makes an array out of repeated elements
    #
    # @param doc [Object] Nokogiri::XML::Document
    # @param xpath [String] Path to element that is being repeated
    # @return [Array] Parsed array
    def parse_with_meta(doc, xpath)
      groups = []
      doc.xpath(xpath).each do |prop|
        groups << prop.text
      end
      meta = get_meta(doc)
      groups.send(:define_singleton_method, :meta) do
        meta
      end
      groups
    end

    # Parses meta information returned by API, may include a status, status code and a message
    #
    # @param doc [Object] Nokogiri::XML::Document
    # @return [Hash] Parsed hash
    def get_meta(doc)
      meta = doc.xpath("//meta/*").each_with_object({}) do |node, meta|
        meta[node.name] = node.text
      end
    end

    # Converts document to hash
    #
    # @param doc [Object] Nokogiri::XML::Document
    # @param xpath [String] Document path to convert to hash
    # @return [Hash] Hash that was produced from XML document
    def doc_to_hash(doc, xpath = "/")
      h = Hash.from_xml(doc.xpath(xpath).to_xml)
      h
    end

    # Adds meta method to an object
    #
    # @param doc [Object] Nokogiri::XML::Document to take meta information from
    # @param obj [#define_singleton_method] Object to add meta method to
    # @return [#define_singleton_method] Object with meta method defined
    def add_meta(doc, obj)
      meta = get_meta(doc)
      obj.define_singleton_method(:meta) { meta } && obj
    end

    # Extracts remaining part of url
    #
    # @param href [String] Full url
    # @param url [String] Part to give away
    # @return [String] "Right" part of string
    def path_from_href(href, url)
      href.match(/#{url}(.*)/)[1]
    end

    # Shows errors, or success message
    #
    # @param doc [Object] Nokogiri::XML::Document
    # @return [Hash] State response
    def parse_dav_response(doc)
      doc.remove_namespaces!
      if doc.at_xpath("//error")
        {
            exception: doc.xpath("//exception").text,
            message: doc.xpath("//message").text
        }
      elsif doc.at_xpath("//status")
        {
            status: doc.xpath("//status").text
        }
      else
        {
            status: "ok"
        }
      end
    end

    # Shows error or returns false
    #
    # @param doc [Object] Nokogiri::XML::Document
    # @return [Hash,Boolean] Returns error message if found, false otherwise
    def has_dav_errors(doc)
      doc.remove_namespaces!
      if doc.at_xpath("//error")
        {
            exception: doc.xpath("//exception").text,
            message: doc.xpath("//message").text
        }
      else
        false
      end
    end
  end
end
