require 'rails_helper'

RSpec.describe Column, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to belong_to(:project) }
  it { is_expected.to have_many(:tasks) }
end
