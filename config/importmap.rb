# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "controllers/reveal_controller", to: "controllers/reveal_controller.js"
pin "controllers/hello_controller", to: "controllers/hello_controller.js"
pin "controllers/share_modal", to: "controllers/share_modal.js"
