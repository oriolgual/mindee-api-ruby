# frozen_string_literal: true

require_relative '../../common_fields'
require_relative '../../base'

module Mindee
  module Prediction
    module US
      # License plate prediction.
      class BankCheckV1 < Prediction
        # Payer's bank account number.
        # @return [Array<Mindee::TextField>]
        attr_reader :account_number
        # Amount to be paid.
        # @return [Array<Mindee::AmountField>]
        attr_reader :amount
        # The check number.
        # @return [Mindee::TextField]
        attr_reader :check_number
        # Payer's bank account routing number.
        # @return [Mindee::TextField]
        attr_reader :routing_number
        # Date the check was issued.
        # @return [Mindee::DateField]
        attr_reader :date
        # The positions of the signatures on the image.
        # @return [Array<Mindee::PositionField>]
        attr_reader :signatures_positions
        # Check's position in the image.
        # @return [Mindee::PositionField]
        attr_reader :check_position
        # List of payees (full name or company name).
        # @return [Array<Mindee::TextField>]
        attr_reader :payees

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @account_number = TextField.new(prediction['account_number'], page_id)
          @amount = AmountField.new(prediction['amount'], page_id)
          @check_number = TextField.new(prediction['check_number'], page_id)
          @date = DateField.new(prediction['date'], page_id)
          @check_position = PositionField.new(prediction['check_position'], page_id)
          @routing_number = TextField.new(prediction['routing_number'], page_id)
          @signatures_positions = []
          prediction['signatures_positions'].each do |item|
            @signatures_positions.push(PositionField.new(item, page_id))
          end
          @payees = []
          prediction['payees'].each do |item|
            @payees.push(TextField.new(item, page_id))
          end
        end

        def to_s
          payees = @payees.map(&:value).join(', ')
          out_str = String.new
          out_str << "\n:Routing number: #{@routing_number}".rstrip
          out_str << "\n:Account number: #{@account_number}".rstrip
          out_str << "\n:Check number: #{@check_number}".rstrip
          out_str << "\n:Date: #{@date}".rstrip
          out_str << "\n:Amount: #{@amount}".rstrip
          out_str << "\n:Payees: #{payees}".rstrip
          out_str[1..].to_s
        end
      end
    end
  end
end
