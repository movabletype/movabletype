import { render, cleanup } from "@testing-library/svelte";
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { tick } from "svelte";
import ModalTestWrapper from "./ModalTestWrapper.svelte";

Element.prototype.animate = vi.fn().mockReturnValue({
  finished: Promise.resolve(),
  cancel: vi.fn(),
  finish: vi.fn(),
  play: vi.fn(),
  pause: vi.fn(),
  reverse: vi.fn(),
  updatePlaybackRate: vi.fn(),
  addEventListener: vi.fn(),
  removeEventListener: vi.fn(),
  dispatchEvent: vi.fn(),
});

describe("Modal Component", () => {
  beforeEach(() => {
    document.body.classList.remove("modal-open");
  });

  afterEach(() => {
    cleanup();
    document.body.classList.remove("modal-open");
  });

  describe("Rendering", () => {
    it("should render modal when open is true", async () => {
      render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.querySelector(".modal.show");
      expect(modal).toBeInTheDocument();
    });

    it("should not render modal when open is false", async () => {
      render(ModalTestWrapper, {
        props: { open: false },
      });
      await tick();

      const modal = document.querySelector(".modal.show");
      expect(modal).not.toBeInTheDocument();
    });

    it("should render children content", async () => {
      render(ModalTestWrapper, {
        props: { open: true, content: "Test Content" },
      });
      await tick();

      const content = document.querySelector(".test-content");
      expect(content).toBeInTheDocument();
      expect(content?.textContent).toBe("Test Content");
    });

    it("should render backdrop when open", async () => {
      render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      const backdrop = document.querySelector(".modal-backdrop.show");
      expect(backdrop).toBeInTheDocument();
    });
  });

  describe("Accessibility", () => {
    it("should have role dialog", async () => {
      render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.querySelector(".modal");
      expect(modal).toHaveAttribute("role", "dialog");
    });

    it("should have aria-modal true", async () => {
      render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.querySelector(".modal");
      expect(modal).toHaveAttribute("aria-modal", "true");
    });

    it("should set aria-labelledby", async () => {
      render(ModalTestWrapper, {
        props: { open: true, labelledby: "modal-title" },
      });
      await tick();

      const modal = document.querySelector(".modal");
      expect(modal).toHaveAttribute("aria-labelledby", "modal-title");
    });

    it("should set aria-describedby", async () => {
      render(ModalTestWrapper, {
        props: { open: true, describedby: "modal-description" },
      });
      await tick();

      const modal = document.querySelector(".modal");
      expect(modal).toHaveAttribute("aria-describedby", "modal-description");
    });

    it("should have tabindex -1", async () => {
      render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.querySelector(".modal");
      expect(modal).toHaveAttribute("tabindex", "-1");
    });
  });

  describe("CSS Classes", () => {
    it("should apply custom className to modal-dialog", async () => {
      render(ModalTestWrapper, {
        props: { open: true, className: "modal-lg" },
      });
      await tick();

      const dialog = document.querySelector(".modal-dialog");
      expect(dialog).toHaveClass("modal-lg");
    });

    it("should add modal-open class to body when open", async () => {
      render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      expect(document.body).toHaveClass("modal-open");
    });

    it("should remove modal-open class from body when closed", async () => {
      const { rerender } = render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      expect(document.body).toHaveClass("modal-open");

      await rerender({ open: false });
      await tick();

      expect(document.body).not.toHaveClass("modal-open");
    });
  });

  describe("Structure", () => {
    it("should have modal-content wrapper", async () => {
      render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      const content = document.querySelector(".modal-content");
      expect(content).toBeInTheDocument();
    });

    it("should have modal-dialog with role document", async () => {
      render(ModalTestWrapper, {
        props: { open: true },
      });
      await tick();

      const dialog = document.querySelector(".modal-dialog");
      expect(dialog).toHaveAttribute("role", "document");
    });
  });
});
