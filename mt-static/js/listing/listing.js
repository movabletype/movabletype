riot.tag2('display-options', '<div class="row"> <div class="col-md-12"> <a href="#" class="btn btn-default pull-right" data-toggle="collapse" data-target="#display-options-detail"> {trans(\'Display Options\')} <span class="caret"></span> </a> </div> </div> <div class="row"> <div data-is="display-options-detail" class="col-md-12" limit="{opts.limit}"></div> </div>', '', '', function(opts) {
});

riot.tag2('display-options-detail', '<div id="display-options-detail" class="collapse panel panel-default"> <div class="panel-body"> <div id="per_page-field"> <div class="field-header"> <label>{trans(\'Show\')}</label> </div> <div class="field-content"> <select id="row" class="form-control" name="limit" style="width: 100px;"> <option value="25" selected="{opts.limit == 25}">{trans(\'25 rows\')}</option> <option value="50" selected="{opts.limit == 50}">{trans(\'50 rows\')}</option> <option value="100" selected="{opts.limit == 100}">{trans(\'100 rows\')}</option> <option value="200" selected="{opts.limit == 200}">{trans(\'200 rows\')}</option> </select> </div> </div> <div class="actions-bar actions-bar-bottom"> <a href="#" id="reset-display-options">{trans(\'Reset defaults\')}</a> </div> </div> </div>', '', '', function(opts) {
});


riot.tag2('list-table', '<thead data-is="list-table-header" columns="{columns}"></thead> <tfoot data-is="list-table-header" columns="{columns}"></tfoot> <tbody data-is="list-table-body" columns="{columns}" objects="{objects}"></tbody>', '', '', function(opts) {
    this.columns = opts.columns;
    this.objects = [];

    this.on('mount', function () {

      console.log('mount');
    });

    this.on('update', function () {
      console.log('update');
    });
});

riot.tag2('list-table-header', '<tr> <th></th> <th each="{column in opts.columns}">{column}</th> </tr>', '', '', function(opts) {
});

riot.tag2('list-table-body', '<tr if="{opts.objects.length == 0}"> <td colspan="{opts.columns.length + 1}">No data could be found.</td> </tr> <tr data-is="list-table-row" each="{object in opts.objects}" object="{object}"></tr>', '', '', function(opts) {
});

riot.tag2('list-table-row', '<td><input type="checkbox" name="id" riot-value="{id}"></td> <td each="{column in opts.object}">{column}</td>', '', '', function(opts) {
    this.id = opts.object[0];
});


riot.tag2('list-top', '<div data-is="display-options"></div> <yield></yield> <div class="row"> <div class="col-md-12"> <table data-is="list-table" id="listing" class="table table-striped table-hover" columns="{columns}"> </table> </div> </div>', '', '', function(opts) {
    this.listClient = opts.listClient

    this.columns = opts.columns
    this.limit = opts.limit || 50
    this.page = opts.page || 1
    this.sortBy = opts.sortBy
    this.sortOrder = opts.sortOrder || 'ascend'
    this.fid = opts.fid || '_allpass'

    this.objects = []
    this.count = 0
    this.editableCount = 0
    this.pageMax = 0
    this.filters = []

    this.on('mount', () => {
      this.render()
    })

    this.render = function(e) {
      const self = this
      this.listClient.sendRequest({
        columns: this.columns,
        limit: this.limit,
        page: this.page,
        sortBy: this.sortBy,
        sortOrder: this.sortOrder,
        fid: this.fid,
        success: (data, textStatus, jqXHR) => {
          if (data && !data.error) {
            self.setData(data.result)
          }
        },
        fail: (jsXHR, textStatus) => {
          self.resetData()
        },
        always: () => {
          self.update()
        }
      })
    }.bind(this)

    this.setData = function(result) {
      this.columns = result.columns.split(',')

      this.objects = result.objects
      this.count = result.count
      this.editableCount = result.editable_count
      this.pageMax = result.page_max
      this.filters = result.filters
    }.bind(this)

    this.resetData = function() {
      this.objects = []
      this.count = 0
      this.editableCount = 0
      this.pageMax = 0
      this.filters = []
    }.bind(this)
});

