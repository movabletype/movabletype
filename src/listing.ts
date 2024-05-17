import ListTop from "./listing/elements/ListTop.svelte";

function getListTopTarget(): Element {
  const listTopTarget = document.querySelector('[data-is="list-top"]');
  if (!listTopTarget) {
    throw new Error("Target element is not found");
  }
  return listTopTarget;
}

// TODO
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function svelteMountListTop(props: any): ListTop {
  const listTopTarget = getListTopTarget();
  const listTop = new ListTop({
    target: listTopTarget,
    props: props,
  });
  return listTop;
}

export { svelteMountListTop };
