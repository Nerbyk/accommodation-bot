# frozen_string_literal: true

class Responder
  def initialize(message, bot)
    @message = message
    @bot     = bot
    @user    = validate
    menu
  end

  protected

  def access_denied
    bot.api.send_message(chat_id: message.from.id, text: 'Your account is not activated for now')
  end

  def check_search_case(string)
    return 'surname' if string.first == '_'
    return 'name' if !!string.capitalize.match(/^[a-zA-Z]*$/)
    return 'name_surname' if !!string.capitalize.match(/^[a-zA-Z]{0,19}[\s,][a-zA-Z]{0,19}$/)
    return 'floor' if !!string.match(/^[A-Ba-b]{1}0[1-7]{1}-[1-9]{1}$/)
    return 'room' if !!string.match(/^[A-Ba-b]{1}0[1-7]{1}-[0-9]{4}$/)

    'invalid'
  end

  def find_neighbor(request)
    searched_student = { name: request.name, surname: request.surname }
    neighbors = Student.where(room: request.room, block: request.block)
    neighbors = neighbors.map do |student|
      if student.name == searched_student[:name] && student.surname == searched_student[:surname]
        nil
      else
        student
      end
    end
    neighbors = neighbors.compact.map do |neighbor|
      neighbor.name + ' ' + neighbor.surname
    end
    neighbors.join(',')
  end

  def render_person(request)
    rendered_msg = ''
    request.each_with_index do |student, i|
      neighbors = find_neighbor(student)
      neighbors = 'None' if neighbors.empty?
      rendered_msg += 'Block: ' + student.block + "\n" \
                     'Room: ' + student.room.to_s + "\n" \
                     'Name Surname: ' + student.name + ' ' + student.surname + "\n" \
                     'Neighbors: ' + neighbors + "\n================" + "\n\n"

      if (i % 7).zero? && i != 0
        bot.api.send_message(chat_id: message.from.id, text: rendered_msg)
        rendered_msg = ''
      elsif request.length - 1 == i
        bot.api.send_message(chat_id: message.from.id, text: rendered_msg)
      end
    end
  end

  def log_search(string)
    user.step = string
    user.save
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
    when 'floor'
      block, floor = string.split('-')
      request = Student.where(block: block, floor: floor.to_i)
      request = uniq_request request

    when 'room'
      block, room = string.split('-')
      request = Student.where(block: block, room: room.to_i)
      request = request.first 
    else
      raise 'Invalid Input'
    end

    log_search(string)
    render_person request
  end

  def uniq_request(request)
    request = request.each_with_index.map do |student, i|
      if i != 0
        student.room == request[i - 1].room ? nil : student
      end
    end
    request.compact!
  end

  def validate
    user = User.find_by(telegram_id: message.from.id)
    if user.nil?
      user = User.create(telegram_id: message.from.id, step: 'new', access: false)
      bot.api.send_message(chat_id: ENV['ADMIN_ID'], text: "New <a href=\"tg://user?id=#{message.from.id}\">User</a> Joined Bot.\n\n/accept_#{message.from.id} or /deny_#{message.from.id}", parse_mode: 'HTML')
    end
    user
  end

  def updated_at
    Student.first.updated_at.strftime('%a %d %b %Y').to_s
  end

  def available_blocks
    Student.distinct.pluck(:block).join(', ')
  end

  def start_message_text
    "<b>Last Update:</b> #{updated_at}\n<b>Available Blocks:</b> #{available_blocks}\n\n<b>Usage:</b>\n\n" \
      "Enter student <i>Name</i> to search by name(e.g. Bob)\n\n" \
      "Enter student <i>_Surname</i> to search by surname(e.g. _Black)\n\n" \
      "Enter <i>Name Surname</i> to search by name and surname(e.g. Bob Black)\n\n" \
      'Enter <i>Block-Floor</i> to get a list for the entire floor(e.g. A03-7)' \
      'Enter <i>Block-Room</i> to search by room(e.g. A03-123'
  end

  def start_message
    bot.api.send_message(chat_id: message.from.id, text: start_message_text, parse_mode: 'HTML')
    p available_blocks
  end

  def menu
    unless user.access
      access_denied
      return
    end

    if message.text == '/start'
      start_message
    else
      find_student(message.text)
    end
  end

  attr_accessor :bot, :message, :user
end
