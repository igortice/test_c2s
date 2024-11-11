export default class Toast {
  static success(message) {
    Swal.fire({
      toast:             true,
      position:          "top-end",
      icon:              "success",
      title:             message,
      showConfirmButton: false,
      timer:             3000,
      timerProgressBar:  true,
    });
  }

  static error(message) {
    Swal.fire({
      toast:             true,
      position:          "top-end",
      icon:              "error",
      title:             message,
      showConfirmButton: false,
      timer:             3000,
      timerProgressBar:  true,
    });
  }

  static warning(message) {
    Swal.fire({
      toast:             true,
      position:          "top-end",
      icon:              "warning",
      title:             message,
      showConfirmButton: false,
      timer:             3000,
      timerProgressBar:  true,
    });
  }

  static info(message) {
    Swal.fire({
      toast:             true,
      position:          "top-end",
      icon:              "info",
      title:             message,
      showConfirmButton: false,
      timer:             3000,
      timerProgressBar:  true,
    });
  }
}
