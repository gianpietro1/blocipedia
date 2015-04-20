class SearchSuggestionsController < ApplicationController

  def index
    @search_array = $redis.smembers("tags:all:#{params[:term].downcase}").map do |tags|
      tags.titleize
    end
    render json: @search_array
  end

end