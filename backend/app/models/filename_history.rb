# == Schema Information
#
# Table name: filename_histories
#
#  id          :integer          not null, primary key
#  filename    :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  scrobble_id :integer
#

class FilenameHistory < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id, :filename, :scrobble_id
end
