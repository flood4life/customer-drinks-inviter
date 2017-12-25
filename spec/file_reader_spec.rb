require 'minitest/autorun'
require_relative '../lib/file_reader'

describe FileReader do
  describe 'when file is present' do
    describe 'when file is readable' do
      before do
        File.open('correct.json', 'w') do |f|
          f.puts('123')
          f.puts('456')
        end
        @file_reader = FileReader.new('correct.json')
      end

      after do
        File.delete('correct.json')
      end

      describe '#each_line' do
        it 'yields file lines one at a time' do
          read_lines = []
          @file_reader.each_line do |line|
            read_lines << line
          end
          assert_equal %w[123 456], read_lines
        end

        it 'raises an error when no block is given' do
          error = assert_raises LocalJumpError do
            @file_reader.each_line
          end
          assert_match(/no block given/, error.message)
        end
      end
    end

    describe 'when file is not readable' do
      it 'raises a FileReader::PermissionError' do
        filename = 'not_readable'
        File.open(filename, 'w', 0o000) do
          # empty block
        end
        assert_raises FileReader::PermissionError do
          FileReader.new(filename)
        end
        File.chmod(0o777, filename)
        File.delete(filename)
      end
    end
  end
  describe 'when file is not present' do
    it 'raises an ArgumentError' do
      error = assert_raises ArgumentError do
        FileReader.new('non_existent')
      end
      assert_match(/File with a name `non_existent` is not present/, error.message)
    end
  end
end