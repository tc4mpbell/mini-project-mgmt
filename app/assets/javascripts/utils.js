document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll("[data-user-date]").forEach(function(el) {
    var dateInUserTz = new Date(el.innerText);
    el.innerText = dateInUserTz.toLocaleString();
  });
});
