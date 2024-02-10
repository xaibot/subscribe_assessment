# frozen_string_literal: true

class ComputeTotalForLineItemService
  IMPORT_DUTY_RATE = 5
  SALES_TAX_RATE = 10

  def call(unit_price:, quantity:, imported:, product_type:)
    applicable_sales_tax_rate =
      if %i[medical_product book food].include?(product_type)
        0
      else
        SALES_TAX_RATE
      end

    applicable_import_duty_rate = imported ? IMPORT_DUTY_RATE : 0

    rate_to_apply = applicable_sales_tax_rate + applicable_import_duty_rate
    total_tax = round_to_nearest_target(unit_price * rate_to_apply / 100) * quantity

    sales_tax = round_to_nearest_target(unit_price * applicable_sales_tax_rate / 100) * quantity
    import_tax = round_to_nearest_target(unit_price * applicable_import_duty_rate / 100) * quantity

    {
      total_price: (quantity * unit_price + total_tax).round(2),
      sales_tax: sales_tax.round(2),
      import_tax: import_tax.round(2),
      total_tax: total_tax.round(2),
    }
  end

  private

  def round_to_nearest_target(amount)
    precision = 1 / 0.05
    (amount * precision).ceil / precision
  end
end
