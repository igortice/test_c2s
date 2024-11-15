window.addEventListener(("turbo:load"), () => {
  // debugger
  document.addEventListener("submit", (event) => {
    // debugger
    if (event.target && event.target.className === "delete-alertbox") {
      event.preventDefault();
      Swal.fire({
        title:              "Are you sure?",
        text:               "You won't be able to revert this!",
        icon:               "warning",
        showCancelButton:   true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor:  "#d33",
        confirmButtonText:  "Yes, delete it!"
      })
        .then((result) => {
          if (result.isConfirmed) {
            document.querySelector(".delete-alertbox").submit();
          }
        })
        .catch(event.preventDefault());
    }
  });
});
