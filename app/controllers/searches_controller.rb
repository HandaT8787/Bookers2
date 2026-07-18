class SearchesController < ApplicationController

  def index
    keyword = params[:keyword]

    if params[:search_type] == "book_title"
      @results = Book.where(title_condition(keyword))
    elsif params[:search_type] == "user_name"
      @results = User.where(name_condition(keyword))
    elsif params[:search_type] == "tag_name"
      @results = Book.joins(:tag).where(tag_condition(keyword))
    else
      @results = []
    end
  end

  private

  def title_condition(keyword)
    ["title #{like_operator} ?", formatted_keyword(keyword)]
  end

  def name_condition(keyword)
    ["name #{like_operator} ?", formatted_keyword(keyword)]
  end

  def tag_condition(keyword)
    ["tags.name #{like_operator} ?", formatted_keyword(keyword)]
  end

  def like_operator
    params[:match_type] == "exact" ? "=" : "LIKE"
  end

  def formatted_keyword(keyword)
    case params[:match_type]
    when "exact"
      keyword
    when "prefix"
      "#{keyword}%"
    when "suffix"
      "%#{keyword}"
    when "partial"
      "%#{keyword}%"
    else
      "%#{keyword}%"
    end
  end
end

