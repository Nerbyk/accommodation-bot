# frozen_string_literal: true

class AdminResponder < Responder
  def menu
    if message.text == '/start'
      start_message
    elsif message.text.include?('/accept_') || message.text.include?('/deny_')
      respond_to_access_request(*message.text.split('_'))
    else
      find_student(message.text)
    end
  end

  def start_message
    bot.api.send_message(chat_id: message.from.id, text: "<b>Admin Menu</b>\n\n" + start_message_text, parse_mode: 'HTML')
  end

  def change_access(user_id)
    user_req = User.find_by(telegram_id: user_id)
    user_req.access = !user_req.access
    user_req.save
  end

  def respond_to_access_request(decision, user_id)
    user_id.to_i
    decision = decision == '/accept' ? decision : !decision
    change_access(user_id)
    if decision
      bot.api.send_message(chat_id: user_id, text: "Your request has been accepted\n\nEnter /start to get information about full functionality")
      bot.api.send_message(chat_id: message.from.id, text: 'Accepted')
    else
      bot.api.send_message(chat_id: user_id, text: "Your request has been denied\n\nSorry, you are not able to use this private bot :(")
      bot.api.send_message(chat_id: message.from.id, text: 'Denied')
    end
  end
  attr_accessor :bot, :message, :user
end
