# frozen_string_literal: true

class ClassifyProductTypeService
  attr_reader :book_terms, :food_terms, :medical_terms

  def initialize(book_terms:, food_terms:, medical_terms:)
    @book_terms = book_terms
    @food_terms = food_terms
    @medical_terms = medical_terms
  end

  def call(description)
    book_regexp = regexp_for(terms: book_terms)
    food_regexp = regexp_for(terms: food_terms)
    medical_regexp = regexp_for(terms: medical_terms)

    case description
    when medical_regexp then :medical_product
    when book_regexp then :book
    when food_regexp then :food
    else :other
    end
  end

  private

  def regexp_for(terms:)
    Regexp.new(terms.join('|'))
  end
end
