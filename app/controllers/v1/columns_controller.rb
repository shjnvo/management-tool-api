class V1::ColumnsController < ApplicationController
  before_action :find_column, except: [:create]

  def create
    column = Column.new(column_params)
    if column.save
      render json: { message: I18n.t('responce_message.created', type: 'Column'), data: column }, status: :created
    else
      render json: { message: column.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @column.update(column_params)
      render json: { message: I18n.t('responce_message.updated', type: 'Column'), data: @column }, status: :ok
    else
      render json: { message: @column.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @column.destroy
    render json: { message: I18n.t('responce_message.destroyed', type: 'Column') }, status: :ok
  end

  private

  def column_params
    params.permit(:title, :description, :sort_order, :project_id)
  end

  def find_column
    @column = Column.includes(:tasks).find_by(id: params[:id])
    render json: { message: I18n.t('responce_message.not_found', type: 'Column') }, status: :bad_request unless @column
  end
end
