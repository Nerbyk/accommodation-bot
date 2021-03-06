# frozen_string_literal: true

require 'net/http'
class ParserController < ApplicationController
  def parse(req_str)
    response = Net::HTTP.post_form(URL, 'str': req_str).body
    response = formate response
    response = response.split('hledaný řetezec: --> ').last
    students = to_split(response)
    students.each do |student|
      name, surname = pull_info student
      block = req_str.split('-').first
      room  = req_str.split('-').last
      floor = room[1]
      p "Name: #{name} | Surname: #{surname} | block: #{block} | room: #{room} | floor: #{floor} "
      Student.create(name: name, surname: surname, block: block, room: room, floor: floor)
    end
  end

  private

  def formate(response)
    response = delete_tags response
    response = encode response
    response.gsub!(/\&nbsp;/, ' ')
    response.squeeze!(' ')
  end

  def to_split(response)
    students = []

    (1..3).reverse_each do |i|
      response = response.split("#{i}. ")
      if response.length == 2
        students << response.last
        response = response.first
      else
        response = response.join
      end
    end
    students
  end

  def pull_info(student)
    student = student.split('Jméno:').first.split(' ')
    [student.first, student.last]
  end
end
