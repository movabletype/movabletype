export class Alert {
  static danger(data): void {
    this.write("danger", data);
  }

  static warning(data): void {
    this.write("warning", data);
  }

  static info(data): void {
    this.write("info", data);
  }

  private static async write(level, data): Promise<void> {
    const container = document.querySelector(".mt-mainContent");
    if (!container) {
      window.alert(data);
      return;
    }

    // FIXME: render by svelte component
    const msg = document.createTextNode(data);
    const template = document.createElement("template");
    template.innerHTML = `
<div class="alert alert-${level} alert-dismissible fade show" role="alert">
  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
    <span aria-hidden="true">&times;</span>
  </button>
</div>
    `;
    const alert = template.content.querySelector("div") as HTMLElement;
    alert.insertBefore(msg, alert.firstChild);

    const before =
      (
        container.querySelector("#page-title") ||
        container.querySelector(".mt-breadcrumb")
      )?.nextElementSibling || null;
    container.insertBefore(alert, before);
  }
}
