import CreateButton from "./elements/CreateButton.svelte";
import { mount } from "svelte";

type CreateButtonProps = {
  blog_id: string;
  magicToken: string;
  open: boolean;
  anchorRef: HTMLElement;
  containerRef: HTMLElement;
};

export const svelteMountCreateButton = ({
  target,
  props,
}: {
  target: HTMLElement;
  props: CreateButtonProps;
}): void => {
  const state = $state({
    blog_id: props.blog_id,
    magicToken: props.magicToken,
    open: props.open,
    anchorRef: props.anchorRef,
    containerRef: props.containerRef,
  });

  mount(CreateButton, {
    target: target,
    props: state,
  });

  target.addEventListener("click", (event: MouseEvent) => {
    event.preventDefault();
    if (props.anchorRef.classList.contains("open")) {
      state.open = false;
    } else {
      state.open = true;
    }
  });
};
