import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const modal = new bootstrap.Modal(this.element)
    modal.show()
  }
}