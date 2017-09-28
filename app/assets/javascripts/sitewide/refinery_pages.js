(function() {
  $( '#body img.image-align-left,#body img.image-align-right' ).each( function( i ) {
    var $img = $( this );

    $img.wrap( '<a href="' + $img.attr( 'src' ) + '" data-lightbox="body"></a>' );
  } );

  $( '.aside img' ).each( function( i ) {
    var $img = $( this );

    $img.wrap( '<a href="' + $img.attr( 'src' ) + '" data-lightbox="aside"></a>' );
  } );
 
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
