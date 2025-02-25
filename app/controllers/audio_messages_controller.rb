class AudioMessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @audio_messages = current_user.audio_messages
    @audio_message = AudioMessage.new
  end

  def create
    @audio_message = current_user.audio_messages.new(audio_message_params)

    if @audio_message.save
      redirect_to audio_messages_path, notice: "Votre message est en cours de transcription..."
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def audio_message_params
    params.require(:audio_message).permit(:audio)
  end
end
