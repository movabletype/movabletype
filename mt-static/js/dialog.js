/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
*/

/* requires js/common/Core.js to be loaded first */

Dialog = {};

Dialog.Simple = new Class(Object, {
    init: function(name) {
        this.name = name;
        this.callback = null;
        this.element = TC.elementOrId(name + "-dialog");
    },
    close: function(data) {
        if (this.callback) this.callback(data);
    },
    open: function(data, callback) {
        if (callback) this.callback = callback;
        this.render();
    },
    render: Function.stub
});

/***
 * Dialog.MultiPanel
 * Dialog that displays multiple panels.
 */
Dialog.MultiPanel = new Class(Dialog.Simple, {
    init: function(name) {
        Dialog.MultiPanel.superClass.init.apply(this, arguments);
        this.panels = [];
        this.currentPanel = 0;
    },
    setPanels: function(panels) {
        this.panels = []; // reset
        // sets the order...
        for (var i = 0; i < panels.length; i++) {
            var panel;
            if (typeof panels[i] == 'object') {
                panel = panels[i];
            } else {
                panel = new ListingPanel(panels[i]);
            }
            panel.parent = this;
            this.panels[this.panels.length] = panel;
        }
        this.currentPanel = 0;
        this.panels[0].show();
    },
    nextPanel: function() {
        if (this.currentPanel + 1 >= this.panels.length)
            return;
        var old_panel = this.panels[this.currentPanel];
        var new_panel = this.panels[this.currentPanel+1];
        new_panel.show();
        old_panel.hide();
        this.currentPanel++;
    },
    previousPanel: function() {
        if (this.currentPanel - 1 < 0)
            return;
        var old_panel = this.panels[this.currentPanel];
        var new_panel = this.panels[this.currentPanel-1];
        new_panel.show(); old_panel.hide();
        this.currentPanel--;
    },
    selectPanel: function(index) {
        index = 1 * index;  // Make sure index is number.
        if (index < 0 || this.panels.length <= index )
            return;
        if ( index == this.currentPanel )
            return;
        var old_panel = this.panels[this.currentPanel];
        var new_panel = this.panels[index];
        new_panel.show();
        old_panel.hide();
        this.currentPanel = index;
    }
});

/***
 * SelectionList class
 * Methods:
 *   constructor(el): Creates a new SelectionList object with
 *     the DOM element 'el' specified as the container element.
 *   toggle(name, data): Adds element 'name' to the list of
 *     selected items if it is not selected already. If already
 *     selected, it will remove item 'name'.
 *   add(name, data): Adds element 'name' to the selected list.
 *   remove(name): Removes element 'name' from the selected list.
 *   render(): Refreshes the container element with the list of
 *     selected items.
 *   items(): returns an array of items that have been selected.
 */
