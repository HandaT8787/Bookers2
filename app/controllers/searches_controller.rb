class SearchesController < ApplicationController

  def index
    @results = case params[:search_type]
    when "book_title"
      Book.search_for(params[:keyword], params[:match_type])
    when "user_name"
      User.search_for(params[:keyword], params[:match_type])
    when "tag_name"
      Book.search_by_tag(params[:keyword], params[:match_type])
    else
      []
    end
  end

end

