class HomesController < ApplicationController
  allow_unauthenticated_access only: [:index, :about]

  def index
  end

  def about
  end
end
