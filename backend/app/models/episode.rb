# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  number     :integer
#  season_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#

class Episode < ActiveRecord::Base
  belongs_to :season
  has_many :scrobbles
  
  attr_accessible :number, :season_id, :name
  
  def to_s
  	if name
  		"#{season.show} - #{season.number}x#{number} - #{name}"
	else
		"#{season.show} - Season #{season.number} - Episode #{number}"
	end

  end
end
