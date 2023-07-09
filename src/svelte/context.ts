import { getContext, setContext } from "svelte";

interface ModalContext {
  closeModal: () => void;
}

const modalKey = Symbol();

export function setModalContext(ctx: ModalContext): void {
  setContext(modalKey, ctx);
}

export function getModalContext(): ModalContext {
  return getContext(modalKey);
}
