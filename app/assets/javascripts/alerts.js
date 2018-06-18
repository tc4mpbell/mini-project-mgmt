function showAlert(text) {
  var existingAlertBox = document.querySelector(".container.boxed.notices");

  if (!existingAlertBox) {
    var alertHtml = `<div class="container boxed notices">
      ${text}
    </div>`;

    document
      .querySelector(".main-content")
      .insertAdjacentHTML("beforebegin", alertHtml);
  } else {
    existingAlertBox.innerHTML = text;
  }
}
