var weightSliders = {
    SLIDER_SELECTOR  : '.weight-slider',

    sliderObjects    : [],

    init : function() {
        var countryId = $('.country').first().data('country-id');

        $('.toggle-weight-sliders').click( function() {
          $('#configure-panel').toggleClass('hidden');
          return false;
        } );

        this.sliderObjects = $(this.SLIDER_SELECTOR);

        this.sliderObjects.on( 'input change', function() {
          var weightSlider = $( this );
          if ( weightSlider.data( 'slideTimeout' ) ) {
            clearTimeout( weightSlider.data( 'slideTimeout' ) );
          }
          var slideTimeout = setTimeout( function( ) {
            $.scoreKeeper.setWeight( weightSlider.attr( 'name' ), weightSlider.val( ) );
          }, 60 );
          weightSlider.data( 'slideTimeout', slideTimeout );
        } ).each(function() { 
          var weightSlider = $( this );
          var weight = $.scoreKeeper.getWeight( weightSlider.attr( 'name' ) );
          weightSlider.val( weight || Math.abs( weightSlider.data( 'defaultWeight' ) ) );
          setGradient( this );
        });

        $( '#weight-sliders button' ).click( function( ) {
          setTimeout( function() {
            $.scoreKeeper.reset();
          }, 30 );
        } );
    }
};



// firefox needs to remember the sheet used
// to set it's pseudo element's style
// for each range input individually
if ( 'mozId' in navigator ) {
  $( 'input[type="range"]' ).each( function( ) {
    var style = document.createElement('style');
    var sheet = document.head.appendChild(style).sheet;
    $( this ).data( 'rangerSheet', sheet );
  } );
}

// required to style webkit's actual input
// vs. other browsers' ::track pseudo element
if ( 'webkitRequestAnimationFrame' in window ) {
  $( 'input[type="range"]' ).addClass( 'webkit-track' );
}

// style IE's upper & lower fills only once
var ieStyle = '';
$( 'input[type="range"]' ).each( function( ) {
  ieStyle += ( 'input[name="' + this.name + '"]::-ms-fill-lower { background: ' + $(this).data('backgroundMin') + '; } input[name="' + this.name + '"]::-ms-fill-upper { background: ' + $(this).data('backgroundMax') + '; }' );
} );

$('head').append( '<style type="text/css">' + ieStyle + '</style>' );

// firefox & chrome update the gradient in different ways on the input event
$( 'input[type="range"]' ).on( 'input', function( ) {
  setGradient( this );
} );

function setGradient( input ) {
  var $this = $( input );

  var rangeMin = $this.attr( 'min' ) ? parseFloat( $this.attr( 'min' ) ) : 0.0;
  var rangeMax = $this.attr( 'max' ) ? parseFloat( $this.attr( 'max' ) ) : 100.0;
  var rangeSize = rangeMax - rangeMin;
  var valuePct = Math.min( ( input.value / rangeSize * 100 ) + 10, 100 );
  
  var rangerSheet = $this.data('rangerSheet');
  if ( rangerSheet ) {
    // firefox
    if ( rangerSheet.cssRules.length > 0 ) {
      rangerSheet.deleteRule( 0 );
    }
    
    rangerSheet.insertRule('input[name="' + input.name + '"]::-moz-range-track { background: linear-gradient(to right, ' + $this.data('backgroundMin') + ', #bababa ' + valuePct + '%, ' + $this.data('backgroundMax') + ') }', 0 );
  } else if ( $this.hasClass( 'webkit-track' ) ) {
    // webkit / chrome
    $this.css( 'background', 'linear-gradient(to right, ' + $this.data('backgroundMin') + ', #bababa ' + valuePct + '%, ' + $this.data('backgroundMax') + ')' );
  }
}

//$( 'input[type="range"]' ).trigger( 'input' );

$(function() {
  // weight_sliders are available on all pages via the menu
  weightSliders.init();

  $( document ).on( 'click keyup', hideWeightSlidersOnEvent );

  function hideWeightSlidersOnEvent( e ) {
    // hide weight-sliders if:
    // keyup ESC or
    // click from outside slider panel
    // make it to document
    if ( ( e.type === 'keyup' && e.keyCode === 27 ) ||
        (e.type === 'click' && $(e.target).closest('#configure-panel').length === 0)) {
      var configurePanel = $('#configure-panel');
      if ( !configurePanel.hasClass( 'hidden' ) ) {
        configurePanel.addClass( 'hidden' );
      }
    }
  }
});
