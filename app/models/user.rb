class User < ApplicationRecord
  include Codeable
  has_paper_trail

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users

  validates :name, :email, presence: true
  validates :name, length: { in: 5..50 }
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :lockeds, -> { where(locked: true) }
  scope :unlockeds, -> { where(locked: false) }

  def generate_token!
    generate_code!(:token, n = 64)
    self.token
  end

  def reset_token!
    self.update(token: nil)
  end

  def locked!
    self.update(locked: true, locked_at: Time.zone.now)
  end

  def unlock!
    self.update(locked: false, locked_at: nil)
  end

  def project_role(project_id)
    project_role = project_users.find { |p_role| p_role.project_id == project_id }

    project_role.role
  end

  def owner_for?(project_id)
    project_role(project_id) == 'owner'
  end

  def admin_for?(project_id)
    project_role(project_id) == 'admin'
  end

  def member_for?(project_id)
    project_role(project_id) == 'member'
  end

  def project_invited?(project_id)
    projects.exists?(id: project_id)
  end
end
