import { Component, OnInit } from '@angular/core';
import {
  Router, ActivatedRoute
} from '@angular/router';


@Component({
  selector: 'app-cert',
  templateUrl: './cert.component.html',
  styleUrls: ['./cert.component.css']
})
export class CertComponent implements OnInit {

  dataResponse :{};
  

  constructor (private router: Router,  private route: ActivatedRoute,) { }

  ngOnInit(): void {
    this.dataResponse = this.route.snapshot.params.data;      

    console.log("RESPONSE IN CERT message: "+this.dataResponse["result"]["message"]);
  
  }

  backtoRegister(){
    this.router.navigate(['/register']);
  }

  generatePDF(){}

}
