class V1::TasksController < ApplicationController
  before_action :find_task, except: [:create]

  def create
    task = Task.new(task_params)
    if task.save
      render json: { message: I18n.t('responce_message.created', type: 'Task'), data: task }, status: :created
    else
      render json: { message: task.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @task.update(task_params)
      render json: { message: I18n.t('responce_message.updated', type: 'Task'), data: @task }, status: :ok
    else
      render json: { message: @task.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @task.destroy
    render json: { message: I18n.t('responce_message.destroyed', type: 'Task') }, status: :ok
  end

  private

  def task_params
    params.permit(:title, :description, :assigner_id, :column_id)
  end

  def find_task
    @task = Task.find_by(id: params[:id])
    render json: { message: I18n.t('responce_message.not_found', type: 'Task') }, status: :bad_request unless @task
  end
end
