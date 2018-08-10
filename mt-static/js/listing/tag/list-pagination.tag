<list-pagination>
  <div class="col-auto mx-auto">
    <nav aria-label={ store.listClient.objectType + ' list' }>
      <virtual data-is="list-pagination-for-pc"></virtual>
      <virtual data-is="list-pagination-for-mobile"></virtual>
    </nav>
  <div>

  <script>
    this.mixin('listTop')

    riot.mixin('listPagination', {
      movePage: function (e) {
        if (e.currentTarget.disabled) {
            return false
        }

        var nextPage
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
        var moveToPagination = true
        this.store.trigger('move_page', nextPage, moveToPagination)
        return false
      }
    })
  </script>
</list-pagination>
