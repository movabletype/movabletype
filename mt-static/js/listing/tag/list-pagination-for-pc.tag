<list-pagination-for-pc>
  <ul class="pagination d-none d-md-flex">
    <li class="page-item">
      <a href="javascript:void(0);"
        class="page-link"
        disabled={ store.page <= 1 }
        data-page={ store.page - 1 }
        onclick={ movePage }
      >
        { trans('Previous') }
      </a>
    </li>

  <virtual if={ store.page - 2 >= 1 }>
    <li class="page-item first-last">
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ 1 }
        onclick={ movePage }
      >
        1
      </a>
    </li>
  </virtual>

  <virtual if={ store.page - 3 >= 1 }>
    <li class="page-item" aria-hidden="true">
      ...
    </li>
  </virtual>

    <li if={ store.page - 1 >= 1 }
      class={ 'page-item': true, 'first-last': store.page - 1 == 1 }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page - 1 }
        onclick={ movePage }
      >
        { store.page - 1 }
      </a>
    </li>

    <li class="page-item active">
      <a class="page-link">
        { store.page }
        <span class="sr-only">(current)</span>
      </a>
    </li>

    <li if={ store.page + 1 <= store.pageMax }
      class={ 'page-item': true, 'first-last': store.page + 1 == store.pageMax }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page + 1 }
        onclick={ movePage }
      >
        { store.page + 1 }
      </a>
    </li>

  <virtual if={ store.page + 3 <= store.pageMax }>
    <li class="page-item" aria-hidden="true">
      ...
    </li>
  </virtual>

  <virtual if={ store.page + 2 <= store.pageMax }>
    <li class="page-item first-last">
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.pageMax }
        onclick={ movePage }
      >
        { store.pageMax }
      </a>
    </li>
  </virtual>

    <li class="page-item">
      <a href="javascript:void(0);"
        class="page-link"
        disabled={ store.page >= store.pageMax }
        data-page={ store.page + 1 }
        onclick={ movePage }
      >
        { trans('Next') }
      </a>
    </li>
  </ul>

  <script>
    this.mixin('listTop')
    this.mixin('listPagination')
  </script>
</list-pagination-for-pc>
