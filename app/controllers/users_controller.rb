class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  before_action :is_matching_login_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to user_path(@user.id), notice: "Welcome! You have signed up successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all
    @user = Current.user
    @new_book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @new_book = Book.new
    counts = @user.books
                  .where(created_at: 6.days.ago.beginning_of_day..Time.current)
                  .group("DATE(created_at)")
                  .count
    @daily_counts = (6.days.ago.to_date..Date.current).map do |date|
      [date, counts[date.to_s] || counts[date] || 0]
    end

    if params[:date].present?
      begin
        @selected_date = Date.parse(params[:date])
        @selected_date_count = @user.books
                                    .where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
                                    .count
      rescue ArgumentError
        @selected_date = nil
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following
    render "show_follow"
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :profile_image, :introduction)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == Current.user.id
      redirect_to user_path(Current.user.id)
    end
  end

  def calc_percentage(current, previous)
    return nil if previous.zero?
    (current / previous * 100).round(1)
  end

end
