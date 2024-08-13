// moved from ContentFields.svelte

export function recalcHeight(droppableArea: Element): void {
  // Calculate droppable area height
  const contentFields = droppableArea.getElementsByClassName("mt-contentfield");
  let clientHeight = 0;
  for (let i = 0; i < contentFields.length; i++) {
    clientHeight += (contentFields[i] as HTMLElement).offsetHeight;
  }
  if (clientHeight >= droppableArea.clientHeight) {
    jQuery(droppableArea).height(clientHeight + 100);
  } else {
    if (clientHeight >= 400) {
      jQuery(droppableArea).height(clientHeight + 100);
    } else {
      jQuery(droppableArea).height(400 - 8);
    }
  }
}
