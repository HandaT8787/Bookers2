class FavoritesController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    favorite = Current.user.favorites.new(book_id: book.id)
    favorite.save
    redirect_back fallback_location: books_path
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = Current.user.favorites.find_by(book_id: book.id)
    favorite&.destroy
    redirect_back fallback_location: books_path
  end

end
