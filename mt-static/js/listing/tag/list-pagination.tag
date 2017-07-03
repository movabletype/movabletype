<list-pagination>
  <ul class="list-inline">
    <li>
      <button class="btn btn-default"
        disabled={ store.page <= 1 }
        data-page={ store.page - 1 }
        onclick={ movePage }
      >
        &lt; { trans('Prev') }
      </button>
    </li>
    <li>
      <virtual if={ store.page - 3 >= 1 }>
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

      <virtual if={ store.page - 2 >= 1 }>
        <a href="javascript:void(0);"
          data-page={ store.page - 2 }
          onclick={ movePage }
        >
          { store.page - 2 }
        </a>
      </virtual>

      <virtual if={ store.page - 1 >= 1 }>
        <a href="javascript:void(0);"
          data-page={ store.page - 1 }
          onclick={ movePage }
        >
          { store.page - 1 }
        </a>
      </virtual>

      <span class="label label-primary">{ store.page }</span>

      <virtual if={ store.page + 1 <= store.pageMax }>
        <a href="javascript:void(0);"
          data-page={ store.page + 1 }
          onclick={ movePage }
        >
          { store.page + 1 }
        </a>
      </virtual>

      <virtual if={ store.page + 2 <= store.pageMax }>
        <a href="javascript:void(0);"
          data-page={ store.page + 2 }
          onclick={ movePage }
        >
          { store.page + 2 }
        </a>
      </virtual>

      <virtual if={ store.page + 3 <= store.pageMax }>
        ...
        <a href="javascript:void(0);"
          data-page={ store.pageMax }
          onclick={ movePage }
        >
          <span class="label label-default">
            { store.pageMax }
          </span>
        </a>
      </virtual>
    </li>
    <li>
      [ <input type="number"
          min="1"
          max={ store.pageMax }
          value={ store.page }
          class="text-center"
          style="width: 50px;"
          onkeyup={ movePage } /> / { store.pageMax } ]
    </li>
    <li>
      <button class="btn btn-default"
        disabled={ store.page >= store.pageMax }
        data-page={ store.page + 1 }
        onclick={ movePage }
      >
        { trans('Next') } &gt;
      </button>
    </li>
  </ul>

  <script>
    this.mixin('listTop')

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
      this.store.trigger('move_page', nextPage)
    }
  </script>
</list-pagination>
