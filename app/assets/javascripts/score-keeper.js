/*!
 * Internet Monitor Score Keeper
 *
 * This plugin managing the downloading of data
 * required to calculate new IM scores
 * based on a set of indicators & weights.
 *
 * Current dependencies:
 * jquery.magnific-popup
 * jquery.ba-bbq
 *
 * Implementation notes:
 * - must be initialzied *before* weightSliders
 * - indicator info (id, adminName, etc.) is extracted from the slider elements
 * - the authority on current weight values is the bbq state, not the sliders themselves
 */

;( function ( $, undefined ) {
  var _defaults = {
    loaderCss: '.score-keeper-loader',
    dataPath: '/countries.json',
    maxScore: 10,
    hasScorePill: false // only pushState if page has scorePill
  };

  var _options = { };

  var _countryData = null; //< raw data
  var _countries = []; //< by countryId

  var _indicators = []; //< by sourceId

  function _hashchange( e ) {
    $( '.score-pill' ).updateScore( );
  }

  $.scoreKeeper = {
    init: function( options ) {
      _options = $.extend( { }, _defaults, options );

      _options.hasScorePill = $( '.score-pill' ).length > 0;
      
      // extract previous state from sessionStorage, extend with url state
      if ( window.sessionStorage && window.JSON ) {
        var state = $.bbq.getState( );
        var sessionState = window.sessionStorage.getItem( 'bbqState' );
        if ( sessionState ) {
          state = $.extend( JSON.parse( sessionState ), state );

          if ( _options.hasScorePill ) {
            $.bbq.pushState( state );
          }
        }
        window.sessionStorage.setItem( 'bbqState', JSON.stringify( state ) );
      }

      // build an indexed list of indicators
      $( '.weight-slider' ).each( function( ) {
        var weightSlider = $( this );
        var sourceIds = weightSlider.data( 'sourceIds' );
        var defaultWeight = parseFloat( weightSlider.data( 'defaultWeight' ) );

        _indicators[ weightSlider.attr( 'name' ) ] = {
          sourceIds: sourceIds,
          groupDefaultWeight: Math.abs( defaultWeight )
          //defaultWeight: Math.abs( defaultWeight ),
          //direction: defaultWeight
        };
      } );

      // load country data
      // show a modal popup indicator if it's taking too long
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

            // build an indexed list of countries
            $.each( _countryData, function( ) {
              if ( this.country && $.isNumeric( this.country.id ) ) {
                _countries[ this.country.id ] = this.country;
              }
            } );

            $.magnificPopup.close( );
            if ( window.location.hash ) {
              $( window ).trigger( "hashchange" );
            }
          },
          error: function( xhr ) {
          }
        } );

        timeoutPopup = setTimeout( function( ) {
          timeoutPopup = null;
          mfp = $.magnificPopup.open( { items: { src: _options.loaderCss, modal: true }, showCloseBtn: false } );
        }, 1000 );
      }

      $( window ).on( 'hashchange', _hashchange ); 
      
    },

    getWeight: function( adminName ) {
      var state = { };
      
      // extract previous state from sessionStorage,
      // extend with url state
      if ( window.sessionStorage && window.JSON ) {
        state = $.bbq.getState( );
        var sessionState = window.sessionStorage.getItem( 'bbqState' );
        if ( sessionState ) {
          state = $.extend( JSON.parse( sessionState ), state );
        }
      }

      return state[ adminName ];
    },

    setWeight: function( adminName, value ) {
      var state = { };
      
      // extract previous state from sessionStorage,
      // extend with url state
      if ( window.sessionStorage && window.JSON ) {
        state = $.bbq.getState( );
        var sessionState = window.sessionStorage.getItem( 'bbqState' );
        if ( sessionState ) {
          state = $.extend( JSON.parse( sessionState ), state );
        }
      }

      state[ adminName ] = value;

      if ( _options.hasScorePill ) {
        $.bbq.pushState( state );
      }

      if ( window.sessionStorage && window.JSON ) {
        window.sessionStorage.setItem( 'bbqState', JSON.stringify( state ) );
      }
    },

    reset: function( ) {
      if ( window.sessionStorage && window.JSON ) {
        window.sessionStorage.removeItem( 'bbqState' );
      }

      if ( _options.hasScorePill ) {
        $.bbq.removeState( );
      }
    },

    calculateScore: function( country ) {
      var indicators = country.indicators;

      var sum = indicators.reduce( function( sum, indi, i ) {
        var indicator = _indicators[ indi.group ];
        var groupWeight = $.bbq.getState( indi.group, true ) || 1.0;

        var direction = indi.default_weight;
        var output = sum + indi.normalized_value * Math.abs(indi.default_weight) * direction * groupWeight;
        if ( direction < 0 ) {
          output += 1;
        }
        return output;
      }, 0.0);

      var average = sum / indicators.length;
      var score = average * _options.maxScore;
      return score;
    }
  };

  $.fn.updateScore = function( options ) {
    this.each( function( ) {
      var scorePill = $( this ).filter( '.score-pill' );
      if ( scorePill.length > 0 ) {
        var countryId = scorePill.data( 'countryId' );
        var country = _countries[ countryId ];

        if ( country ) {
          country.score = $.scoreKeeper.calculateScore( country );
          scorePill.find( '.user-score' ).html( country.score.toFixed( 2 ) ).addClass( 'updated' );
        }
      }
    } );

    var countriesSorted = _countries.slice().sort( function( a, b ) {
      return a.score < b.score ? 1 : -1;
    } );

    $.each( countriesSorted, function( i ) {
      this.rank = i + 1;
    } );

    var isMapIndex = $( 'body.countries.map' ).length > 0;

    return this.each( function( ) {
      var scorePill = $( this ).filter( '.score-pill' );
      if ( scorePill.length > 0 ) {
        var countryId = scorePill.data( 'countryId' );
        var country = _countries[ countryId ];

        if ( country ) {
          scorePill.find( '.user-rank' ).html( '#' + country.rank ).addClass( 'updated' );

          if ( isMapIndex ) {
            scorePill.closest( 'li' ).css( 'top', (country.rank - 1) * 36 );
          }
        }
      }
    } );
  };

} ) ( window.jQuery );

