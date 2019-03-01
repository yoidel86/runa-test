class CreateReportes < ActiveRecord::Migration[5.1]
  def change
    create_table :reportes do |t|
      t.references :user, foreign_key: true
      t.integer :generated_by
      t.date :date
      t.date :from
      t.date :to
      t.json :result

      t.timestamps
    end
  end
end
