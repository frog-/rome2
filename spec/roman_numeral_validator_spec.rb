require 'RomanNumeralValidator'
require 'Numeral'

describe 'RomanNumeralValidator' do
	context 'given a single numeral' do
		it 'passes' do
			expect(RomanNumeralValidator.new("I").valid?).to be true
			expect(RomanNumeralValidator.new("L").valid?).to be true
			expect(RomanNumeralValidator.new("M").valid?).to be true
			expect(RomanNumeralValidator.new("c").valid?).to be true
		end
	end

	describe 'repetitions' do
		context 'given up to three like powers of ten in a row' do
			it 'passes' do
				expect(RomanNumeralValidator.new("XX").valid?).to be true
				expect(RomanNumeralValidator.new("ccc").valid?).to be true
			end
		end

		context 'given more than three like powers of ten' do
			it 'fails' do
				expect(RomanNumeralValidator.new("IIII").valid?).to be false
				expect(RomanNumeralValidator.new("mmmm").valid?).to be false
			end
		end

		context 'given two like fives in a row' do
			it 'fails' do
				expect(RomanNumeralValidator.new("VV").valid?).to be false
				expect(RomanNumeralValidator.new("dd").valid?).to be false
			end
		end

		context 'given multiple prefixes' do
			it 'fails' do
				expect(RomanNumeralValidator.new("IIX").valid?).to be false
				expect(RomanNumeralValidator.new("XXXL").valid?).to be false
			end
		end
	end

	describe 'order of symbols' do
		context 'given successive powers of ten' do
			it 'passes' do
				expect(RomanNumeralValidator.new("MCXI").valid?).to be true
				expect(RomanNumeralValidator.new("mmmCCCXXI").valid?).to be true
			end
		end

		context 'given non-successive powers of ten' do
			it 'fails' do
				expect(RomanNumeralValidator.new("CCMXXXI").valid?).to be false
				expect(RomanNumeralValidator.new("XCM").valid?).to be false
			end
		end

		context 'given a prefix on the first occurrence of a symbol' do
			it 'passes' do
				expect(RomanNumeralValidator.new("XIX").valid?).to be true
				expect(RomanNumeralValidator.new("XL").valid?).to be true
				expect(RomanNumeralValidator.new("CCCXC").valid?).to be true
			end
		end
	end
end