# frozen_string_literal: true

require 'json'

require_relative 'http/endpoint'
require_relative 'parsing/document'
require_relative 'parsing/error'
require_relative 'parsing/prediction'

module Mindee
  # Specific client for sending a document to the API.
  class DocumentConfig
    # Array of possible Mindee::Endpoint to be used.
    # @return [Array<Mindee::HTTP::Endpoint>]
    attr_reader :endpoints

    # @param prediction_class [Class<Mindee::Prediction::Prediction>]
    # @param endpoints [Array<Mindee::HTTP::Endpoint>]
    def initialize(prediction_class, endpoints)
      @prediction_class = prediction_class
      @endpoints = endpoints
    end

    # Call the prediction API.
    # @param input_doc [Mindee::InputDocument]
    # @param include_words [Boolean]
    # @param close_file [Boolean]
    # @param cropper [Boolean]
    # @return [Mindee::DocumentResponse]
    def predict(input_doc, include_words, close_file, cropper)
      check_api_keys
      response = predict_request(input_doc, include_words, close_file, cropper)
      parse_response(response)
    end

    private

    # @param response [Net::HTTPResponse]
    # @return [Mindee::DocumentResponse]
    def parse_response(response)
      hashed_response = JSON.parse(response.body, object_class: Hash)
      return Document.new(@prediction_class, hashed_response['document']) if (200..299).include?(response.code.to_i)

      error = Parsing::Error.new(hashed_response['api_request']['error'])
      raise error
    end

    # @param input_doc [Mindee::InputDocument]
    # @param include_words [Boolean]
    # @param close_file [Boolean]
    # # @param cropper [Boolean]
    # @return [Net::HTTPResponse]
    def predict_request(input_doc, include_words, close_file, cropper)
      @endpoints[0].predict_req_post(input_doc, include_words: include_words, close_file: close_file, cropper: cropper)
    end

    def check_api_keys
      @endpoints.each do |endpoint|
        next unless endpoint.api_key.nil? || endpoint.api_key.empty?

        raise "Missing API key for '#{@document_type}', " \
              "check your Client Configuration.\n" \
              'You can set this using the ' \
              "'#{HTTP::API_KEY_ENV_NAME}' environment variable."
      end
    end
  end
end
