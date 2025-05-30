import { initWidgets } from "./widget";

describe("initWidgets", () => {
  beforeEach(() => {
    window.CMSScriptURI = "/cgi-bin/mt.cgi";
    document.body.innerHTML = "";
  });

  it("should initialize widgets", () => {
    const searchForm = document.createElement("form");
    searchForm.action = "/cgi-bin/mt.cgi?__mode=search";
    document.body.appendChild(searchForm);

    const container = document.createElement("div");
    container.classList.add("dashboard-widget-template");
    document.body.appendChild(container);

    const widgetForm = document.createElement("form");
    widgetForm.action = "/cgi-bin/mt.cgi?__mode=list_template&blog_id=1";
    container.appendChild(widgetForm);

    initWidgets();
    const origin = location.origin;
    expect(searchForm.action).toBe(`${origin}/cgi-bin/mt.cgi?__mode=search`);
    expect(widgetForm.action).toBe(`${origin}/cgi-bin/mt.cgi`);
  });
});
