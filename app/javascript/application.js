// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
require("@rails/activestorage").start()

function initIcons() {
  if (window.lucide && typeof window.lucide.createIcons === 'function') {
    window.lucide.createIcons();
  }
}

document.addEventListener('turbo:load', initIcons)
document.addEventListener('DOMContentLoaded', initIcons)
