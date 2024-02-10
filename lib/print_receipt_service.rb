# frozen_string_literal: true

require './lib/compute_receipt_info_service'

class PrintReceiptService
  attr_reader :receipt_info, :output_file

  def initialize(receipt_info, output_file: STDOUT)
    @receipt_info = receipt_info
    @output_file = output_file
  end

  def call
    print_line_items
    print_sale_taxes
    print_total
  end

  private

  def print_line_items
    receipt_info[:line_items].each do |line_item|
      quantity, imported, description, total_price =
        line_item.slice(:quantity, :imported, :description, :total_price).values

      output_file.printf "%i %s%s: %.2f\n", quantity, (imported ? 'imported ' : ''), description, total_price
    end
  end

  def print_sale_taxes
    output_file.printf "Sales Taxes: %.2f\n", receipt_info[:total_taxes]
  end

  def print_total
    output_file.printf "Total: %.2f\n", receipt_info[:total]
  end
end
