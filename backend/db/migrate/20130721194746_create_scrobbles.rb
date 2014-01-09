class CreateScrobbles < ActiveRecord::Migration
  def change
    create_table :scrobbles do |t|
      t.references :user, index: true
      t.references :episode, index: true

      t.timestamps
    end
  end
end
