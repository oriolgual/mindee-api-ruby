# frozen_string_literal: true

require_relative '../common_fields/base'

module Mindee
  # Line items for invoices
  class InvoiceLineItem
    # @return [String] The product code referring to the item.
    attr_reader :product_code
    # @return [String]
    attr_reader :description
    # @return [Float]
    attr_reader :quantity
    # @return [Float]
    attr_reader :unit_price
    # @return [Float]
    attr_reader :total_amount
    # @return [Float] The item tax rate percentage.
    attr_reader :tax_rate
    # @return [Float]
    attr_reader :tax_amount
    # @return [Float]
    attr_reader :confidence
    # @return [Integer]
    attr_reader :page_id
    # @return [Mindee::Geometry::Quadrilateral]
    attr_reader :bounding_box
    # @return [Array<Mindee::Geometry::Polygon>]
    attr_reader :polygon

    def initialize(prediction, page_id)
      @product_code = prediction['product_code']
      @quantity = prediction['quantity']
      @unit_price = prediction['unit_price']
      @total_amount = prediction['total_amount']
      @tax_amount = prediction['tax_amount']
      @tax_rate = prediction['tax_rate']
      @description = prediction['description']
      @page_id = page_id
    end

    def to_s
      tax = Field.float_to_string(@tax_amount)
      tax << " (#{Field.float_to_string(@tax_rate)}%)" unless @tax_rate.nil?

      description = @description.nil? ? '' : @description
      description = "#{description[0..32]}..." if description.size > 35

      out_str = String.new
      out_str << format('%- 22s', @product_code)
      out_str << " #{format('%- 8s', Field.float_to_string(@quantity))}"
      out_str << " #{format('%- 9s', Field.float_to_string(@unit_price))}"
      out_str << " #{format('%- 10s', Field.float_to_string(@total_amount))}"
      out_str << " #{format('%- 18s', tax)}"
      out_str << " #{description}"
    end
  end
end
