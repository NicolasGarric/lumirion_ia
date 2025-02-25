class AudioMessage < ApplicationRecord
  belongs_to :user
  has_one_attached :audio

  validate :correct_audio_mime_type

  after_create :transcribe_audio

  private

  def correct_audio_mime_type
    if audio.attached? && !audio.content_type.in?(%w[audio/mpeg audio/wav])
      errors.add(:audio, "doit être un fichier MP3 ou WAV")
    end
  end

  def transcribe_audio
    update(status: "pending")
    TranscriptionJob.perform_later(self)
  end
end
