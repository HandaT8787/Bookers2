class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @book_comment = Current.user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book.id
    @book_comment.save

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to book_path(@book) }
    end
  end

  def destroy
    @book_comment = BookComment.find(params[:id])
    @book = @book_comment.book
    @book_comment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: book_path(@book) }
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
