class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.date :date
      t.time :timein
      t.time :timeout
      t.integer :created_by
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
