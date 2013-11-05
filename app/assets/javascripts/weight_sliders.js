// From: http://stackoverflow.com/questions/10457264/how-to-find-first-element-of-array-matching-a-boolean-condition-in-javascript
Array.prototype.findFirst = function (predicateCallback) {
    if (typeof predicateCallback !== 'function') {
        return undefined;
    }

    for (var i = 0; i < this.length; i++) {
        if (i in this && predicateCallback(this[i])) return this[i];
    }

    return undefined;
};

jQuery.fn.reverse = function() {
   return Array.prototype.reverse.call(this);
};

jQuery.fn.commonAncestor = function() {
   var i, l, current,
      compare = this.eq(0).parents().reverse(),
      pos = compare.length - 1;
   for (i = 1, l = this.length; i < l && pos > 0; i += 1) {
      current = this.eq(i).parents().reverse();
      pos = Math.min(pos, current.length - 1);
      while (compare[pos] !== current[pos]) {
         pos -= 1;
      }
   }
   return compare.eq(pos);
};

var weightSliders = {
    SLIDER_SELECTOR  : '.weight-slider',
    SCORE_SELECTOR   : '.score',
    WEIGHT_ATTRIBUTE : 'default-weight',
    COUNTRIES_PATH   : '/countries.json',
    COUNTRY_PATH     : '/countries/{id}.json',
    MAX_SCORE        : 10.0,
    PRECISION        : 3,

    sliderObjects    : [],
    scoreObjects     : [],
    countryData      : [],
    indicatorWeights : {},
    directions       : {},

    init : function() {
        var countryId = $('.country').first().data('country-id');
        var data_path = (typeof countryId === 'undefined') ?
            this.COUNTRIES_PATH : this.COUNTRY_PATH.replace('{id}', countryId);
        /*
        $.get(data_path, function(data) {
            weightSliders.countryData = (data instanceof Array) ? data : [data];
            weightSliders.sliderObjects.noUiSlider('disabled', false);
        });
        */

        $('.toggle-weight-sliders').click( function() {
          $('#weight-sliders').toggleClass('hidden');
          return false;
        } );

        this.sliderObjects = $(this.SLIDER_SELECTOR);
        this.scoreObjects = $(this.SCORE_SELECTOR);

        this.sliderObjects.noUiSlider({
            range   : [0, 2],
            start   : 0,
            slide: function() {
              console.log( this[0].id + ': ' + this.val( ) );
              $.scoreKeeper.setWeight( this[0].id, this.val( ) );
            },
            set: function() {
              console.log( this[0].id + ': ' + this.val( ) );
              $.scoreKeeper.setWeight( this[0].id, this.val( ) );
            },
            step    : 0.1,
            handles : 1
        }).each(function() { 
            var weight = parseFloat($(this).data(weightSliders.WEIGHT_ATTRIBUTE));
            weightSliders.indicatorWeights[$(this).attr('id')] = Math.abs(weight);
            weightSliders.directions[$(this).attr('id')] = weight;
            $(this).val(Math.abs(weight)).noUiSlider('disabled', false); 
        });
    },
    updateScores : function() {
        weightSliders.indicatorWeights[$(this).attr('id')] = $(this).val();
        var common = weightSliders.scoreObjects.commonAncestor(),
            commonPrevSibling = common.prev(),
            commonParent = common.parent();
        common.detach();
        weightSliders.scoreObjects.each(function() {
            var scoreData = weightSliders.categoryAndCountryId($(this)),
                category  = scoreData[0],
                countryId = scoreData[1],
                country   = weightSliders.countryData.findFirst(function(c) { return c.country.id == countryId; }).country,
                newScore  = weightSliders.calculateScore(country, category);

            $(this).text(newScore.toPrecision(weightSliders.PRECISION)).trigger('scorechange');
        });
        if (commonPrevSibling.length == 0) {
            commonParent.prepend(common);
        } else {
            common.insertAfter(commonPrevSibling);
        }
    },
    calculateScore: function(country, category) {
        var indicators = [], weights = [];
        if (category == 'total') {
            indicators = country.indicators;
        } else {
            indicators = country.indicators.filter(function(i) { return i.category.toLowerCase() == category; });
        }
        
        weights = weightSliders.weights(indicators.map(function(i) { return i.source_id }));
        directions = weightSliders.directions(indicators.map(function(i) { return i.source_id }));
        var sum = indicators.reduce(function(sum, indi, i) {
                var output = sum + indi.normalized_value * weights[i] * directions[i];
                if (directions[i] < 0) output += 1;
                return output;
            }, 0.0),
            average = sum / indicators.length,
            score = average * weightSliders.MAX_SCORE;
        return score;
    },
    categoryAndCountryId: function(scoreObject) {
        return /(total|access|activity|control)-for-(\d+)/.exec(scoreObject.data('score-desc')).slice(1)
    },
    weights: function(indicatorIds) {
        return indicatorIds.map(function(i) { return weightSliders.indicatorWeights['slider-' + i]; })
    },
    directions: function(indicatorIds) {
        return indicatorIds.map(function(i) { return weightSliders.directions['slider-' + i]; })
    },
    indicatorId: function(slider) { return $(slider).attr('id').match(/slider-(\d+)/)[1]; }
};

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
      ( e.type === 'click' && $( e.target ).closest( '#weight-sliders' ).length === 0 ) ) {
      var weightSliders = $( '#weight-sliders' );
      if ( !weightSliders.hasClass( 'hidden' ) ) {
        weightSliders.addClass( 'hidden' );
      }
    }
  }
});
