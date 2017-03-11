module Api::V1
  class UsersController < ApiController
    include UserDoc

    before_action :set_user, only: [:show, :update, :destroy]

    def index
      puts "\n\n--------------Token: #{@token} \n\n"
      render json: User.all
    end

    def show
      user = User.find(params[:id])
      if user.present?
        render json: user
      else
        render json: { message: "User can't be found!" }
      end
    end

    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
    end

    private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

  end
end
