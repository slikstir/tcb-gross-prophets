import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "amount"]
  static values = { balance: Number }


  connect() {
    this.updateTotal() // Ensure it starts with the correct total
  }

  updateTotal() {
    let total = this.inputTargets.reduce((sum, input) => sum + (parseInt(input.value, 10) || 0), 0)
    let newBalance = this.balanceValue - total
    this.amountTarget.textContent = newBalance < 0 ? 0 : newBalance // Prevent negative values
  }
}