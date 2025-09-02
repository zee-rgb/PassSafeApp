class Entry < ApplicationRecord
  belongs_to :user

  validates :name, :username, :password, presence: true, length: { minimum: 1, maximum: 255 }
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }

  encrypts :username, deterministic: true
  encrypts :password
end
