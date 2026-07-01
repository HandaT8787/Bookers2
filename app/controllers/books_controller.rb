class BooksController < ApplicationController

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
    @book = Book.new
    @user = Current.user
  end

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to book_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image)
  end
end
