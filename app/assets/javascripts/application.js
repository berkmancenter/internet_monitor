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
//= require jquery.magnific-popup
//= require_tree .

(function() {
  function hideAllBut( s ) {
    $( '.countries-nav-list,.category-selector' ).not( s ).removeClass( 'expanded' );
  }

  $( '.data-nav-countries' ).click( function( ) {
    hideAllBut( '.countries-nav-list' );
    $( '.countries-nav-list' ).toggleClass( 'expanded' );
    return false;
  } );

  $( '.data-nav-categories' ).click( function( ) {
    hideAllBut( '.category-selector' );
    $( '.category-selector' ).toggleClass( 'expanded' );
    return false;
  } );

  // initialize score keeper (download data)
  $.scoreKeeper.init( );
} ());
