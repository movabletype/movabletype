import type * as ContentType from "../@types/contenttype";

import { writable } from "svelte/store";

import ContentFieldTypes from "./ContentFieldTypes";

import ContentFields from "./elements/ContentFields.svelte";

import ContentTypeCustomType from "./elements/ContentTypeCustomType.svelte";

class CustomType extends HTMLElement {
  options: ContentType.Options = {};
  connectedCallback(): void {
    this.options = JSON.parse(this.getAttribute("data-options") || "{}");
  }
  disconnectedCallback(): void {}
}

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

export default class ContentTypeEditor {
  static accessor config: ContentType.ConfigSettings = {};
  static accessor fieldsStore: ContentType.FieldsStore;
  static accessor optionsHtmlParams: ContentType.OptionsHtmlParams = {};
  static accessor opts: ContentType.ContentFieldsOpts;
  static readonly types = ContentFieldTypes;
  static readonly CustomType = CustomType;

  static registerCustomType(
    type: string,
    mountFunction:
      | ContentType.CustomContentFieldMountFunction
      | typeof CustomType,
  ): void {
    if (mountFunction.prototype instanceof CustomType) {
      const customElement = `mt-content-type-custom-type-${type}`;
      customElements.define(customElement, mountFunction as typeof CustomType);
      mountFunction = (props, target) => {
        let options: ContentType.Options;
        const customType = new ContentTypeCustomType({
          props: {
            ...props,
            type,
            customElement,
            updateOptions: (_options: ContentType.Options) => {
              options = _options;
            },
          },
          target: target,
        });
        return {
          component: customType,
          gather: () => {
            return options;
          },
          destroy: () => {
            customType.$destroy();
          },
        };
      };
    }
    this.types.registerCustomType(
      type,
      mountFunction as ContentType.CustomContentFieldMountFunction,
    );
  }

  static mount(
    targetSelector: string,
    opts: ContentType.ContentFieldsOpts,
  ): void {
    const target = this.getContentFieldsTarget(targetSelector);

    this.fieldsStore = writable(opts.fields);
    this.opts = opts;

    new ContentFields({
      props: {
        config: this.config,
        fieldsStore: this.fieldsStore,
        optionsHtmlParams: this.optionsHtmlParams,
        opts: this.opts,
        root: target,
      },
      target: target,
    });
  }

  private static getContentFieldsTarget(selector: string): Element {
    const target = document.querySelector(`[data-is="${selector}"]`);
    if (!target) {
      throw new Error("Target element is not found: " + selector);
    }
    return target;
  }
}
