class CreateAudioMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :transcription
      t.string :status

      t.timestamps
    end
  end
end
