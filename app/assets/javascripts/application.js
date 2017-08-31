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
//= require jquery.collapse
//= require_tree ./sitewide

(function() {
  function hideAllBut( s ) {
    $( '.countries-nav-list' ).not( s ).removeClass( 'expanded' );
  }

  $( '.data-nav-countries' ).click( function( e ) {
    e.preventDefault( );
    hideAllBut( '.countries-nav-list' );
    $( '.countries-nav-list,.data-nav-countries' ).toggleClass( 'expanded' );
    return false;
  } );

  $( 'h2.expandable' ).each( function( e ) {
    var show = $( this ).hasClass( 'expanded' );
    $( this ).nextUntil( 'h2' ).toggle( show );
  } );
  
  $( 'h2.expandable' ).click( function( e ) {
    e.preventDefault( );
    var show = !$( this ).hasClass( 'expanded' );
    $( this ).toggleClass( 'expanded', show ).nextUntil( 'h2' ).toggle( show );
    return false;
  } );
} ());
