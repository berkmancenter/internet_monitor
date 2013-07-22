$( function( ) {
  if ( $( '.map.partial' ).length ) {
    var map = $( '.geomap' ).geomap( {
      services: [ ],
      zoom: 2,
      cursors: {
        click: 'pointer'
      },
      shapeStyle: {
        color: '#36484a',
        fillOpacity: 1,
        stroke: '#addfe6',
        strokeWidth: '1px'
      },
      move: function( e, geo ) {
        if ( map.geomap( 'find', geo, 1 ).length ) {
          map.geomap( 'option', 'mode', 'click' );
        } else {
          map.geomap( 'option', 'mode', 'pan' );
        }
      }
    } );

    // grab the world countires file
    $.getJSON('/world-countries.json', function (result) {
      // append them to the map
      $.each( result.features, function( ) {
        var r = Math.round( (0x36 + ( (0xff - 0x36) * Math.random() ) ) ).toString(16);
        map.geomap('append', this, {
          color: '#' + r + '484a'
        }, false);
      });

      // show them
      map.geomap('refresh');
    });

  }
} );
