import SiteListButton from "./elements/SiteListButton.svelte";

type SiteListButtonProps = {
  magicToken: string;
  limit: number;
};

export function svelteMountSiteListButton(
  target: Element,
  props: SiteListButtonProps,
): void {
  new SiteListButton({
    target: target,
    props: props,
  });
}
