class BooksController < ApplicationController
before_action :is_matching_login_user, only: [:edit, :update]

  def create
    @book = Book.new(book_params)
    @book.user_id = Current.user.id

    if params[:tag_name].present?
      tag = Tag.find_or_create_by(name: params[:tag_name])
      @book.tag = tag
    end

    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      redirect_to books_path, flash: { errors: @book.errors.full_messages }
    end
  end

  def index
    condition = ["favorites.book_id = books.id AND favorites.created_at >= ?", 1.week.ago]
    @books = case params[:sort]
             when "score"
                Book.order(score: :desc)
             when "favorites"
                Book.ranked_by_weekly_favorites
             when "newest"
                Book.order(created_at: :desc)
             else
                Book.order(:title)
             end
    @new_book = Book.new
    @user = Current.user
    @sort = params[:sort]
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @new_book = Book.new
    @book_comment = BookComment.new
    @sort = params[:sort]

    @books = case params[:sort]
             when "score"
                @user.books.order(score: :desc)
             when "facorites"
                @user.books.merge(Book.ranked_by_weekly_favorites)
             when "newest"
                @user.books.order(created_at: :desc)
             else
                @user.books.order(:title)
             end

    @book.views.create
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if params[:tag_name].present?
      tag = Tag.find_or_create_by(name: params[:tag_name])
      @book.tag = tag
    end
    
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
    params.require(:book).permit(:title, :body, :score)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == Current.user.id
      redirect_to books_path
    end
  end

end
