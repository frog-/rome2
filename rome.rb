class Number	
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
	
	#
	# Members of the base class:
	# Each Numeral exists once statically
	#
	attr_accessor :value
	attr_accessor :chars

	@@char_i = Numeral.new("I", 1, 0)
	@@char_v = Numeral.new("V", 5, 1)
	@@char_x = Numeral.new("X", 10, 2)
	@@char_l = Numeral.new("L", 50, 3)
	@@char_c = Numeral.new("C", 100, 4)
	@@char_d = Numeral.new("D", 500, 5)
	@@char_m = Numeral.new("M", 1000, 6)

	# Create a new Number object from a romanized string
	def initialize(roman)
		@value = 0
		@chars = []

		# Read the string backwards, associate each character 
		# with a Numeral object. The string is read backwards to
		# avoid look-ahead for prefixed values
		roman.upcase.reverse.split("").each do |ch|
			case ch
			when "I" then @chars << @@char_i
			when "V" then @chars << @@char_v
			when "X" then @chars << @@char_x
			when "L" then @chars << @@char_l
			when "C" then @chars << @@char_c
			when "D" then @chars << @@char_d
			when "M" then @chars << @@char_m
			else puts "Invalid symbols" ; abort
			end
		end

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
		@chars.each do |ch|
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
				@value += ch.value
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
				@value -= ch.value
				prefix = true
				prev_rank = ch.rank
				prev_symbol = ch.symbol
			end
		end
	end
end

letters = ARGV.first
num = Number.new(letters)
puts num.value