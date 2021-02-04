import { Component } from '@angular/core';
import { faPlus, faCheckCircle } from '@fortawesome/free-solid-svg-icons';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'Registro de exámenes en Blockchain';
  faPlus = faPlus;
  faCheckCircle  = faCheckCircle;
}
