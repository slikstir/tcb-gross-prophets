import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.fadeIn();
    this.dismissAfterTimeout();
  }

  fadeIn() {
    this.element.style.opacity = 0; // Start hidden
    this.element.style.transition = "opacity 0.5s ease-in-out"; // Smooth transition

    requestAnimationFrame(() => {
      this.element.style.opacity = 1; // Fade in
    });
  }

  dismissAfterTimeout() {
    setTimeout(() => {
      this.element.style.opacity = 0; // Start fade out
      setTimeout(() => this.element.remove(), 500); // Remove after fade out
    }, 3000);
  }
}