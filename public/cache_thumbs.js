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

      cacheThumb();
    });

    var cacheIdx = 0;
    var feature = null;
    var country = null;

    function cacheThumb( ) {
      feature = $.extend( {}, features[ cacheIdx ] );
      country = mapCountries[ feature.properties.iso_a3 ];

      if ( country ) {
        mapCountriesService.geomap('append', feature, {
          color: '#5ec1a5',
          fillOpacity: 1,
          stroke: '#fefefe',
          strokeWidth: '2px'
        }, false);
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

      mapCountriesService.geomap('remove', feature);

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
