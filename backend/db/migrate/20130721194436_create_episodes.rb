class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :number
      t.references :season, index: true

      t.timestamps
    end
  end
end
