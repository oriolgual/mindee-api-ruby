# frozen_string_literal: true

module Mindee
  # Company registration number or code, and its type.
  class CompanyRegistration < Field
    # @return [String]
    attr_reader :type

    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    # @param reconstructed [Boolean]
    def initialize(prediction, page_id, reconstructed: false)
      super
      @type = prediction['type']
    end
  end
end
