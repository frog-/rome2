class Numeral
	attr_reader :symbol, :value, :rank

	def initialize(symbol, value, rank)
		@symbol = symbol
		@value = value
        @rank = rank
	end

	def can_prefix?(other_rank)
		other_rank - @rank <= 2
	end

    def is_a_five?
        rank % 2 == 0
    end

    ALL = {
        I: Numeral.new("I", 1, 1),
        V: Numeral.new("V", 5, 2),
        X: Numeral.new("X", 10, 3),
        L: Numeral.new("L", 50, 4),
        C: Numeral.new("C", 100, 5),
        D: Numeral.new("D", 500, 6),
        M: Numeral.new("M", 1000, 7),
        v: Numeral.new("v", 5000, 8),
        x: Numeral.new("x", 10000, 9),
        l: Numeral.new("l", 50000, 10),
        c: Numeral.new("c", 100000, 11),
        d: Numeral.new("d", 500000, 12),
        m: Numeral.new("m", 1000000, 13)
    }
end


# Note!
# Because of how numbers > 1000 are stored, case checking must be done
# by the frontend
