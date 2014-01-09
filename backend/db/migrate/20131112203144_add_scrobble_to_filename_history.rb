class AddScrobbleToFilenameHistory < ActiveRecord::Migration
  def change
    add_reference :filename_histories, :scrobble, index: true
  end
end
