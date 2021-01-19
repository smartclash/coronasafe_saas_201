require 'active_record'

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    display_status = completed ? '[X]' : '[ ]'
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    overdue_todos = where("due_date > ?", Date.today)
    todays_todos = where(due_date: Date.today)
    later_todos = where("due_date < ?", Date.today)

    puts 'Overdue'
    puts(overdue_todos.map { |todo| todo.to_displayable_string })

    puts "\n"

    puts 'Due Today'
    puts(todays_todos.map { |todo| todo.to_displayable_string })

    puts "\n"

    puts 'Due Later'
    puts(later_todos.map { |todo| todo.to_displayable_string })
  end
end