SelectionList = new Class(Object, {
    init: function(el) {
        this.container = el;
        this.itemHash = {};
        this.itemList = [];
        this.onChange = null;
        this.render();
    },
    toggle: function(name, data) {
        if (name in this.itemHash)
            this.remove(name, data);
        else
            this.add(name, data);
    },
    add: function(name, data) {
        if (!(name in this.itemHash)) {
            var display = name;
            var row = TC.elementOrId(name);
            if (!data || (data && !data.label)) {
                if (!data) data = {};
                if (row) {
                    var label = jQuery(row).find('.panel-label').get(0);
                    if (label)
                        data.label = label.innerHTML;
                }
                if (!data.label) data.label = name;
            }
            this.itemHash[name] = data;
            this.itemList[this.itemList.length] = name;
            this.changed(true, name, this.itemHash[name]);
            this.render();
        }
    },
    remove: function(name) {
        if (name in this.itemHash) {
            var pos;
            for (pos = 0; pos < this.itemList.length; pos++) {
                if (this.itemList[pos] == name) {
                    this.itemList.splice(pos, 1);
                    this.changed(false, name, this.itemHash[name]);
                    delete this.itemHash[name];
                    this.render();
                    return;
                }
            }
        }
    },
    changed: function(selected, name, data) {
        if (this.onChange) this.onChange(this,selected,name,data);
    },
    render: function() {
        if (!this.container) return;
        var doc = TC.getOwnerDocument(this.container);
        var self = this;
        // remove child selected-item
        jQuery(this.container).find('.selected-item').remove();
        // remove none label
        jQuery(this.container).find('.none_label').remove();
        var makeclosure = function(x) { return function() { self.remove(x) } };
        for (var i = 0; i < this.itemList.length; i++) {
            var p = this.itemList[i];
            var d = this.itemHash[p];
            var l = d.label;
            l.replace(/\s/g, '&nbsp;');
            var link = doc.createElement("span");
            link.setAttribute("id","selected-"+p);
            link.setAttribute("class","badge badge-pill badge-default sticky-label selected-item");
            link.setAttribute("aria-label", "Close")
            link.onclick = makeclosure(p);
            link.innerHTML = l + "&nbsp;<span aria-hidden='true' class='tag-pill remove clickable' style='cursor: pointer;'>×</span>";
            this.container.appendChild(link);
            this.container.appendChild(doc.createTextNode(' '));
        }
        if (this.itemList.length == 0){
            // append None label
            var $none_text = jQuery('<span></span>');
            $none_text.addClass('none_label');
            $none_text.text(trans('(None)'));
            jQuery(this.container).append($none_text);
        }
    },
    items: function() {
        var items = [];
        for (var i = 0; i < this.itemList.length; i++)
            items[i] = this.itemList[i];
        return items;
    }
});

/***
 * Panel class
 * Base functionality of a Panel within a container.
 * Methods:
 *   constructor(name): Creates a new Panel object with 'name'
 *     as the name (expects a DOM id'd element of "(name)-panel"
 *     within the document).
 *   show: Removes the 'hidden' CSS class from the panel.
 *   hide: Assigns the 'hidden' CSS class to the panel.
 */
Panel = new Class(Object, {
    init: function(name) {
        this.parent = null;
        this.name = name;
        this.element = TC.elementOrId(name + "-panel");
    },
    show: function() {
        jQuery(this.element).show();
    },
    hide: function() {
        jQuery(this.element).hide();
    }
});

/* Structure of a ListingPanel...
 *
 *
 *
 *  THIS IS OUT OF DATE
 *
 *
 *
 *   var panel = new ListingPanel("panelname");
 *   dialog.setPanels([panel]);
 *   dialog.open({}, close_callback);
 *
 *   <div id="panelname-panel" class="panel">
 *     <h2>Heading</h2>
 *     <div class="search-box">
 *       <form action="" method="get">
 *         <input type="text" name="search-input" />
 *         <input type="submit" />
 *         <input type="button" class="search-reset" />
 *       </form>
 *     </div>
 *     <div class="selector list">           (wrapper for TableSelect)
 *       <form action="" method="get" onsubmit="return false">
 *         <table>(headers)</table>          (fixed headers)
 *         <div class="list-data-wrapper">   (scrolling container)
 *           <table class="list-data">       (scrolling data)
 *             <tr id="selection-id">
 *               <td><input type="checkbox" class="select" /></td>
 *               <td><label>Display label</label></td>
 *             </tr>
 *           </table>
 *         </div>
 *       </form>
 *     </div>
 *     <div class="pager">...</div>
 *     <div class="items-wrapper">
 *       <span class="items">...</span>
 *     </div>
 *     <div class="panel-commands">
 *       <form action="" method="get" onsubmit="return false">
 *         <input type="button" class="cancel" />
 *         <input type="button" class="previous" value="Back" />
 *         <input type="button" class="next" value="Continue" />
 *         <input type="button" class="close" value="Close" />
 *       </form>
 *     </div>
 *   </div>
 */
