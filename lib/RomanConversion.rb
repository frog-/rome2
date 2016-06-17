class RomanConversion
    def self.convert(hindu)
        return 0 unless hindu.between?(1,999999)

        hindu.to_s.reverse.each_char.with_index
            .collect{|num, power| digit_as_roman(num.to_i, power)}
            .reverse.join("")
    end


    # Determine the range of numerals for a power of ten.
    #
    # Every power of ten requires three roman numerals to express:
    # The power itself, the "five" value of that power, and the
    # following power. For example, to express 10-90, we need
    # X (for 10-30), L (for 40-80) and C (for 90).
    #
    # If the rank of I is 0, then the highest rank needed to express
    # all values of the corresponding power is 2 * power, and the
    # lowest rank is (2 * power) - 2
    def self.numerals_representing_power(power)
        power = (power - 1) * 2
        {   high: ALL[power + 2],
            five: ALL[power + 1],
            low: ALL[power] }
    end


    # Assign the matched numeral(s) for the value.
    #
    # There is a pattern to how each power of ten can be represented.
    # In the following description, L, F, and H are low, five, and high
    # as above. "n" represents the number of ones above zero or five.
    #     9     LH
    #   >=5     FnL
    #     4     LF
    #   >=0     nL
    def self.digit_as_roman(digit, power)
        lfh = numerals_representing_power power

        if digit == 9
            return lfh[:low] + lfh[:high]
        elsif digit >= 5
            ones = digit - 5
            return lfh[:five] + (lfh[:low] * ones)
        elsif digit == 4
            return lfh[:low] + lfh[:five]
        else 
            return lfh[:low] * digit
        end
    end
end