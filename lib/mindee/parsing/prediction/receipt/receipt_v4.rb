# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'

module Mindee
  module Prediction
    # Receipt document.
    class ReceiptV4 < Prediction
      # Where the purchase was made, the language, and the currency.
      # @return [Mindee::Locale]
      attr_reader :locale
      # Total including taxes
      # @return [Mindee::AmountField]
      attr_reader :total_amount
      # Total amount of the purchase excluding taxes.
      # @return [Mindee::AmountField]
      attr_reader :total_net
      # Total tax amount of the purchase.
      # @return [Mindee::AmountField]
      attr_reader :total_tax
      # The purchase date.
      # @return [Mindee::DateField]
      attr_reader :date
      # The name of the supplier or merchant, as seen on the receipt.
      # @return [Mindee::TextField]
      attr_reader :supplier
      # List of taxes detected on the receipt.
      # @return [Array<Mindee::TaxField>]
      attr_reader :taxes
      # Time as seen on the receipt in HH:MM format.
      # @return [Mindee::TextField]
      attr_reader :time
      # The receipt category among predefined classes.
      # @return [Mindee::TextField]
      attr_reader :category
      # The receipt sub-category among predefined classes.
      # @return [Mindee::TextField]
      attr_reader :subcategory
      # Whether the document is an expense receipt or a credit card receipt.
      # @return [Mindee::TextField]
      attr_reader :document_type
      # Total amount of tip and gratuity. Both typed and handwritten characters are supported.
      # @return [Mindee::AmountField]
      attr_reader :tip

      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, page_id)
        super
        @locale = Locale.new(prediction['locale'])
        @total_amount = AmountField.new(prediction['total_amount'], page_id)
        @total_net = AmountField.new(prediction['total_net'], page_id)
        @total_tax = AmountField.new(prediction['total_tax'], page_id)
        @tip = AmountField.new(prediction['tip'], page_id)
        @date = DateField.new(prediction['date'], page_id)
        @category = TextField.new(prediction['category'], page_id)
        @subcategory = TextField.new(prediction['subcategory'], page_id)
        @document_type = TextField.new(prediction['document_type'], page_id)
        @supplier = TextField.new(prediction['supplier'], page_id)
        @time = TextField.new(prediction['time'], page_id)
        @taxes = []
        prediction['taxes'].each do |item|
          @taxes.push(TaxField.new(item, page_id))
        end
      end

      def to_s
        taxes = @taxes.join("\n       ")
        out_str = String.new
        out_str << "\n:Locale: #{@locale}".rstrip
        out_str << "\n:Date: #{@date}".rstrip
        out_str << "\n:Category: #{@category}".rstrip
        out_str << "\n:Subcategory: #{@subcategory}".rstrip
        out_str << "\n:Document type: #{@document_type}".rstrip
        out_str << "\n:Time: #{@time}".rstrip
        out_str << "\n:Supplier name: #{@supplier}".rstrip
        out_str << "\n:Taxes: #{taxes}".rstrip
        out_str << "\n:Total net: #{@total_net}".rstrip
        out_str << "\n:Total taxes: #{@total_tax}".rstrip
        out_str << "\n:Tip: #{@tip}".rstrip
        out_str << "\n:Total amount: #{@total_amount}".rstrip
        out_str[1..].to_s
      end
    end
  end
end
