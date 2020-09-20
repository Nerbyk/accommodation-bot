# frozen_string_literal: true

require 'uri'
module ApplicationHelper
  URL = URI(ENV['IS_LINK'])
  def encode str
    encoded = str.force_encoding('UTF-8')
    encoded = str.encode('utf-8', invalid: :replace, undef: :replace, replace: '?') unless encoded.valid_encoding?
    encoded
  end

  def delete_tags string
    string.split(/\<.*?\>/)
          .map(&:strip)
          .reject(&:empty?)
          .join(' ')
          .gsub(/\s,/, ',')
  end

  def test
    'passed'
  end
end
