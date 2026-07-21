class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:followed_id])
    Current.user.follow(user)
    redirect_back fallback_location: root_path
  end

  def destroy
    relationship = Current.user.active_relationships.find(params[:id])
    relationship.destroy
    redirect_back fallback_location: root_path
  end
end
