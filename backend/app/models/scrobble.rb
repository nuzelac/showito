# == Schema Information
#
# Table name: scrobbles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  episode_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Scrobble < ActiveRecord::Base  
  include PublicActivity::Model
  tracked skip_defaults: true  
  
  belongs_to :user
  belongs_to :episode
  
  attr_accessible :user_id, :episode_id
end
