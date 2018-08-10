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

    <virtual data-is="list-pagination-common"></virtual>

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
