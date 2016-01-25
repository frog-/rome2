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

	# Create a new Number object from a numeral string
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
			else puts "Invalid numeral" ; abort
			end
		end

		# Track highest value seen yet
		cur_rank = @chars[0].rank
		# Monitor prefixes; only one character may be prefixed
		precede = false

		@chars.each do |ch|
			if ch.rank >= cur_rank
				@value += ch.value
				precede = false
				cur_rank = ch.rank if ch.rank > cur_rank
			else
				if precede == true
					puts "Invalid numeral" ; abort
				else
					@value -= ch.value
					precede = true
				end
			end
		end
	end
end

letters = ARGV.first
num = Number.new(letters)
puts num.value