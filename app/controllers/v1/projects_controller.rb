class V1::ProjectsController < ApplicationController
  before_action :find_project, except: [:create, :index]
  before_action :require_owner_role, only: [:update, :destroy]
  before_action :require_owner_admin_role, only: [:invite_user]

  def index
    projects = current_user.projects
    data = projects.as_json
    data.each {|pro| pro['my_role'] = current_user.project_role(pro['id'])}
    
    render json: { data: data }, status: :ok
  end

  def show
    data = @project.as_json(include: [{ columns: { include: { tasks: { include: :assigner } } } }, :users])

    render json: { data: data }, status: :ok
  end

  def create
    project = Project.new(project_params)
    project.creator = current_user
    if project.save
      ProjectUser.create!(project: project, user: current_user, role: :owner)
      render json: { message: I18n.t('responce_message.created', type: 'Project'), data: project }, status: :created
    else
      render json: { message: project.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @project.update(project_params)
      render json: { message: I18n.t('responce_message.updated', type: 'Project'), data: @project}, status: :ok
    else
      render json: { message: @project.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @project.destroy
    render json: { message: I18n.t('responce_message.destroyed', type: 'Project') }, status: :ok
  end

  def invite_user
    user = User.find_by(email: params[:email])

    return render json: { message: I18n.t('responce_message.not_found', type: 'User') } , status: :bad_request unless user

    project_user = ProjectUser.new(project: @project, user: user, role: params[:role])

    if project_user.save
      render json: { message: I18n.t('responce_message.invited') }, status: :ok
    else
      render json: { message: project_user.errors.full_messages }, status: :bad_request
    end
  end

  private

  def project_params
    params.permit(:title, :slug, :description, :status)
  end

  def find_project
    @project = Project.includes(columns: :tasks).find_by(id: params[:id])
    invited = current_user.project_invited?(@project.id)
    render json: { message: I18n.t('responce_message.not_found', type: 'Project') }, status: :bad_request unless @project && invited
  end

  def require_owner_role
    is_owner = current_user.owner_for?(@project.id)

    render json: { message: I18n.t('responce_message.not_permition') }, status: :not_acceptable unless is_owner
  end

  def require_owner_admin_role
    is_owner = current_user.owner_for?(@project.id)
    is_admin = current_user.admin_for?(@project.id)

    render json: { message: I18n.t('responce_message.not_permition') }, status: :not_acceptable unless is_owner || is_admin
  end
end
