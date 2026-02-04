customElements.define(
  "mt-content-field-option",
  class extends HTMLElement {
    connectedCallback(): void {
      const id = this.getAttribute("id") || "";
      const attr = this.getAttribute("attr") || "";
      const attrShow = this.getAttribute("attr-show");
      const hint = this.getAttribute("hint") || "";
      const label = this.getAttribute("label") || "";
      const required = this.getAttribute("required") === "1";
      const showHint = this.getAttribute("show-hint") === "1";
      const showLabel = this.getAttribute("show-label") !== "0";

      if (!id) {
        console.error("ContentFieldOption: 'id' attribute missing");
        return;
      }

      const wrapper = document.createElement("div");
      wrapper.id = `${id}-field`;
      wrapper.className = "form-group";

      if (required) {
        wrapper.classList.add("required");
      }

      if (attr) {
        wrapper.setAttribute("attr", attr);
      }

      if (attrShow !== null) {
        if (attrShow === "true") {
          wrapper.style.display = "";
        } else {
          wrapper.hidden = true;
          wrapper.style.display = "none";
        }
      }

      if (label && showLabel) {
        const labelElement = document.createElement("label");
        labelElement.setAttribute("for", id);
        labelElement.textContent = label;

        if (required) {
          const badge = document.createElement("span");
          badge.className = "badge badge-danger";
          badge.textContent = (
            window as { trans: (key: string) => string }
          ).trans("Required");
          labelElement.appendChild(badge);
        }

        wrapper.appendChild(labelElement);
      }

      while (this.firstChild) {
        wrapper.appendChild(this.firstChild);
      }

      if (hint && showHint) {
        const hintElement = document.createElement("small");
        hintElement.id = `${id}-field-help`;
        hintElement.className = "form-text text-muted";
        hintElement.textContent = hint;
        wrapper.appendChild(hintElement);
      }

      this.appendChild(wrapper);
    }
  },
);
