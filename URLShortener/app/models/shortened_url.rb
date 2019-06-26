# == Schema Information
#
# Table name: shortened_urls
#
#  id        :integer          not null, primary key
#  long_url  :string           not null
#  short_url :string           not null
#  user_id   :integer          not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true
  validates :short_url, presence: true, uniqueness: true
  validates :user_id, presence: true

  belongs_to :submitter,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :user

  def self.random_code
    short = SecureRandom.urlsafe_base64
    while self.exists?(:short_url => short)
      short = SecureRandom.urlsafe_base64
    end
    short
  end

  def self.create!(user, long_url)
    short_url = self.random_code
    options = { :user_id => user.id, :long_url => long_url, :short_url => short_url}
    self.new(options).save
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visits.where(['created_at > ?', 10.minutes.ago]).select(:user_id).distinct.count
  end

end
