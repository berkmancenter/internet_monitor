(function() {
  $( '.reference' ).each( function ( i ) {
    $( this ).find( 'a' ).attr( 'href', '#cite-note-' + ( i + 1 ) ).text( '[' + ( i + 1 ) + ']' );
  } );

  $( '.references > li' ).each( function ( i ) {
    $( this ).attr( 'id', 'cite-note-' + ( i + 1 ) );
  } );


  $( '.reference a' ).click( function() {
    var section = $( '.references' ).prev( '.expandable' );
    var show = !section.hasClass( 'expanded' );
    if ( show ) {
      section.click();
    }
  } );
} ());
