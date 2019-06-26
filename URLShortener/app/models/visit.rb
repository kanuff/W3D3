# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  url_id     :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ApplicationRecord
  validates :url_id, :user_id, presence: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :url,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl

  def self.record_visit!(user, shortened_url)
    options = { :user_id => user.id, :url_id => shortened_url.id }
    self.new(options).save
  end
end
