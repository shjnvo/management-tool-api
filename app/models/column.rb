class Column < ApplicationRecord
  has_paper_trail
  
  belongs_to :project
  has_many  :tasks, dependent: :destroy

  validates :title, presence: true
end
