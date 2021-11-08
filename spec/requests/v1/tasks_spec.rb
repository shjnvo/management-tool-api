require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user) }
  let!(:member) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user_token) { JwtService.encode({ user_token: user.generate_token! }) }
  let!(:admin_token) { JwtService.encode({ user_token: admin.generate_token! }) }
  let!(:member_token) { JwtService.encode({ user_token: member.generate_token! }) }
  let!(:user_token4) { JwtService.encode({ user_token: other_user.generate_token! }) }
  let!(:project) { create(:project, creator: user) }
  let!(:column) { create(:column, project: project) }
  let!(:task) { create(:task, column: column) }
  let!(:project_user) { create(:project_user, project: project, user: user, role: 'owner') }
  let!(:invite_admin) { create(:project_user, project: project, user: admin, role: 'admin') }
  let!(:invite_member) { create(:project_user, project: project, user: member, role: 'member') }

  describe "POST /v1/tasks" do
    it 'returns http unauthorized without login' do
      post '/v1/tasks'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http success with owner' do
      params = {title: 'test title tasks', description: 'tasks description', column_id: column.id}
      post '/v1/tasks', headers: { 'Authentication': user_token }, params: params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(data['title']).to eq params[:title]
    end

    it 'returns http success with admin' do
      params = {title: 'test title tasks', description: 'tasks description', column_id: column.id}
      post '/v1/tasks', headers: { 'Authentication': admin_token }, params: params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(data['title']).to eq params[:title]
    end

    it 'returns http success with member' do
      params = {title: 'test title tasks', description: 'tasks description', column_id: column.id}
      post '/v1/tasks', headers: { 'Authentication': member_token }, params: params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(data['title']).to eq params[:title]
    end
  end

  describe "PATCH /v1/tasks/:id" do
    it 'returns http unauthorized without login' do
      patch "/v1/tasks/#{task.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http success with owner' do
      params = {title: 'test title tasks', description: 'tasks description', column_id: column.id}
      patch "/v1/tasks/#{task.id}", headers: { 'Authentication': user_token }, params: params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(data['title']).to eq params[:title]
    end

    it 'returns http success with admin' do
      params = {title: 'test title tasks', description: 'tasks description', column_id: column.id}
      patch "/v1/tasks/#{task.id}", headers: { 'Authentication': admin_token }, params: params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(data['title']).to eq params[:title]
    end

    it 'returns http success with member' do
      params = {title: 'test title tasks', description: 'tasks description', column_id: column.id}
      patch "/v1/tasks/#{task.id}", headers: { 'Authentication': member_token }, params: params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(data['title']).to eq params[:title]
    end
  end

  describe "DELETE /v1/tasks/:id" do
    it 'returns http unauthorized without login' do
      delete "/v1/tasks/#{task.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http success with owner' do
      delete "/v1/tasks/#{task.id}", headers: { 'Authentication': user_token }

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
    end

    it 'returns http success with admin' do
      delete "/v1/tasks/#{task.id}", headers: { 'Authentication': admin_token }

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
    end

    it 'returns http success with member' do
      delete "/v1/tasks/#{task.id}", headers: { 'Authentication': member_token }

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
    end
  end
end
