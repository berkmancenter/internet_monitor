$( function( ) {
  if ( $( '.map.partial' ).length ) {
    var hover = null;
    var popup = null;
    var popupTmpl = $.templates( '#popup-tmpl' );
    var defaultMapMode = $( 'body.map' ).length > 0 ? 'pan' : 'static';


    var map = $( '.geomap' ).geomap( {
      tilingScheme: null,
      bboxMax: [-180, -85, 180, 85],
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
      zoomMin: 2,
      mode: defaultMapMode,
      cursors: {
        click: 'pointer',
        "static": $( 'body.home' ).length > 0 ? 'pointer' : 'default'
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
    var mapCountries = {
      length: 0
    };

    $.each( map.data( 'mapCountries' ), function( ) {
      mapCountries[ this.iso3_code ] = this;
      mapCountries.length++;
    } );

    var minScore = map.data( 'minScore' );
    var maxScore = map.data( 'maxScore' );

    var zoomCountry = $( '.geomap' ).data( 'countryIso3' );
    var zoomCountryLabel = null;
    var zoomBbox = null;

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

    var legendHtml = '<h2>Internet Monitor<br>Access Score (of 10)</h2><dl>';

    $.each( colorClasses, function( i ) {
      if ( i === 0 ) {
        this.minValue = 0;
        this.label = 'Not enough data';
      } else {
        this.minValue = minScore + ( maxScoreBreak * ( i - 1 ) );
        this.label = this.minValue.toFixed( 2 ) + ' - ' + ( minScore + ( maxScoreBreak * ( i ) ) ).toFixed( 2 );
      }
      legendHtml += '<dt><span style="background: ' + this.color + ';"></span></dt><dd>' + this.label + '</dd>';
    } );

    legendHtml += '</dl>';

    $( '.map-legend' ).html( legendHtml ).show();



    // grab the world countries file
    $.getJSON('/world-countries.json', function (result) {

      // append them to the map
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

        mapCountriesService.geomap('append', this, {
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

    $( '.zoom-in' ).click( function( ) {
      map.geomap('zoom', +1);
    } );

    $( '.zoom-out' ).click( function( ) {
      map.geomap('zoom', -1);
    } );
  }
} );
