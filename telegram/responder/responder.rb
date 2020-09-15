# frozen_string_literal: true

class Responder
  def initialize(message, bot)
    @message = message
    @bot     = bot
    @user    = validate
    menu
  end

  private

  def access_denied
    bot.api.send_message(chat_id: message.from.id, text: 'Your account is not activated for now')
  end
  
  def check_search_case(string)
    return 'surname' if string.first == '_'
    return 'name' if !!string.capitalize.match(/^[a-zA-Z]*$/)
    return 'name_surname' if !!string.capitalize.match(/^[a-zA-Z]{0,19}[\s,][a-zA-Z]{0,19}$/)
    return 'invalid'
  end 

  def render(request)
      request.each do |student|
        bot.api.send_message(chat_id: message.from.id, text: "Block: " + student.block + "\n"+
                                                             "Room: " + student.room.to_s + "\n" +
                                                             "Name Surname: " + student.name + " " + student.surname )
      end 


  end 

  def find_student(string)
      search_str = string
      search_by = check_search_case(string)
      case search_by 
      when 'name'
        request = Student.where(name: search_str)
      when 'surname'
        search_str[0] = ''
        request = Student.where(surname: search_str.capitalize)
      when 'name_surname'
        name, surname = search_str.split(' ')
        request = Student.where(name: name, surname: surname)
      else  
        raise 'Invalid Input'
      end 

      render request
      
  end

  def validate
    user = User.find_by(telegram_id: message.from.id)
    user = User.create(telegram_id: message.from.id, step: 'new', access: false) if user.nil?
    user
  end

  def menu
    unless user.access
      access_denied
      return
    end
    
    if message.text == '/start'
      bot.api.send_message(chat_id: message.from.id, text: "Для поиска по имени введи просто имя\n\nДля поиска по фамилии введи знак _перед фамилией (_Ivanov)\n\nДля Поиска по имени и фамилию введи имя и фамилию(Name Surname)")
    else 
      find_student(message.text)
    end  
  end

  attr_accessor :bot, :message, :user
end
