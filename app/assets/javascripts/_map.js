$( function( ) {
  if ( $( '.map.partial' ).length ) {
    var hover = null;
    var popup = null;
    var popupTmpl = $.templates( '#popup-tmpl' );

    var map = $( '.geomap' ).geomap( {
      services: [
        {
          id: 'map-countries-service',
          type: 'shingled',
          src: ""
        },
        {
          id: 'map-highlight-service',
          type: 'shingled',
          src: ""
        }
      ],
      center: [ 0, 20 ],
      zoom: 2,
      cursors: {
        click: 'pointer'
      },
      shapeStyle: {
        height: 0,
        width: 0
      },
      move: function( e, geo ) {
        var countries = map.geomap( 'find', geo, 1 );
        if ( countries.length > 0 ) {
          map.geomap( 'option', 'mode', 'click' );

          if ( countries[ 0 ] !== hover ) {
            if ( hover ) {
              mapHighlightService.geomap( 'remove', hover, false );
            }

            hover = countries[ 0 ];
            mapHighlightService.geomap( 'append', hover );
          }

        } else {
          map.geomap( 'option', 'mode', 'pan' );

          if ( hover ) {
            mapHighlightService.geomap( 'remove', hover );
            hover = null;
          }
        }
      },
      click: function( e, geo ) {
        if ( popup ) {
          map.geomap( 'remove', popup );
          popup = null;
        }

        var countries = map.geomap( 'find', geo, 1 );
        if ( countries.length > 0 ) {
          if ( countries[ 0 ].properties.country_id ) {
            popup = geo;
            map.geomap( 'append', geo, popupTmpl.render( countries[ 0 ].properties ) );
          }
        }
      }
    } );

    var mapCountriesService = $( '#map-countries-service' ).geomap( 'option', 'shapeStyle', {
      color: '#36484a',
      fillOpacity: 1,
      stroke: '#addfe6',
      strokeWidth: '1px'
    } );
    var mapHighlightService = $( '#map-highlight-service' ).geomap( 'option', 'shapeStyle', {
      fillOpacity: 0,
      stroke: '#aaa04e',
      strokeWidth: '2px'
    } );

    // map countries from server
    var mapCountries = { };
    $.each( map.data( 'mapCountries' ), function( ) {
      mapCountries[ this.iso3_code ] = this;
    } );

    var maxScore = map.data( 'maxScore' );
    //var countriesPath = map.data( 'countriesPath' );

    // grab the world countries file
    $.getJSON('/world-countries.json', function (result) {
      // append them to the map
      $.each( result.features, function( ) {
        var r = '36';
        if ( mapCountries[ this.properties.iso_a3 ] ) {
          this.properties.country_id = mapCountries[ this.properties.iso_a3 ].id;
          this.properties.score = mapCountries[ this.properties.iso_a3 ].score;
          r = Math.round( (0x36 + ( (0xff - 0x36) * ( mapCountries[ this.properties.iso_a3 ].score / maxScore ) ) ) ).toString(16);
        }
        mapCountriesService.geomap('append', this, {
          color: '#' + r + '484a'
        }, false);
      });

      // show them
      map.geomap('refresh');
    });
  }
} );
