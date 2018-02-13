(function() {
  $( '.bulletin #body img' ).each( function( i ) {
    var $img = $( this );

    $img.wrap( '<a href="' + $img.attr( 'src' ) + '" data-lightbox="body"></a>' );
  } );

  /*
  $( '.aside img' ).each( function( i ) {
    var $img = $( this );

    $img.wrap( '<a href="' + $img.attr( 'src' ) + '" data-lightbox="aside"></a>' );
  } );
  */
 
  $( '.reference,b:contains([0]),strong:contains([0])' ).each( function ( i ) {
    var $this = $( this );
    if ( $this.hasClass( 'reference' ) ) {
      $( this ).find( 'a' ).attr( 'href', '#cite-note-' + ( i + 1 ) ).text( '[' + ( i + 1 ) + ']' );
    } else {
      $( this ).html( '<sup class="reference"><a href="#cite-note-' + ( i + 1 ) + '">[' + ( i + 1 ) + ']</a></sup>' );
    }

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
