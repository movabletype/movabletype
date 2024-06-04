export function recalcHeight(droppableArea) {
  // Calculate droppable area height
  const contentFields = droppableArea.getElementsByClassName("mt-contentfield");
  let clientHeight = 0;
  for (var i = 0; i < contentFields.length; i++) {
    clientHeight += contentFields[i].offsetHeight;
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

export function update() {
  let select = document.querySelector("#label_field");
  jQuery(select)
    .find("option")
    .each(function (index, option) {
      if (option.attributes.selected) {
        select.selectedIndex = index;
        return false;
      }
    });
}
