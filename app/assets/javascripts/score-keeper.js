/*!
 * Internet Monitor Score Keeper
 *
 * This plugin managing the downloading of data
 * required to calculate new IM scores
 * based on a set of indicators & weights.
 *
 * Current dependencies:
 * jquery.magnific-popup
 */

;( function ( $, undefined ) {
  var _defaults = {
    loaderCss: '.score-keeper-loader',
    dataPath: '/countries.json'
  };

  var _options = { };

  var _countryData = null;

  $.scoreKeeper = {
    init: function( options ) {
      // load country data
      // show a modal popup indicator if
      // it's taking too long
      _options = $.extend( { }, _defaults, options );

      var timeoutPopup = null;

      if ( !_countryData ) {
        $.ajax( {
          url: _options.dataPath,
          success: function( result ) {
            if ( timeoutPopup ) {
              clearTimeout( timeoutPopup );
              timeoutPopup = null;
            }

            _countryData = result;

            $.magnificPopup.close( );

          },
          error: function( xhr ) {
          }
        } );

        timeoutPopup = setTimeout( function( ) {
          timeoutPopup = null;
          mfp = $.magnificPopup.open( { items: { src: _options.loaderCss, modal: true }, showCloseBtn: false } );
        }, 1000 );
      }
    },

    setWeight: function( adminName, value ) {
      window.location.href = window.location.href + '#' + adminName + '=' + value;
    }



  };

} ) ( window.jQuery );

