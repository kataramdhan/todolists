class TaskSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :status, :deadline, :user_id, :created_at, :updated_at
end
