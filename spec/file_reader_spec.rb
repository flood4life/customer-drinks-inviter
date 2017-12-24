require 'minitest/autorun'
require_relative '../src/file_reader'

describe FileReader do
  describe 'when file is present' do
    describe 'when file is readable' do
      before do
        file = File.new('correct.json', 'w')
        file.write('123\n456')
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
      end
    end

    describe 'when file is not readable' do
      it 'raises a FilePermissionError' do
        file = File.new('not_readable', 'rw', 0o000) # UNIX permissions
        file.close
        assert_raises FilePermissionError do
          FileReader.new('not_readable')
        end
      end
    end
  end
  describe 'when file is not present' do
    it 'raises a DocumentError' do
      assert_raises DocumentError do
        FileReader.new('non_existent')
      end
    end
  end
end