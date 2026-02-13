import { render, fireEvent, cleanup } from "@testing-library/svelte";
import { describe, it, expect, vi, afterEach } from "vitest";
import { tick } from "svelte";
import ModalContentTestWrapper from "./ModalContentTestWrapper.svelte";

describe("ModalContent Component", () => {
  afterEach(() => {
    cleanup();
  });

  describe("Rendering", () => {
    it("should render modal-body", async () => {
      const { container } = render(ModalContentTestWrapper, {
        props: { bodyText: "Body Content" },
      });
      await tick();

      const body = container.querySelector(".modal-body");
      expect(body).toBeInTheDocument();
      expect(body?.textContent).toContain("Body Content");
    });

    it("should render modal-footer", async () => {
      const { container } = render(ModalContentTestWrapper, {
        props: { footerText: "Footer Content" },
      });
      await tick();

      const footer = container.querySelector(".modal-footer");
      expect(footer).toBeInTheDocument();
      expect(footer?.textContent).toContain("Footer Content");
    });
  });

  describe("Header", () => {
    it("should render modal-header when title is provided", async () => {
      const { container } = render(ModalContentTestWrapper, {
        props: { hasTitle: true, titleText: "Modal Title" },
      });
      await tick();

      const header = container.querySelector(".modal-header");
      expect(header).toBeInTheDocument();
    });

    it("should render title", async () => {
      const { container } = render(ModalContentTestWrapper, {
        props: { hasTitle: true, titleText: "Modal Title" },
      });
      await tick();

      const title = container.querySelector(".modal-title");
      expect(title).toBeInTheDocument();
      expect(title?.tagName).toBe("H4");
      expect(title?.textContent).toBe("Modal Title");
    });

    it("should not render modal-header when title is not provided", async () => {
      const { container } = render(ModalContentTestWrapper, {
        props: { hasTitle: false, hasFooter: false },
      });
      await tick();

      const header = container.querySelector(".modal-header");
      expect(header).not.toBeInTheDocument();
    });
  });

  describe("Close Button", () => {
    it("should render close button in header", async () => {
      const { container } = render(ModalContentTestWrapper, {
        props: { hasTitle: true },
      });
      await tick();

      const closeBtn = container.querySelector("button.close");
      expect(closeBtn).toBeInTheDocument();
    });

    it("should have aria-label Close", async () => {
      const { container } = render(ModalContentTestWrapper, {
        props: { hasTitle: true },
      });
      await tick();

      const closeBtn = container.querySelector("button.close");
      expect(closeBtn).toHaveAttribute("aria-label", "Close");
    });

    it("should have data-dismiss modal", async () => {
      const { container } = render(ModalContentTestWrapper, {
        props: { hasTitle: true },
      });
      await tick();

      const closeBtn = container.querySelector("button.close");
      expect(closeBtn).toHaveAttribute("data-dismiss", "modal");
    });

    it("should call custom close function when clicked", async () => {
      const closeFn = vi.fn();
      const { container } = render(ModalContentTestWrapper, {
        props: { hasTitle: true, close: closeFn },
      });
      await tick();

      const closeBtn = container.querySelector("button.close") as HTMLElement;
      await fireEvent.click(closeBtn);

      expect(closeFn).toHaveBeenCalledTimes(1);
    });

    it("should call context closeModal when close prop not provided", async () => {
      const onCloseModal = vi.fn();
      const { container } = render(ModalContentTestWrapper, {
        props: { hasTitle: true, onCloseModal },
      });
      await tick();

      const closeBtn = container.querySelector("button.close") as HTMLElement;
      await fireEvent.click(closeBtn);

      expect(onCloseModal).toHaveBeenCalledTimes(1);
    });
  });
});
