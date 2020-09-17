require 'uri'
module ApplicationHelper
    URL = URI('http://www.kn.vutbr.cz/is2/')
    def encode str
        encoded = str.force_encoding('UTF-8')
        unless encoded.valid_encoding?
          encoded = str.encode("utf-8", invalid: :replace, undef: :replace, replace: '?')
        end
        encoded
      end
      
      def delete_tags string 
        string.split(/\<.*?\>/)
         .map(&:strip)
         .reject(&:empty?)
         .join(' ')
         .gsub(/\s,/,',')
      end 

      def test 
        'passed'
      end 
end
