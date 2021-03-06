
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require best_in_place
//= require jquery_nested_form
//= require bootstrap
//= require bootstrap-tooltip.js
//= require bootstrap-popover.js
//= require bootstrap-datepicker
//= require cocoon
//= require_tree .
$(function () {
  $('.popover-test').popover({ 
    html : true
  }).popover('hide');
  $(".popover-link").popover({ html : true }).popover('hide');
  $('.popover-test').on('click', function(e) {e.preventDefault(); return true;});
});
$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();
});



