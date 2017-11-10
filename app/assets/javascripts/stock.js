$(document).ready(function(){
  $(".stock-box").flip({
    trigger: "manual"
  });

  $(".flip-button").click(function(){
    $(this).closest(".stock-box").flip("toggle");
  });

  $(".glyphicon-chevron-left").click(function(){
    $(this).closest(".stock-box").flip("toggle");
  });
});