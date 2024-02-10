# frozen_string_literal: true

require 'compute_total_for_line_item_service'

describe ComputeTotalForLineItemService do
  subject { described_class.new }

  context 'for input sample 1' do
    context 'for 2 book at 12.49' do
      it 'returns 24.98' do
        total = subject.call(
          unit_price: 12.49,
          quantity: 2,
          imported: false,
          product_type: :book,
        )

        expect(total).to eq(total_price: 24.98, sales_tax: 0, import_tax: 0, total_tax: 0)
      end
    end

    context 'for 1 music CD at 14.99' do
      it 'returns 16.49' do
        total = subject.call(
          unit_price: 14.99,
          quantity: 1,
          imported: false,
          product_type: :other,
        )

        expect(total).to eq(total_price: 16.49, sales_tax: 1.5, import_tax: 0, total_tax: 1.5)
      end
    end

    context 'for 1 chocolate bar at 0.85' do
      it 'returns 0.85' do
        total = subject.call(
          unit_price: 0.85,
          quantity: 1,
          imported: false,
          product_type: :food,
        )

        expect(total).to eq(total_price: 0.85, sales_tax: 0, import_tax: 0, total_tax: 0)
      end
    end

  end

  context 'for input sample 2' do
    context 'for 1 imported box of chocolates at 10.00' do
      it 'returns 10.50' do
        total = subject.call(
          unit_price: 10.00,
          quantity: 1,
          imported: true,
          product_type: :food,
        )

        expect(total).to eq(total_price: 10.50, sales_tax: 0, import_tax: 0.5, total_tax: 0.5)
      end
    end

    context 'for 1 imported bottle of perfume at 47.50' do
      it 'returns 54.65' do
        total = subject.call(
          unit_price: 47.50,
          quantity: 1,
          imported: true,
          product_type: :other,
        )

        expect(total).to eq(total_price: 54.65, sales_tax: 4.75, import_tax: 2.4, total_tax: 7.15)
      end
    end
  end

  context 'for input sample 3' do
    context 'for 1 imported bottle of perfume at 27.99' do
      it 'returns 32.19' do
        total = subject.call(
          unit_price: 27.99,
          quantity: 1,
          imported: true,
          product_type: :other,
        )

        expect(total).to eq(total_price: 32.19, sales_tax: 2.80, import_tax: 1.4, total_tax: 4.2)
      end
    end
    context 'for 1 bottle of perfume at 18.99' do
      it 'returns 20.89' do
        total = subject.call(
          unit_price: 18.99,
          quantity: 1,
          imported: false,
          product_type: :other,
        )

        expect(total).to eq(total_price: 20.89, sales_tax: 1.90, import_tax: 0, total_tax: 1.90)
      end
    end
    context 'for 1 packet of headache pills at 9.75' do
      it 'returns 9.75' do
        total = subject.call(
          unit_price: 9.75,
          quantity: 1,
          imported: false,
          product_type: :medical_product,
        )

        expect(total).to eq(total_price: 9.75, sales_tax: 0, import_tax: 0, total_tax: 0)
      end
    end
    context 'for 3 imported boxes of chocolates at 11.25' do
      it 'returns 35.55' do
        total = subject.call(
          unit_price: 11.25,
          quantity: 3,
          imported: true,
          product_type: :food,
        )

        expect(total).to eq(total_price: 35.55, sales_tax: 0, import_tax: 1.8, total_tax: 1.80)
      end
    end
  end
end
