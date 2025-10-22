import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "min",
    "max",
    "stock",
    "sort",
    "grid",
    "card"
  ]

  connect() {
    // Record original DOM order once
    this.cardTargets.forEach((card, idx) => {
      if (!card.dataset.initialIndex) card.dataset.initialIndex = String(idx)
    })

    this.run()
  }

  run() {
    this.applyFilters()
    this.applySort()
  }

  reset(event) {
    if (event) event.preventDefault()
    if (this.hasMinTarget) this.minTarget.value = ""
    if (this.hasMaxTarget) this.maxTarget.value = ""
    if (this.hasStockTarget) this.stockTarget.value = "all"
    if (this.hasSortTarget) this.sortTarget.value = "none"

    // Restore original order and show all
    this.restoreOriginalOrder()
    this.cardTargets.forEach((card) => (card.style.display = ""))
  }

  applyFilters() {
    const min = this.hasMinTarget ? parseFloat(this.minTarget.value) : NaN
    const max = this.hasMaxTarget ? parseFloat(this.maxTarget.value) : NaN
    const stockFilter = this.hasStockTarget ? this.stockTarget.value : "all"

    this.cardTargets.forEach((card) => {
      const price = parseFloat(card.dataset.price || "0")
      const stock = parseInt(card.dataset.stock || "0", 10)

      let visible = true
      if (!Number.isNaN(min) && price < min) visible = false
      if (!Number.isNaN(max) && price > max) visible = false

      if (stockFilter === "in" && stock <= 0) visible = false
      if (stockFilter === "out" && stock > 0) visible = false

      card.style.display = visible ? "" : "none"
    })
  }

  applySort() {
    if (!this.hasSortTarget) return
    const value = this.sortTarget.value
    if (value === "none") {
      // Restore original order but keep current visibility from filters
      this.restoreOriginalOrder()
      return
    }

    const [key, dir] = value.split("-") // e.g., "price-asc", "name-desc"
    const visibleCards = this.cardTargets.filter((c) => c.style.display !== "none")

    visibleCards.sort((a, b) => {
      if (key === "name") {
        const an = (a.dataset.name || "").toString()
        const bn = (b.dataset.name || "").toString()
        const cmp = an.localeCompare(bn)
        return dir === "asc" ? cmp : -cmp
      } else {
        const av = key === "price" ? parseFloat(a.dataset.price) : parseInt(a.dataset.stock, 10)
        const bv = key === "price" ? parseFloat(b.dataset.price) : parseInt(b.dataset.stock, 10)
        return dir === "asc" ? av - bv : bv - av
      }
    })

    const grid = this.hasGridTarget ? this.gridTarget : this.element
    visibleCards.forEach((card) => grid.appendChild(card))
  }

  restoreOriginalOrder() {
    const grid = this.hasGridTarget ? this.gridTarget : this.element
    const all = [...this.cardTargets]
    all.sort((a, b) => parseInt(a.dataset.initialIndex || "0", 10) - parseInt(b.dataset.initialIndex || "0", 10))
    all.forEach((card) => grid.appendChild(card))
  }
}
