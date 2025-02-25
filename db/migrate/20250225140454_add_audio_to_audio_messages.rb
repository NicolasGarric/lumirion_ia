class AddAudioToAudioMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :audio_messages, :audio, :string
  end
end
