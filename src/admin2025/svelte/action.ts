export const modalOverlay = (node: HTMLElement): void => {
  const scrollbarWidth =
    window.innerWidth - document.documentElement.clientWidth;
  if (scrollbarWidth > 0) {
    document.documentElement.style.setProperty(
      "--scrollbar-width",
      `${scrollbarWidth}px`,
    );
  }

  node.classList.add("mt-modal-overlay");
};
