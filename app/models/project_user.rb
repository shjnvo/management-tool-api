class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :role, presence: true, inclusion: { in: %w(owner admin member) }
  validates :project_id, uniqueness: { scope: :user_id }
end
