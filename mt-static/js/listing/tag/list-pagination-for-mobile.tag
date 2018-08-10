<list-pagination-for-mobile>
  <ul class="pagination__mobile d-md-none">
    <li class="page-item">
      <a href="javascript:void(0);"
        class="page-link"
        disabled={ store.page <= 1 }
        data-page={ store.page - 1 }
        onclick={ movePage }
      >
        <ss title="{ trans('Previous') }"
          class="mt-icon--inverse mt-icon--sm"
          href="{ StaticURI + 'images/sprite.svg#ic_tri-left' }"
        >
        </ss>
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
        <ss title="{ trans('Next') }"
          class="mt-icon--inverse mt-icon--sm"
          href="{ StaticURI + 'images/sprite.svg#ic_tri-right' }"
        >
        </ss>
      </a>
    </li>
  </ul>

  <script>
    this.mixin('listTop')
    this.mixin('listPagination')
  </script>
</list-pagination-for-mobile>