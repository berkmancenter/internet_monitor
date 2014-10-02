$( function () {
  if ( $( '#cacheThumbs' ).length ) {
    var map = $( '#cacheThumbs' ).geomap( {
      tilingScheme: null,
      bboxMax: [-180, -85, 180, 85],
      services: [
        {
          id: 'map-countries-service',
          type: 'shingled',
          src: ""
        }
      ],
      center: [ 0, 20 ],
      zoom: 2,
      zoomMin: 2,
      mode: 'static',
      shapeStyle: {
        height: 0,
        width: 0
      }
    } );


    var mapCountriesService = $( '#map-countries-service' ).geomap( 'option', 'shapeStyle', {
      color: '#36484a',
      fillOpacity: 1,
      stroke: '#addfe6',
      strokeWidth: '1px'
    } );

    // map countries from server
    var mapCountries = {
      length: 0
    };

    var features = null;

    $.each( map.data( 'mapCountries' ), function( ) {
      mapCountries[ this.iso3_code ] = this;
      mapCountries.length++;
    } );

    var minScore = map.data( 'minScore' );
    var maxScore = map.data( 'maxScore' );

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


    $.each( colorClasses, function( i ) {
      if ( i === 0 ) {
        this.minValue = 0;
        this.label = 'Not enough data';
      } else {
        this.minValue = minScore + ( maxScoreBreak * ( i - 1 ) );
        this.label = this.minValue.toFixed( 2 ) + ' - ' + ( minScore + ( maxScoreBreak * ( i ) ) ).toFixed( 2 );
      }
    } );

    // grab the world countries file
    $.getJSON('/world-countries.json', function (result) {

      // append them to the map
      features = result.features;
      $( 'progress' ).attr( 'max', features.length );

      $.each( features, function( ) {
        // 'this' is world-countries shape
        var r = colorClasses[ 0 ].color;

        if ( mapCountries[ this.properties.iso_a3 ] ) {
          if ( mapCountries.length === 1 ) {
            r = colorClasses[ colorClasses.length - 1 ].color;
          } else {
            this.properties.country_iso = this.properties.iso_a3.toLowerCase();
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

        mapCountriesService.geomap('append', this, {
          color: r
        }, false);
      });

      map.geomap('refresh');

      cacheThumb();
    });

    var cacheIdx = 0;
    var feature = null;
    var country = null;

    function cacheThumb( ) {
      feature = features[ cacheIdx ];
      country = mapCountries[ feature.properties.iso_a3 ];

      if ( country ) {
        map.geomap( 'option', 'bbox', $.geo.scaleBy( JSON.parse( country.bbox ), 1.5 ) );
        setTimeout( storeImage, 1000 );
      } else {
        cacheIdx++;
        $( 'progress' ).prop( 'value', cacheIdx );

        if ( cacheIdx < features.length ) {
          setTimeout( cacheThumb, 32 );
        }
      }
    }

    function storeImage() {
      var dataUrl = $( '#map-countries-service img' ).prop( 'src' );

      $( '#thumb' ).prop( 'src', dataUrl );
      $( '#imgSrc' ).text( dataUrl );

      var file = dataURLtoBlob( dataUrl );

      var fd = new FormData();

      fd.append( 'country[thumb]', file );

      $.ajax( {
        url: '/countries/' + country.id,
        type: 'PUT',
        data: fd,
        processData: false,
        contentType: false
      } );

      cacheIdx++;
      $( 'progress' ).prop( 'value', cacheIdx );

      if ( cacheIdx < features.length ) {
        cacheThumb();
      }
    }

    // Convert dataURL to Blob object
    function dataURLtoBlob(dataURL) {
      // Decode the dataURL
      var binary = atob(dataURL.split(',')[1]);

      // Create 8-bit unsigned array
      var array = [];
      for(var i = 0; i < binary.length; i++) {
        array.push(binary.charCodeAt(i));
      }

      // Return our Blob object
      return new Blob([new Uint8Array(array)], {type: 'image/png'});
    }

  }

} );
