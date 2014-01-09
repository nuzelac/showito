# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  number     :integer
#  show_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Season < ActiveRecord::Base
  belongs_to :show
  has_many :episodes
  
  attr_accessible :number, :show_id
  
  def to_s
    "#{show.name} - Season #{number}"
  end
end