ListingPanel = new Class(Panel, {
    listChanged: function(ts, row, checked) {
        if (this.selectionList) {
            if (checked)
                this.selectionList.add(row.id);
            else
                this.selectionList.remove(row.id);
        } else {
            var count = ts.selected().length;
            if (this.nextButton) {
                if (count == 0)
                    TC.addClassName(this.nextButton, "disabled");
                else
                    TC.removeClassName(this.nextButton, "disabled");
                this.nextButton.disabled = count == 0;
            }
            if (this.closeButton) {
                if (count == 0)
                    TC.addClassName(this.closeButton, "disabled");
                else
                    TC.removeClassName(this.closeButton, "disabled");
                this.closeButton.disabled = count == 0;
            }
        }
    },
    init: function(name, searchtype) {
        ListingPanel.superClass.init.apply(this, arguments);

        var panelId = name + '-panel';
        this.footerElement = TC.getElementsByClassName("modal-footer", panelId)[0];

        // for closures
        var self = this;

        this.listData = TC.getElementsByTagAndClassName("div",
            "list-data", this.element)[0];

        // FIXME: name != type...
        this.datasource = new Datasource(this.listData, name, searchtype);
        this.pager = new Pager(TC.getElementsByTagAndClassName("ul",
            "pagination", this.element)[0]);
        this.datasource.setPager(this.pager);
        this.datasource.onUpdate = function(ds) {
            // synchronize selections in table with selections in
            // selectionList.
            if (self.selectionList)
                self.tableSelect.selectThese(self.selectionList.items());
        };

        // buttons
        var search = TC.getElementsByTagAndClassName("input",
            "search-input", this.element);
        if (search && search.length) {
            this.searchField = search[0];
            this.searchField.form.onsubmit = function() {
                self.datasource.search(self.searchField.value);
                if (self.searchReset)
                    jQuery(self.searchReset).show();
                return false;
            };
        }
        var search_reset = TC.getElementsByClassName("search-reset", this.element);
        if (search_reset && search_reset.length) {
            this.searchReset = search_reset[0];
            this.searchReset.onclick = function() {
                self.datasource.navigate(0);
                self.searchField.value = "";
                jQuery(self.searchReset).hide();
                return false;
            };
        }

        var next = TC.getElementsByTagAndClassName("button",
            "next", this.footerElement);
        if (next && next.length) {
            this.nextButton = next[0];
            this.nextButton.onclick = function() {
                self.parent.nextPanel();
            };
        }

        var previous = TC.getElementsByTagAndClassName("button",
            "previous", this.footerElement);
        if (previous && previous.length) {
            this.previousButton = previous[0];
            this.previousButton.onclick = function() {
                self.parent.previousPanel();
            };
        }

        var cancel = TC.getElementsByTagAndClassName("button",
            "cancel", this.footerElement);
        if (cancel && cancel.length) {
            this.cancelButton = cancel[0];
            this.cancelButton.onclick = function() {
                self.parent.close(false);
            };
        }

        var close = TC.getElementsByTagAndClassName("button",
            "close-button", this.footerElement);
        if (close && close.length) {
            this.closeButton = close[0];
            this.closeButton.onclick = function() {
                self.parent.close(true);
            };
        }

        var selector = TC.getElementsByTagAndClassName("div",
            "selector", this.element);
        if (selector && selector.length) {
            this.tableSelect = new TC.TableSelect(selector[0]);
            this.tableSelect.rowSelect = true;
            this.tableSelect.onChange = function(ts, row, checked) {
                self.listChanged(ts, row, checked);
            };
        }

        // selections
        var items = TC.getElementsByClassName("modal-selections",
            this.element);
        if (items && items.length) {
            this.selectionList = new SelectionList(items[0]);
            this.selectionList.onChange =
            function(sl, selected, name, data) {
                var row = TC.elementOrId(name);
                if (row) {
                    self.tableSelect.selectRow(row, selected);
                    self.tableSelect.selectAll();
                }
                var items = sl.items();
                if (self.nextButton) {
                    if (items.length == 0)
                        TC.addClassName(self.nextButton, "disabled");
                    else
                        TC.removeClassName(self.nextButton, "disabled");
                    self.nextButton.disabled = items.length == 0;
                }
                if (self.closeButton) {
                    if (items.length == 0)
                        TC.addClassName(self.closeButton, "disabled");
                    else
                        TC.removeClassName(self.closeButton, "disabled");
                    self.closeButton.disabled = items.length == 0;
                }
            };
        }
    }
});
