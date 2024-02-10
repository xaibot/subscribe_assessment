# frozen_string_literal: true

require 'parse_input_service'

describe ParseInputService do
  subject { described_class.new(lines).call }

  let(:lines) { [] }

  context 'for input sample 1' do
    let(:lines) {
      [
        '2 book at 12.49',
        '1 music CD at 14.99',
        '1 chocolate bar at 0.85',
      ]
    }

    it 'returns the expected objects' do
      expected_values = [
        {quantity: 2, imported: false, price: 12.49, description: 'book'},
        {quantity: 1, imported: false, price: 14.99, description: 'music CD'},
        {quantity: 1, imported: false, price:  0.85, description: 'chocolate bar'},
      ]

      expect(subject).to eq(expected_values)
    end
  end

  context 'for input sample 2' do
    let(:lines) {
      [
        '1 imported box of chocolates at 10.00',
        '1 imported bottle of perfume at 47.50',
      ]
    }

    it 'returns the expected objects' do
      expected_values = [
        {quantity: 1, imported: true, price: 10.00, description: 'box of chocolates'},
        {quantity: 1, imported: true, price: 47.50, description: 'bottle of perfume'},
      ]

      expect(subject).to eq(expected_values)
    end
  end

  context 'for input sample 3' do
    let(:lines) {
      [
        '1 imported bottle of perfume at 27.99',
        '1 bottle of perfume at 18.99',
        '1 packet of headache pills at 9.75',
        '3 imported boxes of chocolates at 11.25',
      ]
    }

    it 'returns the expected objects' do
      expected_values = [
        {quantity: 1, imported: true,  price: 27.99, description: 'bottle of perfume'},
        {quantity: 1, imported: false, price: 18.99, description: 'bottle of perfume'},
        {quantity: 1, imported: false, price:  9.75, description: 'packet of headache pills'},
        {quantity: 3, imported: true,  price: 11.25, description: 'boxes of chocolates'},
      ]

      expect(subject).to eq(expected_values)
    end
  end

  describe 'with wrong data' do
    context 'when there are null values' do
      let(:lines) { [nil, '2 book at 12.49'] }

      it 'ignores such empty lines' do
        expected_values = [{quantity: 2, imported: false, price: 12.49, description: 'book'}]
        expect(subject).to eq(expected_values)
      end
    end

    context 'when there are empty lines' do
      let(:lines) { ['', '2 book at 12.49'] }

      it 'ignores such empty lines' do
        expected_values = [{quantity: 2, imported: false, price: 12.49, description: 'book'}]
        expect(subject).to eq(expected_values)
      end
    end

    context 'when a line does not follow the expected format' do
      let(:lines) { ['1 book 12.49', 'book at 12.49', '1 book at', 'abc', 'to be or not to be'] }

      it 'ignore such wrongly formatted line' do
        expect(subject).to eq([])
      end
    end
  end
end
