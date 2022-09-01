import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "controllers";
import $ from "jquery";
global.$ = jQuery;
import "bootstrap"


Rails.start()
Turbolinks.start()
ActiveStorage.start()
