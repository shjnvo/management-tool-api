class Project < ApplicationRecord
  extend FriendlyId

  has_paper_trail
  friendly_id :title, use: [:slugged]

  has_many :columns, -> { order(sort_order: :asc) }, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  belongs_to :creator, class_name: "User", foreign_key: :creator_id

  validates :title, presence: true

  def should_generate_new_friendly_id?
    title_changed? || super
  end
end
