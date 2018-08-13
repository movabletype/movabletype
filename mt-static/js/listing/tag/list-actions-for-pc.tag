<list-actions-for-pc>
  <button each={ action, key in listTop.opts.buttonActions }
    class="btn btn-default mr-2"
    data-action-id={ key }
    onclick={ doAction }
  >
    { action.label }
  </button>
  <div if={ listTop.opts.hasPulldownActions }
    class="btn-group"
  >
    <button class="btn btn-default dropdown-toggle"
      data-toggle="dropdown"
    >
      { trans('More actions...') }
    </button>
    <div class="dropdown-menu">
      <a each={ action, key in listTop.opts.listActions }
        class="dropdown-item"
        href="javascript:void(0);"
        data-action-id={ key }
        onclick={ doAction }
      >
        { action.label }
      </a>
      <h6 if={ Object.keys(listTop.opts.moreListActions).length > 0 }
        class="dropdown-header"
      >
        { trans('Plugin Actions') }
      </h6>
      <a each={ action, key in listTop.opts.moreListActions }
        class="dropdown-item"
        href="javascript:void(0);"
        data-action-id={ key }
        onclick={ doAction }
      >
        { action.label }
      </a>
    </div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('listActions')
  </script>
</list-actions-for-pc>
