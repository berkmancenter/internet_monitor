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
//= require jquery.nouislider
//= require_tree .

// weight_sliders are available on all pages via the menu

$(function() {
  weightSliders.init( );

  $( document ).on( 'click keyup', hideWeightSlidersOnEvent );

  function hideWeightSlidersOnEvent( e ) {
    // hide weight-sliders if:
    // keyup ESC or
    // click from outside slider panel
    // make it to document
    if ( ( e.type === 'keyup' && e.keyCode === 27 ) ||
      ( e.type === 'click' && $( e.target ).closest( '#weight-sliders' ).length === 0 ) ) {
      var weightSliders = $( '#weight-sliders' );
      if ( !weightSliders.hasClass( 'hidden' ) ) {
        weightSliders.addClass( 'hidden' );
      }
    }
  }
});
