import SiteListButton from "./elements/SiteListButton.svelte";

type SiteListButtonProps = {
  magicToken: string;
  limit: number;
  open: boolean;
  buttonRef: HTMLElement;
  anchorRef: HTMLElement;
  initialFavoriteSites: number[];
};

export function svelteMountSiteListButton(
  target: HTMLElement,
  props: SiteListButtonProps,
): void {
  const app = new SiteListButton({
    target: target,
    props: props,
  });

  props.anchorRef.addEventListener("click", (event: MouseEvent) => {
    event.preventDefault();
    if (props.anchorRef.classList.contains("open")) {
      props.open = false;
    } else {
      props.open = true;
    }
    app.$set(props);
  });
}
