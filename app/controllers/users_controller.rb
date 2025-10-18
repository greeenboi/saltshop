class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    role_name = user_params.delete(:role).presence || 'user'
    role = Role.find_by(name: role_name) || Role.find_by(name: 'user')

    @user = User.new(user_params)
    @user.role = role

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          @user.save!
          if role&.name&.downcase == 'admin'
            Admin.create!(user: @user)
          else
            Customer.create!(user: @user)
          end
        end

        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: "Account created successfully!" }
        format.json { render :show, status: :created, location: @user }
      rescue ActiveRecord::RecordInvalid => e
        # Transaction rolled back
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @user.errors.full_messages + [e.message] }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :username, :password, :role, :date_created, :name, :email, :bio, :photo_url ])
    end
end
