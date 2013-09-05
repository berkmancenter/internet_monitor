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

$( '.data-nav-countries' ).click( function( ) {
  var countriesNavList = $( '.countries-nav-list' );

  if ( countriesNavList.height( ) ) {
    countriesNavList.height( 0 );
  } else {
    countriesNavList.height( '60%' );
  }
  return false;
} );

$( '.data-nav-categories' ).click( function( ) {
  $( '.category-selector' ).toggle( );
  return false;
} );
