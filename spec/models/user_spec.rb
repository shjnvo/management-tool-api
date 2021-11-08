require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_length_of(:name).is_at_least(5).is_at_most(50) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to have_many(:projects) }
  it { is_expected.to have_many(:project_users) }

  describe 'User methods' do
    let(:user) { create(:user) }
    let(:user_2) { create(:user) }
    let!(:project) { create(:project, creator: user) }
    let!(:project_2) { create(:project, creator: user_2) }
    let!(:column) { create(:column, project: project) }
    let!(:task) { create(:task, column: column) }
    let!(:project_user) { create(:project_user, project: project, user: user, role: 'owner') }
    let!(:project_user_2) { create(:project_user, project: project_2, user: user_2, role: 'owner') }
    context '#generate_token!' do
      it do
        user.generate_token!
        expect(user.token.present?).to be(true)
      end 
    end

    context '#reset_token!' do
      it do
        user.reset_token!
        expect(user.token.present?).to be(false)
      end 
    end

    context '#locked!' do
      it do
        user.locked!
        expect(user.locked?).to be(true)
      end 
    end

    context '#unlock!' do
      it do
        user.locked!
        user.unlock!
        expect(user.locked?).to be(false)
      end 
    end

    it '#project_role' do
      expect(user.project_role(project.id)).to eq 'owner'
      expect(user.project_role(project.id)).to_not eq 'admin'
      expect(user.project_role(project.id)).to_not eq 'member'
    end 

    it '#project_invited?' do
      expect(user.project_invited?(project.id)).to be(true)
      expect(user.project_invited?(project_2.id)).to be(false)
    end 
  end
end