class BooksController < ApplicationController
before_action :is_matching_login_user, only: [:edit, :update]

  def create
    @book = Book.new(book_params)
    @book.user_id = Current.user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      redirect_to books_path, flash: { errors: @book.errors.full_messages }
    end
  end

  def index
    @books = Book.includes(:user).all
    @new_book = Book.new
    @user = Current.user
  end

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == Current.user.id
      redirect_to books_path
    end
  end

end
