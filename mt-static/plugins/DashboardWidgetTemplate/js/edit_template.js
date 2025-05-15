if (document.querySelector(`[name="type"][value="dashboard_widget"]`)) {
  document.querySelector(`[name="name"]`).remove();
  const nameInput = document.querySelector(`[name="name_display"]`);
  nameInput.name = "name";
  nameInput.disabled = false;

  document
    .querySelectorAll(`#useful-links a[href$="#system"], .plugin-actions`)
    .forEach((el) => el.classList.add("d-none"));
}
