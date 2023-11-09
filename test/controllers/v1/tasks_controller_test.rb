require 'test_helper'

class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest

  setup do
    setup_resources
  end

  def setup_resources
    @task = tasks(:one)
    # @user = users(:one)
  end

  test "should get index" do
    get api_v1_tasks_url
    task = JSON.parse(response.body)

    assert_response 200
    assert_not_empty(task['data'])
  end

  test "create with valid parameter" do
    post api_v1_tasks_url, params:{
        task:{
            name: "Name Testing ten",
            description: "description ten",
            status: "onprogress",
            deadline: "30/05/2025 02:34:56",
            user_id: 9999999999
        }
    }
    assert_response 200
    assert_not_empty(response.body['data'])
  end


  test "create with invalid parameter name is blank" do
    post api_v1_tasks_url, params:{
        task:{
            name: "",
            description: "description ten",
            status: "onprogress",
            deadline: "30/05/2025 02:34:56",
            user_id: 9999999999
        }
    }

    assert_response 422
    assert_equal(JSON.parse(response.body)["error"], "Name can't be blank")
  end

  test "create with invalid parameter status" do
    post api_v1_tasks_url, params:{
        task:{
            name: "name",
            description: "description ten",
            status: "onboard",
            deadline: "30/05/2025 02:34:56",
            user_id: 9999999999
        }
    }
    assert_response 422
    assert_equal(JSON.parse(response.body)["error"], "Status onboard is not a valid")
  end

  test "create with invalid parameter deadline is past" do
    post api_v1_tasks_url, params:{
        task:{
            name: "name",
            description: "description ten",
            status: "done",
            deadline: "30/05/2021 02:34:56",
            user_id: 9999999999
        }
    }
    assert_response 422
    assert_equal(JSON.parse(response.body)["error"], "Deadline is past")
  end

  test "create with invalid parameter user not exist" do
    post api_v1_tasks_url, params:{
        task:{
            name: "name",
            description: "description ten",
            status: "done",
            deadline: "30/05/2030 02:34:56",
            user_id: 1
        }
    }
    assert_response 422
    assert_equal(JSON.parse(response.body)["error"], "User must exist")
  end

  test "get task single with valid data" do
    get api_v1_task_url(@task)
    assert_response 200
    response = JSON.parse(body)

    assert_not_nil(response)
    assert_equal(response['data']['id'].to_i, @task.id)
  end

  test "get task single with invalid params" do
    get api_v1_task_url(99999999)
    response = JSON.parse(body)
    assert_response 404
    assert_equal(response["error"], "Task not found")
  end

  test "update with valid parameter" do
    put api_v1_task_url(@task), params:{
        task:{
            name: "Name Testing ten",
            description: "description ten",
            status: "onprogress",
            deadline: "30/05/2025 02:34:56",
            user_id: 9999999999
        }
    }
    assert_response 200
    assert_not_empty(response.body['data'])
  end


  test "delete task valid params" do
    delete api_v1_task_url(@task)
    assert_response 200
    assert_equal(body, "has been deleted")
  end

  test "delete task invalid params" do
    delete api_v1_task_url(9293923)
    assert_response 404
    assert_equal(JSON.parse(body)["error"], "Task not found")
  end
end
