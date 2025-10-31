import {
  getCollapsedState,
  setGlobalCollapsedDomAttribute,
} from "./sidebar/utils";
setGlobalCollapsedDomAttribute(getCollapsedState() ?? false);
