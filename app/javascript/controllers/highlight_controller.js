import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { duration: Number };

  connect() {
    this.highlight();
  }

  highlight() {
    this.element.classList.add("bg-warning"); // Bootstrap yellow background

    setTimeout(() => {
      this.element.classList.add("fade-highlight");
      this.element.classList.remove("bg-warning");
    }, this.durationValue || 2000); // Default to 2 seconds
  }
}
