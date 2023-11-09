module Api
    module V1
      class TasksController < ApplicationController
        
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        rescue_from ActionController::ParameterMissing, with: :parameter_missing
        rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

        before_action :find_task, only: [:show, :update, :destroy]

        def index
            tasks = Task.all
            render json: TaskSerializer.new(tasks).serializable_hash.to_json, status: :ok
        end

        def create
            @task = Task.new(task_params)
            if @task.save!
                render json: TaskSerializer.new(@task).serializable_hash.to_json, status: :ok
            else
                render json: { error: 'Unable to create task' }, status: :unprocessable_entity
            end
        end

        def show
            render json: TaskSerializer.new(@task).serializable_hash.to_json, status: :ok
        end

        def update
            if @task.update!(task_params)
                render json: TaskSerializer.new(@task).serializable_hash.to_json, status: :ok
            else
                render json: { error: 'Unable to update task' }, status: :unprocessable_entity
            end
        end

        def destroy
            if @task.destroy
                render json: "has been deleted", status: :ok
            end
        end


        private

        def task_params
            params.require(:task).permit(:name, :description, :status, :deadline, :user_id)
        end 

        def find_task 
            @task = Task.find(params[:id])
        end

        def record_not_found
            render json: { error: 'Task not found' }, status: :not_found
        end
    
        def parameter_missing
            render json: { error: 'Missing parameter' }, status: :unprocessable_entity
        end

        def record_invalid(exception)
             render json: { error: exception.record.errors.full_messages.join(',') }, status: :unprocessable_entity
        end
    
      end
    end
end