import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["recordButton", "stopButton", "audioInput", "audioPreview"];

  connect() {
    this.mediaRecorder = null;
    this.chunks = [];
  }

  async startRecording() {
    this.chunks = [];

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      this.mediaRecorder = new MediaRecorder(stream);

      this.mediaRecorder.ondataavailable = event => {
        if (event.data.size > 0) this.chunks.push(event.data);
      };

      this.mediaRecorder.onstop = this.saveRecording.bind(this);

      this.mediaRecorder.start();
      this.recordButtonTarget.disabled = true;
      this.stopButtonTarget.disabled = false;
    } catch (error) {
      alert("L'accès au micro a été refusé !");
    }
  }

  stopRecording() {
    if (this.mediaRecorder) {
      this.mediaRecorder.stop();
      this.recordButtonTarget.disabled = false;
      this.stopButtonTarget.disabled = true;
    }
  }

  saveRecording() {
    const audioBlob = new Blob(this.chunks, { type: "audio/wav" });
    const audioUrl = URL.createObjectURL(audioBlob);

    // Prévisualisation de l'audio enregistré
    this.audioPreviewTarget.src = audioUrl;

    // Convertir le Blob en fichier pour ActiveStorage
    const file = new File([audioBlob], "recording.wav", { type: "audio/wav" });
    const dataTransfer = new DataTransfer();
    dataTransfer.items.add(file);
    this.audioInputTarget.files = dataTransfer.files;
  }
}
