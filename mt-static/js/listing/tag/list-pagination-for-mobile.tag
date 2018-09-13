<list-pagination-for-mobile>
  <ul class="pagination__mobile d-md-none">
    <li class={
      page-item: true,
      mr-auto: isTooNarrowWidth()
    }>
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

    <li if={ store.page - 4 >= 1 && store.pageMax - store.page < 1 }
      class={
        page-item: true,
        mr-auto: isTooNarrowWidth()
      }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page - 4 }
        onclick={ movePage }
      >
        { store.page - 4 }
      </a>
    </li>

    <li if={ store.page - 3 >= 1 && store.pageMax - store.page < 2 }
      class={
        page-item: true,
        mr-auto: isTooNarrowWidth()
      }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page - 3 }
        onclick={ movePage }
      >
        { store.page - 3 }
      </a>
    </li>

    <li if={ store.page - 2 >= 1 }
      class={
        page-item: true,
        mr-auto: isTooNarrowWidth()
      }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page - 2 }
        onclick={ movePage }
      >
        { store.page - 2 }
      </a>
    </li>

    <li if={ store.page - 1 >= 1 }
      class={
        page-item: true,
        mr-auto: isTooNarrowWidth()
      }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page - 1 }
        onclick={ movePage }
      >
        { store.page - 1 }
      </a>
    </li>

    <li class={
      page-item: true,
      active: true,
      mr-auto: isTooNarrowWidth()
    }>
      <a class="page-link">
        { store.page }
        <span class="sr-only">(current)</span>
      </a>
    </li>

    <li if={ store.page + 1 <= store.pageMax }
      class={
        page-item: true,
        mr-auto: isTooNarrowWidth()
      }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page + 1 }
        onclick={ movePage }
      >
        { store.page + 1 }
      </a>
    </li>

    <li if={ store.page + 2 <= store.pageMax }
      class={
        page-item: true,
        mr-auto: isTooNarrowWidth()
      }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page + 2 }
        onclick={ movePage }
      >
        { store.page + 2 }
      </a>
    </li>

    <li if={ store.page + 3 <= store.pageMax && store.page <= 2 }
      class={
        page-item: true,
        mr-auto: isTooNarrowWidth()
      }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page + 3 }
        onclick={ movePage }
      >
        { store.page + 3 }
      </a>
    </li>

    <li if={ store.page + 4 <= store.pageMax && store.page <= 1 }
      class={
        page-item: true,
        mr-auto: isTooNarrowWidth()
      }
    >
      <a href="javascript:void(0);"
        class="page-link"
        data-page={ store.page + 4 }
        onclick={ movePage }
      >
        { store.page + 4 }
      </a>
    </li>

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
