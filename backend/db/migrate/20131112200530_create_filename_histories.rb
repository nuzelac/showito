class CreateFilenameHistories < ActiveRecord::Migration
  def change
    create_table :filename_histories do |t|
      t.string :filename
      t.references :user, index: true

      t.timestamps
    end
  end
end
