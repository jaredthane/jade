//$(document).ajaxSend(function(event, request, settings) {
//  if (typeof(AUTH_TOKEN) == "undefined") return;
//  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
//  settings.data = settings.data || "";
//  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
//});


(function($) {
  $().ajaxSend(function(event, request, settings){ //Set request headers globally
    request.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    if (typeof(AUTH_TOKEN) == "undefined") return;
    settings.data = settings.data || "";
    // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
    settings.data += ((settings.data == "") ? "" : "&") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
  });
})(jQuery);
