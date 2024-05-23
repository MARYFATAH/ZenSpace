import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['content', 'info']

  connect() {
    console.log("CONNECTED")
  }

  buttonClick() {
    this.contentTarget.classList.toggle("d-none")
  }

  infoClick() {
    console.log(this.infoTarget.classList)
    this.infoTarget.classList.toggle("d-none")
  }

  showMoreClick() {
    this.infoTarget.classList.toggle("d-none")
  }
}
