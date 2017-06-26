<list-pagination>
  <ul class="list-inline">
    <li>
      <button class="btn btn-default"
        disabled={ opts.store.page <= 1 }
        data-page={ opts.store.page - 1 }
        onclick={ movePage }
      >
        &lt; { trans('Prev') }
      </button>
    </li>
    <li>
      <virtual if={ opts.store.page - 3 >= 1 }>
        <a href="javascript:void(0);"
          data-page={ 1 }
          onclick={ movePage }
        >
          <span class="label label-default">
            1
          </span>
        </a>
        ...
      </virtual>

      <virtual if={ opts.store.page - 2 >= 1 }>
        <a href="javascript:void(0);"
          data-page={ opts.store.page - 2 }
          onclick={ movePage }
        >
          { opts.store.page - 2 }
        </a>
      </virtual>

      <virtual if={ opts.store.page - 1 >= 1 }>
        <a href="javascript:void(0);"
          data-page={ opts.store.page - 1 }
          onclick={ movePage }
        >
          { opts.store.page - 1 }
        </a>
      </virtual>

      <span class="label label-primary">{ opts.store.page }</span>

      <virtual if={ opts.store.page + 1 <= opts.store.pageMax }>
        <a href="javascript:void(0);"
          data-page={ opts.store.page + 1 }
          onclick={ movePage }
        >
          { opts.store.page + 1 }
        </a>
      </virtual>

      <virtual if={ opts.store.page + 2 <= opts.store.pageMax }>
        <a href="javascript:void(0);"
          data-page={ opts.store.page + 2 }
          onclick={ movePage }
        >
          { opts.store.page + 2 }
        </a>
      </virtual>

      <virtual if={ opts.store.page + 3 <= opts.store.pageMax }>
        ...
        <a href="javascript:void(0);"
          data-page={ opts.store.pageMax }
          onclick={ movePage }
        >
          <span class="label label-default">
            { opts.store.pageMax }
          </span>
        </a>
      </virtual>
    </li>
    <li>
      [ <input type="number"
          min="1"
          max={ opts.store.pageMax }
          value={ opts.store.page }
          class="text-center"
          style="width: 50px;"
          onkeyup={ movePage } /> / { opts.store.pageMax } ]
    </li>
    <li>
      <button class="btn btn-default"
        disabled={ opts.store.page >= opts.store.pageMax }
        data-page={ opts.store.page + 1 }
        onclick={ movePage }
      >
        { trans('Next') } &gt;
      </button>
    </li>
  </ul>

  <script>
    movePage(e) {
      let nextPage
      if (e.target.tagName == "INPUT") {
        if (e.which != 13) {
          return false
        }
        nextPage = Number(e.target.value)
      } else {
        nextPage = Number(e.currentTarget.dataset.page)
      }
      if (!nextPage) {
        return false
      }
      opts.store.trigger('move_page', nextPage)
    }
  </script>
</list-pagination>
