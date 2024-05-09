import ListTop from "./listing/elements/ListTop.svelte";

const listTopTarget = document.querySelector('[data-is="list-top"]');
if (!listTopTarget) {
  throw new Error("Target element is not found");
}

const listTop = new ListTop({
  target: listTopTarget,
  props: {
    opts: JSON.parse(
      (document.querySelector("#listing-opts") || {}).textContent || "{}"
    ),
    store: JSON.parse(
      (document.querySelector("#listing-store") || {}).textContent || "{}"
    ),
  },
});

export { listTop };
