module SearchesHelper
  def search_target_label
    params[:search_type] == "book_title" ? "Books" : "Users"
  end
end
