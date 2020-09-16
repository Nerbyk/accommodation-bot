# frozen_string_literal: true


require File.expand_path('../config/environment', __dir__)

require 'webdrivers'

require 'net/http'
require 'uri'

URL = 'http://www.kn.vutbr.cz/is2/'

Student.delete_all

BLOCKS = %w[A03 A02 A04]

def to_database(array)

end

def parse_browser(block, floors, rooms)
  (1..floors).each do |floor|
    (1..rooms).each do |room|
    
    end
  end
end 

BLOCKS.each do |block|
  floors = 9
  rooms = 41

  Thread.new do  
      parse_browser(block, floors, rooms)
  end 

end




p 'done'


