# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :telegram_id, index: true
      t.string :step
      t.boolean :access

      t.timestamps
    end
  end
end
