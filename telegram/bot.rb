# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'
require 'dotenv'

require './telegram/responder/responder.rb'
require './telegram/responder/admin_responder.rb'

token = ENV['TELEGRAM_TOKEN']

# Telegram::Bot::Client.run(token) do |bot|
#   bot.listen do |message|
#     if message.from.id == ENV['ADMIN_ID'].to_i
#       AdminResponder.new(message, bot)
#     else
#       Responder.new(message, bot)
#     end
#   rescue StandardError => e
#     bot.api.send_message(chat_id: message.from.id, text: "error: #{e}")
#   end
# end


loop do
  begin
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        Thread.start(message) do |rqst|
          begin
            if message.from.id == ENV['ADMIN_ID'].to_i
              AdminResponder.new(message, bot)
            else
              Responder.new(message, bot)
            end
          rescue StandardError => e
            bot.api.send_message(chat_id: message.from.id, text: "error: #{e}")
          end
        end
      end
    end
  rescue StandardError => low_e 
    bot.api.send_message(chat_id: ENV['ADMIN_ID'].to_i, text: "LOW error from #{message.from.id}: #{low}")
  end 
end