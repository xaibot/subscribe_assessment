# frozen_string_literal: true

require './lib/parse_input_service'
require './lib/classify_product_type_service'
require './lib/compute_total_for_line_item_service'

class ComputeReceiptInfoService
  attr_reader :lines, :product_classifier, :total_value_service

  def initialize(lines)
    @lines = lines
  end

  def call
    line_items = compute_receipt_lines_items

    {
      line_items: line_items,
      total_taxes: line_items.sum{ _1[:total_tax] },
      total: line_items.sum{ _1[:total_price] },
    }
  end

  private

  def compute_receipt_lines_items
    line_items = ParseInputService.new(lines).call
    line_items.each do |line_item|
      product_type = product_classifier.call(line_item[:description])

      total_and_tax =
        total_value_service.call(
          unit_price:   line_item[:price],
          quantity:     line_item[:quantity],
          imported:     line_item[:imported],
          product_type: product_type,
        )

      line_item.merge!({
        product_type: product_type,
        total_price:  total_and_tax[:total_price],
        total_tax:    total_and_tax[:total_tax],
      })
    end

    line_items
  end

  def product_classifier
    @product_classifier ||=
      ClassifyProductTypeService.new(
        book_terms: ['book'],
        food_terms: ['chocolate'],
        medical_terms: ['pill'],
      )
  end

  def total_value_service
    @total_value_service ||= ComputeTotalForLineItemService.new
  end
end
