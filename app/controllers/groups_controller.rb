class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :transfer_ownership, :new_mail, :send_mail]
  before_action :ensure_owner, only: [:edit, :update, :destroy, :transfer_ownership, :new_mail, :send_mail]

  def index
    @groups = Group.all
    @user = Current.user
    @new_book = Book.new
  end

  def show
    @user = Current.user
    @new_book = Book.new
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner = Current.user

    if @group.save
      @group.group_users.create(user: Current.user)
      redirect_to groups_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path
  end

  def transfer_ownership
    new_owner = @group.members.find_by(id: params[:new_owner_id])

    if new_owner.nil?
      redirect_to @group, alert: "指定されたユーザーはこのグループのメンバーではありません。"
      return
    end

    if new_owner == @group.owner
      redirect_to @group, alert: "既にオーナーです。"
      return
    end

    @group.update(owner: new_owner)
    redirect_to @group, notice: "#{new_owner.name}さんにオーナーを譲渡しました。"
  end

  def new_mail
  end

  def send_mail
    @subject = params[:subject]
    @body = params[:body]

    GroupMailer.bulk_mail(@group, Current.user, @subject, @body).deliver_now

    render :send_mail, formats: [:html]
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def ensure_owner
    redirect_to @group, alert: "権限がありません。" unless @group.owner == Current.user
  end
end
