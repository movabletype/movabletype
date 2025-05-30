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
}
