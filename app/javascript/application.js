// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import 'src/main'
import 'src/bootstrap.bundle'
import "@hotwired/turbo-rails"

import Rails from '@rails/ujs';

Rails.start();