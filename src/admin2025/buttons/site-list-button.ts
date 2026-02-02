import SiteListButton from "./elements/SiteListButton.svelte";
import { mount } from "svelte";

type SiteListButtonProps = {
  magicToken: string;
  limit: number;
  open: boolean;
  anchorRef: HTMLElement;
  initialStarredSites: number[];
};

export function svelteMountSiteListButton(
  target: HTMLElement,
  props: SiteListButtonProps,
): void {
  const app = mount(SiteListButton, {
    target: target,
    props: {
      magicToken: props.magicToken,
      limit: props.limit,
      open: props.open,
      anchorRef: props.anchorRef,
      initialStarredSites: props.initialStarredSites,
    },
  });

  props.anchorRef.addEventListener("click", (event: MouseEvent) => {
    event.preventDefault();
    if (props.anchorRef.classList.contains("open")) {
      app.open = false;
    } else {
      app.open = true;
    }
  });
}
