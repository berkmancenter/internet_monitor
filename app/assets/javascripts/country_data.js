$(function() {
  var $countryWikipedia = $(".country-wikipedia");

  if ( $countryWikipedia.length > 0 ) {
    var countryName = $countryWikipedia.data("countryName");

    // request wikipedia article
    

    $.ajax({
        url: "http://en.wikipedia.org/w/api.php?action=mobileview&sections=0&format=json&noheadings&page=" + countryName,
        dataType: "jsonp",
        success: function(result) {
          $("<div>").html(result.mobileview.sections[0].text).find(".infobox").appendTo($countryWikipedia).find("a").attr("href", "javascript:void(0);");
        },
        error: function (xhr) {
          // ignore
          //alert(xhr.status + " " + xhr.statusText);
        }
    });
  }
});
