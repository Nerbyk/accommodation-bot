require 'net/http'
class ParserController < ApplicationController
    def parse req_str 
       response = Net::HTTP.post_form(URL, 'str': req_str).body
       response = formate response 
       response = response.split('hledaný řetezec: --> ').last
       students = to_split(response)
       students.each do |student| 
            pull_info student
       end 
    end 

    private 

    def formate response 
       response = delete_tags response 
       response = encode response
       response.gsub!(/\&nbsp;/, ' ')
       response.squeeze!(" ")
    end 

    def to_split response 
       students = []

       (1..3).reverse_each do |i| 
            response = response.split("#{i.to_s}. ")
            if response.length == 2 
                students << response.last 
                response = response.first
            else  
                response = response.join
            end  
        end 
        students
    end 

    def pull_info student 
        # TODO: Pull info from string for db
    end 
end 