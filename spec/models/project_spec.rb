require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to belong_to(:creator) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:columns) }
  it { is_expected.to have_many(:project_users) }
end
