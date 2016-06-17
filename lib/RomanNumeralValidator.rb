require_relative 'Numeral'

class RomanNumeralValidator
    def initialize(roman)
        @number_of_repetitions = @largest_power = @prev_rank = 0
        @last_char_was_prefix = false
        @roman = roman
    end


    def valid?
        # Read the string backwards, associate each character 
        # with a Numeral object. The string is read backwards to
        # avoid look-ahead for prefixed values.
        begin
            @roman.reverse.each_char.collect{|ch| Numeral::ALL[ch.to_sym]}
                .all?{ |char| validate_character char }
        rescue ArgumentError => e
             puts e.message
            return false
        end

        return true
    end


    def validate_character(char)
        if is_a_prefix? char
            run_prefix_tests char
            @last_char_was_prefix = true
        else
            adjust_largest_power
            add_to_repetitions char
            run_non_prefix_tests char
            @last_char_was_prefix = false
        end

        set_previous_rank char
        return true
    end


    # Prefixes have ranks lower than the character they follow
    def is_a_prefix?(char)
        char.rank < @prev_rank
    end


    def run_prefix_tests(ch)
        raise ArgumentError, "Multiple prefixes" if @last_char_was_prefix

        raise ArgumentError, "Can only prefix 1/5th or 1/10th of value" unless
            ch.can_prefix? @prev_rank

        raise ArgumentError, "Prefix exceeded or matched by earlier value" if
            ch.rank <= @largest_power
    end


    # Note that prefixed characters do not count towards repetitions
    def add_to_repetitions(char)
        if char.rank == @largest_power && !@last_char_was_prefix
            @number_of_repetitions += 1
        else
            @number_of_repetitions = 0
        end
    end


    # Largest_power will always be one character behind the cursor to make sure
    # the current character isn't prefixed. Prefixes never become largest_power
    def adjust_largest_power
        @largest_power = @prev_rank unless @last_char_was_prefix 
    end


    def run_non_prefix_tests(ch)
        raise ArgumentError, "Prefixes must be followed by values >=10x" if 
            @last_char_was_prefix && (ch.rank - @prev_rank < 2)

        raise ArgumentError, "Can only repeat powers of ten" if 
            ch.is_a_five? && ch.rank == @prev_rank

        raise ArgumentError, "Too many repetitions" if ch.rank == @prev_rank &&
            @number_of_repetitions > 2

        @last_char_was_prefix = false
    end


    def set_previous_rank(char)
        @prev_rank = char.rank
    end
end