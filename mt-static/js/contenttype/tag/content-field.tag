<content-field>
  <div class="mt-draggable mb-2" draggable="true" aria-grabbed="false" id="content-field-block-{ id }">
    <div class="col">
      <svg title="{ trans('ContentField') }" role="img" class="mt-icon--secondary"><use xlink:href="{ StaticURI }images/sprite.svg#ic_contentstype" /></svg>{ label }
    </div>
    <div class="col-auto">
      <svg title="{ trans('Edit') }" role="img" class="mt-icon"><use xlink:href="{ StaticURI }images/sprite.svg#ic_edit" /></svg><a data-toggle="collapse" href="#field-options-{ id }" aria-expanded="false" aria-controls="field-options-{ id }">{ trans('Setting') }</a>
    </div>
    <div class="col-auto">
      <svg title="{ trans('Delete') }" role="img" class="mt-icon"><use xlink:href="{ StaticURI }images/sprite.svg#ic_trash" /></svg>{ trans('Delete') }
    </div>
    <div class="col-auto">
      <svg title="{ trans('Move') }" role="img" class="mt-icon"><use xlink:href="{ StaticURI }/images/sprite.svg#ic_move" /></svg>
    </div>
  </div>
  <div data-is={ type } id="field-options-{ id }" class="collapse {isShow}"></div>
</content-field>
