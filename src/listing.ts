import ListTop from "./listing/elements/ListTop.svelte";

const listTop = new ListTop({
  target: document.querySelector('[data-is="list-top"]').parentNode,
  props: {
    opts: JSON.parse(document.querySelector("#listing-opts").textContent),
    store: JSON.parse(document.querySelector("#listing-store").textContent),
  },
});
