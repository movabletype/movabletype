<content-field id="content-field-block-{ id }">
  <div class="mt-collapse__container">
    <div class="col-auto"><ss title="{ trans('Move') }" class="mt-icon" href="{ StaticURI }/images/sprite.svg#ic_move"></ss></div>
    <div class="col text-wrap"><ss title="{ trans('ContentField') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_contentstype"></ss>{ label } ({ typeLabel })</div>
    <div class="col-auto">
      <a href="javascript:void(0)" onclick={ deleteField } class="d-inline-block"><ss title="{ trans('Delete') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_trash"></ss></a>
      <a data-toggle="collapse" href="#field-options-{ id }" aria-expanded="{ isShow == 'show' ? 'true' : 'false' }" aria-controls="field-options-{ id }" class="d-inline-block"><ss title="{ trans('Edit') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_collapse"></ss></a>
    </div>
  </div>
  <div data-is={ type } class="collapse mt-collapse__content  { isShow }" id={ 'field-options-' + id } fieldid={ id } options={ this.options } isnew={ isNew }></div>

  <script>
    deleteField(e) {
      item = e.item
      index = this.parent.fields.indexOf(item)
      this.parent.fields.splice(index, 1)
      this.parent.update({
        isEmpty: this.parent.fields.length > 0 ? false : true
      })
      var target = document.getElementsByClassName('mt-draggable__area')[0]
      this.parent.recalcHeight(target)
    }
  </script>
</content-field>
