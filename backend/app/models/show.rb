# == Schema Information
#
# Table name: shows
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  banner_file_name    :string(255)
#  banner_content_type :string(255)
#  banner_file_size    :integer
#  banner_updated_at   :datetime
#

class Show < ActiveRecord::Base
  attr_accessible :name, :banner
  has_many :seasons

  has_attached_file :banner, styles: {
    thumb: '50x50>',
    square: '200x200#',
    medium: '300x300>'
  }
  do_not_validate_attachment_file_type :banner
  
  def to_s
    name
  end
end
