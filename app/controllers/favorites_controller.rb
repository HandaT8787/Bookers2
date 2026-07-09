class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    favorite = Current.user.favorites.new(book_id: @book.id)
    favorite.save

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: books_path }
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = Current.user.favorites.find_by(book_id: @book.id)
    favorite&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: books_path }
    end
  end

end
