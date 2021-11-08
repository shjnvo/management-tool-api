class Task < ApplicationRecord
  has_paper_trail
  
  belongs_to :column
  belongs_to :assigner, class_name: "User", foreign_key: :assigner_id, optional: true

  validates :title, presence: true
end
