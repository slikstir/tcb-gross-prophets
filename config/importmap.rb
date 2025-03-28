# Pin npm packages by running ./bin/importmap

pin "application"
pin_all_from "app/javascript/src", under: "src", to: "src"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/ujs", to: "@rails--ujs.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
