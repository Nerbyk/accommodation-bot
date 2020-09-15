# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)

require 'telegram/bot'

Dir['./responder/*.rb'].sort.each { |file| require file }

token = ENV['TELEGRAM_TOKEN']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    Responder.new(message, bot)
  rescue StandardError => e
    bot.api.send_message(chat_id: message.from.id, text: "error: #{e}")
  end
end
