<content-field id="content-field-block-{ id }">
  <div class="mt-collapse__container">
    <div class="col-auto"><ss title="{ trans('Move') }" class="mt-icon" href="{ StaticURI }/images/sprite.svg#ic_move"></ss></div>
    <div class="col text-wrap"><ss title="{ trans('ContentField') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_contentstype"></ss>{ label } ({ typeLabel }) <span if="{ realId }">(ID: { realId })</span></div>
    <div class="col-auto">
      <a href="javascript:void(0)" onclick={ duplicateField } class="d-inline-block duplicate-content-field"><ss title="{ trans('Duplicate') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_duplicate"></ss></a>
      <a href="javascript:void(0)" onclick={ deleteField } class="d-inline-block delete-content-field"><ss title="{ trans('Delete') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_trash"></ss></a>
      <a data-toggle="collapse" href="#field-options-{ id }" aria-expanded="{ isShow == 'show' ? 'true' : 'false' }" aria-controls="field-options-{ id }" class="d-inline-block"><ss title="{ trans('Edit') }" class="mt-icon--secondary" href="{ StaticURI }images/sprite.svg#ic_collapse"></ss></a>
    </div>
  </div>
  <div data-is={ type } class="collapse mt-collapse__content  { isShow }" id={ 'field-options-' + id } fieldid={ id } options={ this.options } isnew={ isNew }></div>

  <script>
    deleteField(e) {
      item = e.item
      var label = item.label ? item.label : trans('No Name');
      if( !confirm( trans('Do you want to delete [_1]([_2])?', label, item.typeLabel) ) ){
        return;
      }
      index = this.parent.fields.indexOf(item)
      this.parent.fields.splice(index, 1)
      this.parent.update({
        isEmpty: this.parent.fields.length > 0 ? false : true
      })
      var target = document.getElementsByClassName('mt-draggable__area')[0]
      this.parent.recalcHeight(target)
    }
    duplicateField(e) {
      var index = this.parent.fields.indexOf(e.item)
      var newItem = jQuery.extend({},this.parent.fields[index])
      var field = this.parent.tags['content-field'][index].tags[newItem.type]
      var options = field.gatheringData()
      newItem.options = options
      newItem.id = Math.random().toString(36).slice(-8)
      var label = e.item.label
      if ( !label ) {
        label = jQuery('#content-field-block-' + e.item.id).find('[name="label"]').val()
        if (label == '') {
          label = trans('No Name')
        }
      }
      newItem.label = trans('Duplicate') + '-' + label
      newItem.options.label = newItem.label
      newItem.order = this.parent.fields.length+1
      newItem.isNew = true
      newItem.isShow = 'show'
      this.parent.fields.push(newItem)
      var target = document.getElementsByClassName('mt-draggable__area')[0]
      this.parent.recalcHeight(target)
      this.parent.update()
    }
  </script>
</content-field>
