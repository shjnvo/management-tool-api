require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  it { is_expected.to validate_presence_of(:role) }
  it { is_expected.to validate_inclusion_of(:role).in_array(%w(owner admin member)) }
  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_uniqueness_of(:project_id).scoped_to(:user_id) }
end
