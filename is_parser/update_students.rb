# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)

Student.delete_all

BLOCKS = %w[A03 A02 A04].freeze

def parse_browser(block, floors, rooms)
  (1..floors).each do |floor|
    (1..rooms).each do |room|
      room = '0' + room.to_s if room < 10

      parser = ParserController.new
      parser.parse("#{block}-0#{floor}#{room}")
    end
  end
end

BLOCKS.each do |block|
  floors = 9
  rooms = 41

  # Thread.new do
  parse_browser(block, floors, rooms)
  # end
end

# p delete_tags res.body
