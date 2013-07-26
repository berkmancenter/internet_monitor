$( function( ) {
  if ( $( '.map.partial' ).length ) {
    var map = $( '.geomap' ).geomap( {
      services: [ ],
      center: [ 0, 20 ],
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

    // map countries from server
    var mapCountries = { };
    $.each( map.data( 'mapCountries' ), function( ) {
      mapCountries[ this.iso3_code ] = this.score;
    } );

    var maxScore = map.data( 'maxScore' );

    // grab the world countires file
    $.getJSON('/world-countries.json', function (result) {
      // append them to the map
      $.each( result.features, function( ) {
        var r = '36';
        if ( mapCountries[ this.id ] ) {
          r = Math.round( (0x36 + ( (0xff - 0x36) * ( mapCountries[ this.id ] / maxScore ) ) ) ).toString(16);
        }
        map.geomap('append', this, {
          color: '#' + r + '484a'
        }, false);
      });

      // show them
      map.geomap('refresh');
    });

  }
} );
