$( function( ) {
  // separated to its own file because it needs to be much simpler
  if ( $( 'body.home' ).length ) {
    var maps = $( '.trending-map' ).geomap( {
      tilingScheme: null,
      bboxMax: [-180, -85, 180, 85],
      services: [
        {
          "class": 'map-countries-service',
          type: 'shingled',
          src: ""
        }
      ],
      center: [ 0, 20 ],
      zoom: 2,
      zoomMin: 2,
      mode: 'static',
      cursors: {
        "static": 'pointer'
      },
      shapeStyle: {
        height: 0,
        width: 0
      }
    } );

    var mapCountriesServices = $( '.map-countries-service' ).geomap( 'option', 'shapeStyle', {
      color: '#36484a',
      fillOpacity: 1,
      stroke: '#addfe6',
      strokeWidth: '1px'
    } );

    // map countries from server
    var mapCountries = {
      length: 0
    };

    var mapCountriesDataSource = $('.trending');
    
    $.each( mapCountriesDataSource.data( 'mapCountries' ), function( ) {
      mapCountries[ this.iso3_code ] = this;
      mapCountries.length++;
    } );

    var minScore = mapCountriesDataSource.data( 'minScore' );
    var maxScore = mapCountriesDataSource.data( 'maxScore' );

    var colorClasses = [
    { color: '#fefefe' }, // $light-blue, the water, not used
    { color: '#dee7f0' },
    { color: '#c5cedd' },
    { color: '#a3afc7' },
    { color: '#8393ad' },
    { color: '#576c81' },
    { color: '#505c74' },
    { color: '#3e4452' }
    ];
    
    var scoreRange = maxScore - minScore;
    var maxScoreBreak = scoreRange / ( colorClasses.length - 1 );

    // grab the world countries file
    $.getJSON('/world-countries.json', function (result) {

      maps.each( function( ) {
        var map = $( this );
        var zoomCountry = map.data( 'countryIso3' );
        var zoomBbox = null;

        // append them to the maps
        $.each( result.features, function( ) {
          // 'this' is world-countries shape
          var r = colorClasses[ 0 ].color;

          if ( mapCountries[ this.properties.iso_a3 ] ) {
            if ( mapCountries.length === 1 ) {
              r = colorClasses[ colorClasses.length - 1 ].color;
            } else {
              this.properties.country_id = mapCountries[ this.properties.iso_a3 ].id;
              this.properties.score = mapCountries[ this.properties.iso_a3 ].score;

              for ( var i = 0; i < colorClasses.length; i++ ) {
                if ( this.properties.score < colorClasses[ i ].minValue ) {
                  r = colorClasses[ i - 1 ].color;
                  break;
                } else {
                  r = colorClasses[ i ].color;
                }
              }
            }
          }

          if ( this.properties.iso_a3 === zoomCountry ) {
            zoomBbox = $.geo.scaleBy( $.geo.bbox( this ), 1.5 );
          }

          map.find( '.map-countries-service' ).geomap('append', this, {
            color: r
          }, false);
        });

        // show them
        if ( zoomBbox ) {
          map.geomap( 'option', 'bbox', zoomBbox );
        } else {
          map.geomap('refresh');
        }
      });
    } );
  }
} );
