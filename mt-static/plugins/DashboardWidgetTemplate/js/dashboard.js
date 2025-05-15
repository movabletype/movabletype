document.querySelectorAll(".dashboard-widget-template form").forEach((form) => {
  form.action = location.pathname
});
