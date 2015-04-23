require 'bigdecimal'

class NumberTranslator

  def self.translate(number)

    #TODO improve validation in case of parameter is other than number or string
    return 'Not a valid number' if number.class == String and !(/\A[-+]?[0-9]+\z/.match(number))

    number = BigDecimal.new number
    number = number.frac == 0 ? number.to_i : number.to_f

    return @@SMALL[0] if number==0

    (number < 0 ? 'minus ' : '') + translate_big_number(number.abs).strip
  end

  class << self
    private

    @@SMALL  = %w(zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
    @@TENS   = %w(twenty thirty forty fifty sixty seventy eighty ninety)
    @@LARGE  = %w(thousand million billion trillion quadrillion quintillion sextillion septillion octillion nonillion)
    @@XLARGE = %w(decillion vigintillion trigintillion quadragintillion quinquagintillion sexagintillion septuagintillion octogintillion nonagintillion centillion)
    @@PREXLARGE = %w(un duo tre quattuor quin sex septen octo novem)

    # Range 1 - 999+
    def translate_big_number(number)
      words_array = number.to_s.reverse.split(/(\d{1,3})/).reject(&:empty?).map{|word| word.reverse}
      human_words = []
      words_array.each_with_index do |word, index|
        hundreds = translate_hundreds(word.to_i)
        hundreds += ' ' + get_big_word(index).to_s if word.to_i > 0
        human_words << hundreds
      end
      human_words.reverse.reject(&:empty?).join(', ')
    end

    # Range 1 - 999
    def translate_hundreds(number)
      word = []
      if number > 99
        word << @@SMALL[(number / 100)] + ' hundred'
        number = number % 100
      end

      if number > 19
        word << @@TENS[number / 10 - 2]
        number  = number % 10
      end
      word << @@SMALL[number] unless number == 0

      word.join(' ')
    end

    def get_big_word(index)
      if index > 10
        (index % 10 > 1 ? @@PREXLARGE[index % 10 - 2] : '') + @@XLARGE[index / 10 - 1].to_s
      elsif index > 0
        @@LARGE[index - 1]
      end
    end

  end
end
