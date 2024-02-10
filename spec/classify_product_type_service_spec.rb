# frozen_string_literal: true

require 'classify_product_type_service'

describe ClassifyProductTypeService do
  subject {
    described_class.new(
      book_terms: book_terms,
      food_terms: food_terms,
      medical_terms: medical_terms,
    )
  }

  let(:book_terms) { ['book'] }
  let(:food_terms) { ['chocolate'] }
  let(:medical_terms) { ['pill'] }

  let(:description) { nil }

  context 'for the sample data' do
    context 'for descriptions with book terms' do
      it 'classifies them as book' do
        expect(subject.call('book')).to eq(:book)
      end
    end

    context 'for descriptions with food terms' do
      it 'classifies them as food' do
        expect(subject.call('chocolate bar')).to eq(:food)
        expect(subject.call('box of chocolates')).to eq(:food)
        expect(subject.call('boxes of chocolates')).to eq(:food)
      end
    end

    context 'for descriptions with medical terms' do
      it 'classifies them as medical products' do
        expect(subject.call('packet of headache pills')).to eq(:medical_product)
      end
    end

    context 'for descriptions with other products' do
      it 'classifies them as other' do
        expect(subject.call('music CD')).to eq(:other)
        expect(subject.call('bottle of perfume')).to eq(:other)
      end
    end
  end

  context 'when there is a mix of terms' do
    it 'medical terms take precedence over the rest' do
      expect(subject.call('chocolate headache pills')).to eq(:medical_product)
      expect(subject.call('book about pills')).to eq(:medical_product)
      expect(subject.call('book about chocolate pills')).to eq(:medical_product)
    end

    it 'book terms take precedence over food terms' do
      expect(subject.call('book with chocolate recipes')).to eq(:book)
    end
  end
end
