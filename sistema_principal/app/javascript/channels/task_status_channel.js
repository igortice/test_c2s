import Toast from "../sweetalert/toast";
import consumer from "./consumer";

consumer.subscriptions.create("TaskStatusChannel", {
  connected() {
  },
  received(data) {
    const {task_id, status} = data;
    const taskRow = document.querySelector(`tr[data-task-id='${task_id}']`);
    if (taskRow) {
      const statusCell = taskRow.querySelector(".task-status");

      flip(statusCell, () => {
        statusCell.textContent = capitalize(status);
        statusCell.className   = `task-status badge bg-${getStatusClass(status)}`;

        Toast.info(`Task #${task_id} is ${status.replace(/_/g, " ")}`);
      });
    }
  }
});

const getStatusClass = (status) => {
  const statusClasses = {
    pending:     "warning text-dark",
    in_progress: "primary",
    completed:   "success",
    failed:      "danger"
  };
  return statusClasses[status] || "secondary";
};

const flip = (element, callback) => {
  element.classList.add("flip-out");
  setTimeout(() => {
    if (callback) callback();
    element.classList.replace("flip-out", "flip-in");
    setTimeout(() => element.classList.remove("flip-in"), 500);
  }, 500);
};

const capitalize = (str) => str.charAt(0).toUpperCase() + str.slice(1);
