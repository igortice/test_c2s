class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  # aqui foi uma estratégia para não precisar de autenticação para a rota notification_callback
  before_action :authenticate_user!, except: %i[notification_callback]
  # before_action :verify_docker_host, only: [:notification_callback]
  skip_before_action :verify_authenticity_token, only: [:notification_callback]

  # GET /tasks
  def index
    @tasks = current_user.tasks
  end

  # GET /tasks/:id
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.new
  end

  # POST /tasks
  def create
    service = CreateAndProcessTaskService.new(
      user:        current_user,
      task_params: task_params
    )

    result = service.call

    if result.success?
      redirect_to tasks_path, notice: 'Tarefa criada e enviada para processamento com sucesso.'
    else
      @task             = current_user.tasks.new(task_params)
      flash.now[:alert] = 'Falha ao criar tarefa: ' + result.failure[:error]
      render new_task_path
    end
  end

  # GET /tasks/:id/edit
  def edit
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Tarefa atualizada com sucesso."
    else
      render :edit
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Tarefa excluída com sucesso."
  end

  def notification_callback
    data = {
      task_id:     params[:task_id],
      task_status: params[:task_status],
      user_id:     params[:user_id],
      details:     params[:callback_data]
    }

    service = NotificationService.new(**data)
    result  = service.call

    if result.success?
      render json: { message: result.value! }, status: :ok
    else
      status = case result.failure
                 when "Task not found" then :not_found
                 when "Missing required parameters" then :bad_request
                 else :unprocessable_entity
               end
      render json: { error: result.failure }, status: status
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: "Tarefa não encontrada."
  end

  def task_params
    params.require(:task).permit(:title, :description, :url)
  end

  def verify_docker_host
    Rails.logger.info "Received request from IP: #{request.remote_ip}"
    allowed_ips = %w[127.0.0.1 172.19.0.4]
    unless allowed_ips.include?(request.remote_ip)
      render json: { error: "Access denied" }, status: :forbidden
    end
  end
end
