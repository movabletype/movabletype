var select_conflict;

function hideNav(el) {
    el.getElementsByTagName('UL')[0].style.left='-999em';
    if (select_conflict) document.getElementById(select_conflict).style.visibility='visible';
}
function showNav(el) {
    el.getElementsByTagName('UL')[0].style.left='auto';
    if (select_conflict) document.getElementById(select_conflict).style.visibility='hidden';
}
