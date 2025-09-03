class AuditEvent < ApplicationRecord
  belongs_to :user
  belongs_to :entry, optional: true

  validates :action, presence: true, length: { maximum: 50 }
  validates :ip, length: { maximum: 255 }, allow_blank: true
  validates :user_agent, length: { maximum: 1000 }, allow_blank: true
end
