#
# The Numeral class holds the values etc for each unique roman numeral
#
class Numeral
	attr_reader :symbol
	attr_reader :value
	attr_reader :rank

	def initialize(symbol, value, rank)
		@symbol = symbol
		@value = value
		@rank = rank
	end

	def can_prefix?(other_rank)
		return other_rank - @rank <= 2
	end
end

# Each numeral exists only once
$numerals = [
	Numeral.new("I", 1, 0),
	Numeral.new("V", 5, 1),
	Numeral.new("X", 10, 2),
	Numeral.new("L", 50, 3),
	Numeral.new("C", 100, 4),
	Numeral.new("D", 500, 5),
	Numeral.new("M", 1000, 6),
]


def Numeral.to_hindu(roman)
	# Read the string backwards, associate each character 
	# with a Numeral object. The string is read backwards to
	# avoid look-ahead for prefixed values
	chars = []
	roman.upcase.reverse.split("").each do |ch|
		case ch
		when "I" then chars << $numerals[0]
		when "V" then chars << $numerals[1]
		when "X" then chars << $numerals[2]
		when "L" then chars << $numerals[3]
		when "C" then chars << $numerals[4]
		when "D" then chars << $numerals[5]
		when "M" then chars << $numerals[6]
		else puts "Invalid symbols" ; abort
		end
	end

	# Running total
	value = 0

	# Track highest rank seen yet and largest previous non-prefixing rank
	# These values are initially -1 because the ranks start at 0 and must
	# be exceedable
	prev_rank = -1
	largest_np = -1

	# Monitor prefixes; only one character may be prefixed
	prefix = false

	# Max three like symbols in a row
	prev_symbol = ""
	streak = 0

	#
	# Validate and calculate value of roman number
	#
	chars.each do |ch|
		# If not a prefixing value...
		if ch.rank >= prev_rank
			# If the preceding value was a prefix, this value must be
			# at least 10x the size
			if prefix && ch.rank - prev_rank < 2
				puts "Error: Improper prefixing"
				abort
			end

			# If last symbol was the same, test for repeats
			if ch.rank == prev_rank
				# If there are four symbols in a row, or if a non-10
				# was repeated, the symbol is invalid.
				# All non-10 symbols have odd ranks, so modulus spots them
				streak += 1
				if streak > 3 || ch.rank % 2 == 1
					puts "Error: Illegal repetition"
					abort
				end
			# If symbol is different, update working info and reset streak
			else
				# Note that the largest_np is always "two behind". This way
				# we know it was not prefixed
				largest_np = prev_rank
				prev_rank = ch.rank
				prev_symbol = ch.symbol
				streak = 1
			end

			# Increase total value, reset prefix flag
			value += ch.value
			prefix = false

		# If indeed a prefixing value...
		else
			# Can't have more than two prefixed numerals
			if prefix == true
				puts "Error: multiple prefixes"
				abort
			end

			# Prefixes only valid on 1/5th or 1/10th their value
			unless ch.can_prefix? prev_rank
				puts "Error: #{ch.symbol} cannot prefix #{prev_symbol}"
				abort
			end

			# There can be no previous non-prefixed values that are greater
			# than or equal to the current prefix
			if ch.rank <= largest_np
				puts "Error: prefixed value exceeded or matched by earlier value"
				abort
			end

			# If Ok, subtract the prefix and set the prefix flag
			value -= ch.value
			prefix = true
			prev_rank = ch.rank
			prev_symbol = ch.symbol
		end
	end

	return value
end

def Numeral.to_roman(number)
	# Don't try to convert non-numbers
	if number == "" || number == 0
		return 0
	end

	roman = ""
	power = 0
	while (10 ** power) <= number
		power += 1
		place = 10 ** power
		cur_value = number % place
		puts cur_value

		# Determine the range of numerals for this power of ten.
		#
		# Every power of ten requires three roman numerals to express:
		# The power itself, the "five" value of that power, and the
		# following power. For example, to express 10-90, we need
		# X (for 10-30), L (for 40-80) and C (for 90).
		#
		# If the rank of I is 0, then the highest rank needed to express
		# all values of the corresponding power is 2 * (rank + 1).
		range = power * 2
		high = $numerals[range].symbol
		five = $numerals[range-1].symbol
		low = $numerals[range-2].symbol

		# Assign the matched numeral(s) for the value.
		#
		# There is a pattern to how each power of ten can be represented.
		# In the following description, L, F, and H are low, five, and high
		# as above. "n" represents the number of ones above zero or five.
		# 	  9 	LH
		# 	>=5		FnL
		# 	  4		LF
		# 	>=0		nL
		if cur_value == 9
			roman.prepend low + high
		elsif cur_value >= 5
			ones = cur_value - 5
			roman.prepend five + (low * ones)
		elsif cur_value == 4
			roman.prepend low + five
		else
			roman.prepend(low * cur_value)
		end
	end

	return roman
end



letters = ARGV.first
num = Numeral.to_hindu(letters)
puts num
revert = Numeral.to_roman(num)
puts revert