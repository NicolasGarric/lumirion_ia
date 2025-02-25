class AudioMessage < ApplicationRecord
  belongs_to :user
  has_one_attached :audio

  validates :audio, content_type: ['audio/mpeg', 'audio/wav']

  after_create :transcribe_audio

  private

  def transcribe_audio
    update(status: "pending")
    TranscriptionJob.perform_later(self)
  end
end
