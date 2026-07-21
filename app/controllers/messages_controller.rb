class MessagesController < ApplicationController
  def show
    @partner = User.find(params[:user_id])
    @messages = Message.conversation_between(Current.user, @partner)
    @message = Message.new
  end

  def create
    @partner = User.find(params[:message][:recipient_id])
    @message = Current.user.sent_messages.new(message_params)

    if @message.save
      redirect_to conversation_path(@partner)
    else
      @messages = Message.conversation_between(Current.user, @partner)
      render :show, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :recipient_id)
  end
end
