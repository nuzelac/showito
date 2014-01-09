class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :number
      t.references :show, index: true

      t.timestamps
    end
  end
end
