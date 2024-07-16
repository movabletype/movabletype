class o{static danger(e){this.write("danger",e)}static warning(e){this.write("warning",e)}static info(e){this.write("info",e)}static async write(e,i){var r;const t=document.querySelector(".mt-mainContent");if(!t){window.alert(i);return}const s=document.createTextNode(i),a=document.createElement("template");a.innerHTML=`
<div class="alert alert-${e} alert-dismissible fade show" role="alert">
  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
    <span aria-hidden="true">&times;</span>
  </button>
</div>
    `;const n=a.content.querySelector("div");n.insertBefore(s,n.firstChild);const l=((r=t.querySelector("#page-title")||t.querySelector(".mt-breadcrumb"))===null||r===void 0?void 0:r.nextElementSibling)||null;t.insertBefore(n,l)}}export{o as Alert};
