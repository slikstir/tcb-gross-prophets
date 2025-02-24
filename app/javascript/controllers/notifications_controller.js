import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.dismissAfterTimeout();
  }

  dismissAfterTimeout() {
    setTimeout(() => {
      this.element.classList.add("fade-out");
      setTimeout(() => this.element.remove(), 500);
    }, 3000);
  }
}
