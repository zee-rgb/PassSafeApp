class Entry < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { minimum: 1, maximum: 100 }
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }
  validates :username, presence: true, length: { minimum: 1, maximum: 255 }
  validates :password, presence: true, length: { minimum: 1, maximum: 255 }
end
