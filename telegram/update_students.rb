# frozen_string_literal: true

require 'watir'
require File.expand_path('../config/environment', __dir__)

browser = Watir::Browser.new
browser.goto 'https://www.kn.vutbr.cz/is2/'

blocks = %w[B02 B04 B05 B07 A02 A04 A05 A03]

def to_database(array)
  array = array.split("\n")

  name_surname = array.first
  name = name_surname.split(' ').first
  surname = name_surname.split(' ').last

  array.delete(name_surname)
  array = array.map { |x| x.gsub(/\s+/, '') }
  array = array.reject { |e| e.to_s.empty? }

  block_num = array.first.split('Blok:').last

  room = array.last.split('Pokoj:').last

  Student.create(block: block_num, room: room.to_i, name: name, surname: surname)

  p array
  p name
  p surname
  p block_num
  p room
end

blocks.each do |block|
  if block == 'B04' || block == 'B07'
    floors = 13
    rooms = 20
  elsif block == 'B02' || block == 'B05'
    floors = 6
    rooms = 40
  else
    floors = 9
    rooms = 41
  end
  (1..floors).each do |floor|
    (1..rooms).each do |room|
      room = '0' + room.to_s if room < 10
      browser.text_field(name: 'str').set "#{block}-0#{floor}#{room}"
      browser.button(value: 'hledej').click

      text =  browser.tbody.text
      text = text.split('Zadejte hledaný řetezec:').last

      next unless text.include?('1. ')

      if text.include?('2. ')
        if text.include?('3. ')
          text = text.split('1. ').last
          text = text.split('2. ')
          last = text.delete_at(text.length - 1)
          last = last.split('3. ')
          text << last.first
          text << last.last
        else
          text = text.split('1. ').last
          text = text.split('2. ')
        end
      else
        text = text.split('1. ').last
      end
      if text.class == String
        to_database text
      else
        text.each do |element|
          to_database element
        end
      end
    end
  end
end

p 'done'
