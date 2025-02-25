class TranscriptionJob < ApplicationJob
  queue_as :default

  def perform(audio_message)
    client = OpenAI::Client.new

    begin
      audio_file = File.open(Rails.root.join("storage", audio_message.audio.key), "rb")

      response = client.audio.transcriptions(
        parameters: {
          model: "whisper-1",
          file: audio_file,
          language: "fr"
        }
      )

      transcription_text = response["text"]
      audio_message.update(transcription: transcription_text, status: "completed")
    rescue => e
      audio_message.update(status: "failed")
      Rails.logger.error "Transcription Error: #{e.message}"
    end
  end
end
