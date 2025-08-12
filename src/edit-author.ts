const apiPasswordOpener = document.querySelector<HTMLAnchorElement>(
  "#menu-list-item-web_api_password a",
);

if (apiPasswordOpener !== null) {
  apiPasswordOpener.addEventListener("click", (event: MouseEvent) => {
    event.preventDefault();
    jQuery.fn.mtModal.open(apiPasswordOpener.href, { large: true });
  });
}

const apiPasswordDeleter = document.querySelector<HTMLElement>(
  "#delete_api_password",
);

if (apiPasswordDeleter !== null) {
  apiPasswordDeleter.addEventListener("submit", (event: SubmitEvent) => {
    if (
      !confirm(
        window.trans("Are you sure you want to delete the existing password?"),
      )
    ) {
      event.preventDefault();
    }
  });
}

const apiPasswordDisplay = document.querySelector<HTMLInputElement>(
  "#api-password-display",
);

if (apiPasswordDisplay !== null) {
  apiPasswordDisplay.style.width = apiPasswordDisplay.value.length + "ch";

  const copyButton = document.querySelector<HTMLInputElement>(
    "[data-mt-copy-to-clipboard]",
  );

  if (copyButton !== null) {
    const tooltip = new bootstrap.Tooltip(copyButton, {
      container: copyButton,
    });

    copyButton.addEventListener("click", (event: MouseEvent) => {
      event.preventDefault();
      if (window.isSecureContext) {
        navigator.clipboard
          .writeText(copyButton.dataset.mtCopyToClipboard || "")
          .then(() => {
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

function showTooltip(copyButton, tooltip): void {
  copyButton.dataset.bsOriginalTitle = copyButton.dataset.copiedTitle;
  tooltip.update();
  tooltip.show();
  setTimeout(() => {
    copyButton.dataset.bsOriginalTitle = copyButton.getAttribute("aria-label");
    tooltip.update();
    tooltip.hide();
  }, 2000);
}
