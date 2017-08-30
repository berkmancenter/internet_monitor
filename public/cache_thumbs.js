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
      zoomMin: 0,
      mode: 'static',
      shapeStyle: {
        height: 0,
        width: 0
      }
    } );


    var mapCountriesService = $( '#map-countries-service' ).geomap( 'option', 'shapeStyle', {
      color: '#ccc',
      fillOpacity: 1,
      stroke: '#fefefe',
      strokeWidth: '2px'
    } );
    /*
      color: '#366936',
      fillOpacity: 1,
      strokeOpacity: 0
     */

    // map countries from server
    var mapCountries = {
      length: 0
    };

    var features = null;
    var bboxen = null

    $.each( map.data( 'mapCountries' ), function( ) {
      mapCountries[ this.iso3_code ] = this;
      mapCountries.length++;
    } );

    // grab the world countries file
    $.getJSON('/world-countries.json', function (result) {

      // append them to the map
      features = result.features;
      $( 'progress' ).attr( 'max', features.length );

      $.each( features, function( ) {
        mapCountriesService.geomap('append', this, null, false);
      } );

      map.geomap('refresh');


      $.getJSON( '/country_bbox.json', function( result ) {
        bboxen = result;
        cacheThumb();
      } );
    });

    var cacheIdx = 0;
    var feature = null;
    var country = null;

    function cacheThumb( ) {
      feature = $.extend( {}, features[ cacheIdx ] );
      country = mapCountries[ feature.id ];

      if ( country ) {
        mapCountriesService.geomap('append', feature, {
          color: '#5ec1a5',
          fillOpacity: 1,
          stroke: '#fefefe',
          strokeWidth: '2px'
        }, false);
        map.geomap( 'option', 'bbox', bboxen[ feature.id ] );
        setTimeout( storeImage, 2000 );
      } else {
        console.log( 'missing country for ' + feature.id );
        cacheIdx++;
        $( 'progress' ).prop( 'value', cacheIdx );

        if ( cacheIdx < features.length ) {
          setTimeout( cacheThumb, 32 );
        }
      }
    }

    function storeImage() {
      var dataUrl = $( '#map-countries-service img' ).prop( 'src' );

      if ( dataUrl ) {
        $( '#thumb' ).prop( 'src', dataUrl );
        $( '#imgSrc' ).text( dataUrl );

        var file = dataURLtoBlob( dataUrl );

        if ( file !== null ) {
          var fd = new FormData();

          fd.append( 'country[thumb]', file );

          $.ajax( {
            url: '/countries/' + country.id,
            type: 'PUT',
            data: fd,
            processData: false,
            contentType: false
          } );
        }
      } else {
        console.log( 'cannot create dataURL for ' + feature.id );
      }

      mapCountriesService.geomap('remove', feature);

      cacheIdx++;
      $( 'progress' ).prop( 'value', cacheIdx );

      if ( cacheIdx < features.length ) {
        cacheThumb();
      }
    }

    // Convert dataURL to Blob object
    function dataURLtoBlob(dataURL) {
      try {
        // Decode the dataURL
        var binary = atob(dataURL.split(',')[1]);

        // Create 8-bit unsigned array
        var array = [];
        for(var i = 0; i < binary.length; i++) {
          array.push(binary.charCodeAt(i));
        }

        // Return our Blob object
        return new Blob([new Uint8Array(array)], {type: 'image/png'});
      } catch ( ex ) {
        console.log( 'error creating image for '  + feature.id );
      }
      return null;
    }

  }

} );
