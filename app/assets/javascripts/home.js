$( function( ) {
  if ( $( 'body.refinery-pages.home' ).length > 0 ) {
    var filmRoll = new FilmRoll( {
      container: '.carousel',
      height: 400,
      pager: false
    } );
  }
} );
