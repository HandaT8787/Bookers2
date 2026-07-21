class GroupUsersController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    @group.group_users.create(user: Current.user)
    redirect_to groups_path
  end

  def destroy
    @group = Group.find(params[:group_id])

    if @group.owner == Current.user
      redirect_to @group, alert: "グループオーナーは退会できません。グループを削除するか、オーナーを譲渡してください。"
      return
    end

    group_user = @group.group_users.find_by(user: Current.user)
    group_user&.destroy
    redirect_to groups_path
  end
end
