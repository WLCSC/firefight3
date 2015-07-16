// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-multiselect
//= require typeahead
//= require jquery_ujs
//= require_tree .

function flash(message, klass) {
  row = $('.flash-container');
  row.append($('<div class="alert alert-' + klass + '"><button class="close" data-dismiss="alert">&times;</button>' + message + '</div>').hide().fadeIn(500));
}

function setupTypeahead(klass, url) {
  if($('.typeahead-' + klass).size() > 0) {

    // initialize bloodhound engine
    var bloodhound = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,

      // sends ajax request to /typeahead/%QUERY
      // where %QUERY is user input
      remote: {
        url: url + '/%QUERY',
        wildcard: '%QUERY'
      },
      limit: 50
    });
    bloodhound.initialize();

    // initialize typeahead widget and hook it up to bloodhound engine
    // #typeahead is just a text input
    $('.typeahead-' + klass).typeahead(null, {
      display: 'name',
      source: bloodhound.ttAdapter()
    });
  }
}

$(function() {
  $.each(['categories', 'manufacturers', 'assets', 'listables', 'users', 'groups', 'buildings', 'services', 'rooms', 'models', 'stns'], function(ctr, x) {
    setupTypeahead(x, BASE_URL + 'typeahead/' + x);
  });
});
