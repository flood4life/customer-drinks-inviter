require 'minitest/autorun'
require_relative '../src/file_reader'

describe FileReader do
  describe 'when file is present' do
    describe 'when file is readable' do
      before do
        file = File.new('correct.json', 'w')
        file.puts('123')
        file.puts('456')
        file.close
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
        file = File.new(filename, 'w')
        file.chmod(0o000) # UNIX permissions
        file.close
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