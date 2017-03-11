module UserDoc
  extend ActiveSupport::Concern

  included do
    swagger_controller :users, "User Management"

    swagger_api :index do
      summary "Fetches all User items 1111"
      notes "This lists all the active users 2222"
    end

    swagger_api :show do
      summary "Fetches user by id"
      notes "Find user by id"
      param :path, :id, :integer, :optional, "User Id"
      response :unauthorized
      response :not_acceptable, "The request you made is not acceptable"
      response :requested_range_not_satisfiable
    end

    swagger_api :create do |api|
      summary "Create a new User item"
      notes "Notes for creating a new User item"
      Api::V1::UsersController::add_common_params(api)
      response :unauthorized
      response :not_acceptable, "The request you made is not acceptable"
      response :unprocessable_entity
    end

    swagger_api :update do |api|
      summary "Update a existed User item"
      notes "Notes for updating a existed User item"
      param :path, :id, :integer, :optional, "User Id"
      Api::V1::UsersController::add_common_params(api)
      response :unauthorized
      response :not_acceptable, "The request you made is not acceptable"
      response :unprocessable_entity
    end
  end

  def self.included(base)
    base.class_eval do
      def self.add_common_params(api)
        api.param :form, "user[name]", :string, :optional, "Name"
        api.param :form, "user[email]", :string, :optional, "Email"
        api.param :form, "user[password]", :string, :optional, "Password"
        api.param :form, "user[password_confirmation]", :string, :optional, "Password cofirmation"
      end
    end
  end

end
