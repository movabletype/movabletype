import { render, cleanup } from "@testing-library/svelte";
import { describe, it, expect, vi, afterEach, beforeEach } from "vitest";
import HtmlElement from "./HtmlElement.svelte";

describe("HtmlElement Component", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    cleanup();
    vi.useRealTimers();
  });

  describe("Element Rendering", () => {
    it("should append HTMLElement to container", async () => {
      const element = document.createElement("div");
      element.className = "test-element";
      element.textContent = "Test Content";

      const { container } = render(HtmlElement, {
        props: {
          element,
          event: new CustomEvent("test"),
        },
      });

      const wrapper = container.querySelector("div");
      const testElement = wrapper?.querySelector(".test-element");
      expect(testElement).toBeInTheDocument();
      expect(testElement?.textContent).toBe("Test Content");
    });

    it("should create element from custom element tag name", async () => {
      class TestCustomElement extends HTMLElement {
        connectedCallback(): void {
          this.textContent = "Custom Element";
        }
      }
      customElements.define("test-custom-element", TestCustomElement);

      const { container } = render(HtmlElement, {
        props: {
          element: "test-custom-element",
          event: new CustomEvent("test"),
        },
      });

      const wrapper = container.querySelector("div");
      expect(wrapper?.querySelector("test-custom-element")).toBeInTheDocument();
    });

    it("should create div with innerHTML when string is not custom element", async () => {
      const { container } = render(HtmlElement, {
        props: {
          element: "<span class='html-content'>HTML String</span>",
          event: new CustomEvent("test"),
        },
      });

      const wrapper = container.querySelector("div");
      const innerDiv = wrapper?.querySelector("div");
      expect(innerDiv?.innerHTML).toBe(
        '<span class="html-content">HTML String</span>',
      );
    });
  });

  describe("Event Dispatching", () => {
    it("should dispatch event to element after mount", async () => {
      const element = document.createElement("div");
      const eventSpy = vi.fn();
      element.addEventListener("test", eventSpy);

      render(HtmlElement, {
        props: {
          element,
          event: new CustomEvent("test", { detail: { data: "test" } }),
        },
      });

      vi.advanceTimersByTime(0);

      expect(eventSpy).toHaveBeenCalledTimes(1);
    });

    it("should dispatch CustomEvent with detail", async () => {
      const element = document.createElement("div");
      let receivedDetail: unknown;
      element.addEventListener("message", (e) => {
        receivedDetail = (e as CustomEvent).detail;
      });

      render(HtmlElement, {
        props: {
          element,
          event: new CustomEvent("message", { detail: { key: "value" } }),
        },
      });

      vi.advanceTimersByTime(0);

      expect(receivedDetail).toEqual({ key: "value" });
    });
  });

  describe("Callbacks", () => {
    it("should call onready after event dispatch", async () => {
      const onready = vi.fn();
      const element = document.createElement("div");

      render(HtmlElement, {
        props: {
          element,
          event: new CustomEvent("test"),
          onready,
        },
      });

      expect(onready).not.toHaveBeenCalled();

      vi.advanceTimersByTime(0);

      expect(onready).toHaveBeenCalledTimes(1);
    });

    it("should not throw when onready is not provided", async () => {
      const element = document.createElement("div");

      expect(() => {
        render(HtmlElement, {
          props: {
            element,
            event: new CustomEvent("test"),
          },
        });
        vi.advanceTimersByTime(0);
      }).not.toThrow();
    });

    it("should pass onmessage to container div", async () => {
      const onmessage = vi.fn();
      const element = document.createElement("div");

      const { container } = render(HtmlElement, {
        props: {
          element,
          event: new CustomEvent("test"),
          onmessage,
        },
      });

      const wrapper = container.querySelector("div");
      expect(wrapper).toBeInTheDocument();
    });
  });
});
