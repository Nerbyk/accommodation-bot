# frozen_string_literal: true

class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :block
      t.integer :floor
      t.integer :room
      t.string :name
      t.string :surname

      t.timestamps
    end
  end
end
