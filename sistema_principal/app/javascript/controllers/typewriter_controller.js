import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        this.typeText(this.element, this.element.textContent, 0);
    }

    typeText(element, text, index) {
        if (index < text.length) {
            element.textContent = text.substring(0, index + 1);
            setTimeout(() => this.typeText(element, text, index + 1), 50); // Ajuste o intervalo conforme necessário
        }
    }
}
