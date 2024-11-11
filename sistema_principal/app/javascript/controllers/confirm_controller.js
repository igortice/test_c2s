import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static values = {confirmMessage: String}

    confirm(event) {
        const message = this.hasConfirmMessageValue ? this.confirmMessageValue : "Tem certeza?";
        if (!window.confirm(message)) {
            event.preventDefault();
        }
    }
}
