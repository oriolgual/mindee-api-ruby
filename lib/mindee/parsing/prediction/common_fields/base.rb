# frozen_string_literal: true

require_relative '../../../geometry'

module Mindee
  # Base field object.
  class Field
    # @return [String, Float, Integer, Boolean]
    attr_reader :value
    # @return [Array<Array<Float>>]
    attr_reader :bounding_box
    # @return [Mindee::Geometry::Polygon]
    attr_reader :polygon
    # @return [Integer, nil]
    attr_reader :page_id
    # true if the field was reconstructed or computed using other fields.
    # @return [Boolean]
    attr_reader :reconstructed
    # The confidence score, value will be between 0.0 and 1.0
    # @return [Float]
    attr_accessor :confidence

    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    # @param reconstructed [Boolean]
    def initialize(prediction, page_id, reconstructed: false)
      @value = prediction['value']
      @confidence = prediction['confidence']
      @polygon = Geometry.polygon_from_prediction(prediction['polygon'])
      @bounding_box = Geometry.get_bounding_box(@polygon) unless @polygon.nil? || @polygon.empty?
      @page_id = page_id || prediction['page_id']
      @reconstructed = reconstructed
    end

    def to_s
      @value ? @value.to_s : ''
    end

    # Multiply all the Mindee::Field confidences in the array.
    def self.array_confidence(field_array)
      product = 1
      field_array.each do |field|
        return 0.0 if field.confidence.nil?

        product *= field.confidence
      end
      product.to_f
    end

    # Add all the Mindee::Field values in the array.
    def self.array_sum(field_array)
      arr_sum = 0
      field_array.each do |field|
        return 0.0 if field.value.nil?

        arr_sum += field.value
      end
      arr_sum.to_f
    end

    # @param value [Float]
    # @param min_precision [Integer]
    def self.float_to_string(value, min_precision = 2)
      return String.new if value.nil?

      precision = value.to_f.to_s.split('.')[1].size
      precision = [precision, min_precision].max
      format_string = "%.#{precision}f"
      format(format_string, value)
    end
  end
end
