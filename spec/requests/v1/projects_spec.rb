require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user) }
  let!(:memeber) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user_token) { JwtService.encode({ user_token: user.generate_token! }) }
  let!(:admin_token) { JwtService.encode({ user_token: admin.generate_token! }) }
  let!(:member_token) { JwtService.encode({ user_token: memeber.generate_token! }) }
  let!(:other_token) { JwtService.encode({ user_token: other_user.generate_token! }) }
  let!(:project) { create(:project, creator: user) }
  let!(:column) { create(:column, project: project) }
  let!(:task) { create(:task, column: column) }
  let!(:project_user) { create(:project_user, project: project, user: user, role: 'owner') }
  let!(:invite_admin) { create(:project_user, project: project, user: admin, role: 'admin') }
  let!(:invite_member) { create(:project_user, project: project, user: memeber, role: 'member') }

  describe "GET /v1/projects" do
    it 'returns http unauthorized without login' do
      get '/v1/projects'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'get list projects with creator' do
      get '/v1/projects', headers: { 'Authentication': user_token }
      data = JSON.parse(response.body)['data']

      expect(response).to have_http_status(:success)
      expect(data.first['creator_id'].to_i).to eq user.id
    end

    it 'get list projects with invite admin' do
      get '/v1/projects', headers: { 'Authentication': admin_token }
      data = JSON.parse(response.body)['data']

      expect(response).to have_http_status(:success)
      expect(data.first['id'].to_i).to eq project.id
    end

    it 'get list projects with invite member' do
      get '/v1/projects', headers: { 'Authentication': member_token }
      data = JSON.parse(response.body)['data']

      expect(response).to have_http_status(:success)
      expect(data.first['id'].to_i).to eq project.id
    end

    it 'whitout list projects with uninvited user' do
      get '/v1/projects', headers: { 'Authentication': other_token }
      data = JSON.parse(response.body)['data']

      expect(response).to have_http_status(:success)
      expect(data).to eq []
    end
  end

  describe 'GET /v1/projects/:id' do
    it 'returns http unauthorized without login' do
      get "/v1/projects/#{project.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http bad_request with uninvited user' do
      get "/v1/projects/#{project.id}", headers: { 'Authentication': other_token }

      expect(response).to have_http_status(:bad_request)
    end

    it 'show project with creator' do
      get "/v1/projects/#{project.id}", headers: { 'Authentication': user_token }
      data = JSON.parse(response.body)['data']

      expect(response).to have_http_status(:success)
      expect(data['id']).to eq project.id
    end

    it 'show project with admin' do
      get "/v1/projects/#{project.id}", headers: { 'Authentication': admin_token }
      data = JSON.parse(response.body)['data']

      expect(response).to have_http_status(:success)
      expect(data['id']).to eq project.id
    end

    it 'show project with member' do
      get "/v1/projects/#{project.id}", headers: { 'Authentication': member_token }
      data = JSON.parse(response.body)['data']

      expect(response).to have_http_status(:success)
      expect(data['id']).to eq project.id
    end
  end

  describe 'POST /v1/projects' do
    it 'returns http unauthorized without login' do
      post '/v1/projects'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http success with user' do
      params = {title: 'test title project', description: 'project description', status: 'status'}
      post '/v1/projects', headers: { 'Authentication': user_token }, params: params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(data['title']).to eq params[:title]
      expect(user.owner_for?(project.id)).to be_truthy
    end
  end

  describe 'PATCH /v1/projects/:id' do
    it 'returns http unauthorized without login' do
      patch "/v1/projects/#{project.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http success whith owner' do
      params = {title: 'test edit title project', description: 'project edit description', status: 'edit status'}
      patch "/v1/projects/#{project.id}", headers: { 'Authentication': user_token }, params: params

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
      expect(data['title']).to eq params[:title]
    end

    it 'returns http not_acceptable whith admin' do
      params = {title: 'test edit title project', description: 'project edit description', status: 'edit status'}
      patch "/v1/projects/#{project.id}", headers: { 'Authentication': admin_token }, params: params

      expect(response).to have_http_status(:not_acceptable)
    end

    it 'returns http not_acceptable whith member' do
      params = {title: 'test edit title project', description: 'project edit description', status: 'edit status'}
      patch "/v1/projects/#{project.id}", headers: { 'Authentication': member_token }, params: params

      expect(response).to have_http_status(:not_acceptable)
    end
  end

  describe 'DELETE /v1/projects/:id' do
    it 'returns http unauthorized without login' do
      delete "/v1/projects/#{project.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http success whith owner' do
      delete "/v1/projects/#{project.id}", headers: { 'Authentication': user_token }

      data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:success)
    end

    it 'returns http not_acceptable whith admin' do
      delete "/v1/projects/#{project.id}", headers: { 'Authentication': admin_token }

      expect(response).to have_http_status(:not_acceptable)
    end

    it 'returns http not_acceptable whith member' do
      delete "/v1/projects/#{project.id}", headers: { 'Authentication': member_token }

      expect(response).to have_http_status(:not_acceptable)
    end
  end

  describe 'POST /v1/projects/:id/invite_user' do
    it 'returns http unauthorized without login' do
      post "/v1/projects/#{project.id}/invite_user"

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http success when invite user is admin by owner' do
      params = {email: other_user.email, role: 'admin' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': user_token }, params: params

      expect(response).to have_http_status(:success)
    end

    it 'returns http success when invite user is member by owner' do
      params = {email: other_user.email, role: 'member' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': user_token }, params: params
      
      expect(response).to have_http_status(:success)
    end

    it 'returns http bad_request when invite user is wrong role by owner' do
      params = {email: other_user.email, role: 'wrong_role' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': user_token }, params: params
      
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http success when invite user is admin by admin' do
      params = {email: other_user.email, role: 'admin' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': admin_token }, params: params

      expect(response).to have_http_status(:success)
    end

    it 'returns http success when invite user is member by admin' do
      params = {email: other_user.email, role: 'member' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': admin_token }, params: params
      
      expect(response).to have_http_status(:success)
    end

    it 'returns http bad_request when invite user is wrong role by admin' do
      params = {email: other_user.email, role: 'wrong_role' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': admin_token }, params: params
      
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http not_acceptable when invite user is admin by member' do
      params = {email: other_user.email, role: 'admin' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': member_token }, params: params

      expect(response).to have_http_status(:not_acceptable)
    end

    it 'returns http not_acceptable when invite user is member by member' do
      params = {email: other_user.email, role: 'member' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': member_token }, params: params
      
      expect(response).to have_http_status(:not_acceptable)
    end

    it 'returns http not_acceptable when invite user is wrong role by member' do
      params = {email: other_user.email, role: 'wrong_role' }
      post "/v1/projects/#{project.id}/invite_user", headers: { 'Authentication': member_token }, params: params
      
      expect(response).to have_http_status(:not_acceptable)
    end
  end
end
