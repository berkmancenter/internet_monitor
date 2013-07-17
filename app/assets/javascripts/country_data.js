$(function() {
  $(".country-data select").change( function( ) {
    window.location.href = $(this).val();
  } );
});
