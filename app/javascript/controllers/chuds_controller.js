import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "amount", "submit", "warning"]
  static values = { balance: Number }


  connect() {
    this.updateTotal() // Ensure it starts with the correct total
  }

  updateTotal() {
    let startingBalance = this.balanceValue // Get initial balance from data attribute
    let total = this.inputTargets.reduce((sum, input) => sum + (parseInt(input.value, 10) || 0), 0)
    let newBalance = startingBalance - total

    this.amountTarget.textContent = newBalance < 0 ? 0 : newBalance // Prevent negative values

    if (newBalance < 0) {
      this.submitTarget.disabled = true // Disable submit
      this.warningTarget.classList.remove("d-none") // Show warning
    } else {
      this.submitTarget.disabled = false // Enable submit
      this.warningTarget.classList.add("d-none") // Hide warning
    }
  }

  increment(event) {
    event.preventDefault()
    let input = event.currentTarget.closest("tr").querySelector(".chuds-amount")
    if (input) {
      input.value = parseInt(input.value, 10) + 1
      this.updateTotal()
    }
  }

  decrement(event) {
    event.preventDefault()
    let input = event.currentTarget.closest("tr").querySelector(".chuds-amount")
    if (input && parseInt(input.value, 10) > 0) {
      input.value = parseInt(input.value, 10) - 1
      this.updateTotal()
    }
  }
}