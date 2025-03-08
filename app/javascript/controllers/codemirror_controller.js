import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.editor = CodeMirror.fromTextArea(this.element, {
      mode: "css",
      theme: "default",
      lineNumbers: true,
      autoCloseBrackets: true,
      viewportMargin: Infinity
    });

    this.editor.setSize("100%", "1000px"); // Adjust height as needed


    this.editor.on("change", () => {
      this.element.value = this.editor.getValue();
    });
  }
}