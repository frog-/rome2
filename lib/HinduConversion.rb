require_relative 'Numeral'
require_relative 'RomanNumeralValidator'

class HinduConversion
    def self.convert(roman)
        return 0 unless RomanNumeralValidator.new(roman).valid?
        
        prev_rank = 1
        result = 0
        roman.each_char.collect{|ch| Numeral::ALL[ch.to_sym]}.each do |char|
            if char.rank >= prev_rank
                result += char.value
            else
                result -= char.value
            end

            prev_rank = char.rank
        end

        return result
    end
end

letters = ARGV.first

puts HinduConversion.convert(letters)