
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35732/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
const apiPasswordOpener = document.querySelector("#menu-list-item-web_api_password a");
if (apiPasswordOpener !== null) {
  apiPasswordOpener.addEventListener("click", (event) => {
    event.preventDefault();
    jQuery.fn.mtModal.open(apiPasswordOpener.href, { large: true });
  });
}
const apiPasswordDeleter = document.querySelector("#delete_api_password");
if (apiPasswordDeleter !== null) {
  apiPasswordDeleter.addEventListener("submit", (event) => {
    if (!confirm(window.trans("Are you sure you want to delete the existing password?"))) {
      event.preventDefault();
    }
  });
}
const apiPasswordDisplay = document.querySelector("#api-password-display");
if (apiPasswordDisplay !== null) {
  apiPasswordDisplay.style.width = apiPasswordDisplay.value.length + "ch";
  const copyButton = document.querySelector("[data-mt-copy-to-clipboard]");
  if (copyButton !== null) {
    const tooltip = new bootstrap.Tooltip(copyButton, {
      container: copyButton
    });
    copyButton.addEventListener("click", (event) => {
      event.preventDefault();
      if (window.isSecureContext) {
        navigator.clipboard.writeText(copyButton.dataset.mtCopyToClipboard || "").then(() => {
          showTooltip(copyButton, tooltip);
        });
      } else {
        apiPasswordDisplay.select();
        document.execCommand("copy");
        showTooltip(copyButton, tooltip);
      }
    });
  }
}
function showTooltip(copyButton, tooltip) {
  copyButton.dataset.bsOriginalTitle = copyButton.dataset.copiedTitle;
  tooltip.update();
  tooltip.show();
  setTimeout(() => {
    copyButton.dataset.bsOriginalTitle = copyButton.getAttribute("aria-label");
    tooltip.update();
    tooltip.hide();
  }, 2e3);
}
//# sourceMappingURL=edit-author.js.map
