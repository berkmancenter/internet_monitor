$(function() {
  $(".country-data select").change( function( ) {
    window.location.href = $(this).val();
  } );

  var $countryWikipedia = $(".country-wikipedia");

  if ( $countryWikipedia.length > 0 ) {
    var countryName = $countryWikipedia.data("countryName");

    // request wikipedia article
    

    $.ajax({
      url: "http://en.wikipedia.org/w/api.php?action=mobileview&sections=0&format=json&noheadings&page=" + countryName,
      dataType: "jsonp",
      success: function(result) {
        var infobox = $("<div>").html(result.mobileview.sections[0].text).find(".infobox");
        
        if ( infobox.length > 0 ) {
          infobox.appendTo($countryWikipedia).find("a").attr("href", "javascript:void(0);");
        } else {
          // try (country)
          $.ajax({
            url: "http://en.wikipedia.org/w/api.php?action=mobileview&sections=0&format=json&noheadings&page=" + countryName + "_(country)",
            dataType: "jsonp",
            success: function(result) {
              $("<div>").html(result.mobileview.sections[0].text).find(".infobox").appendTo($countryWikipedia).find("a").attr("href", "javascript:void(0);");
            }
          });
        }
      }
    });
  }
});
