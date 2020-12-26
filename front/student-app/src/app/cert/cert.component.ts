import { Expansion } from '@angular/compiler';
import { Component, OnInit } from '@angular/core';
import {
  Router, ActivatedRoute
} from '@angular/router';
import { Exam } from '../exam-model';
import {RegisterService} from './../register.service';


@Component({
  selector: 'app-cert',
  templateUrl: './cert.component.html',
  styleUrls: ['./cert.component.css']
})
export class CertComponent implements OnInit {

  hash : string;
  response_data : {};
  exam_data : Exam;


  constructor (private registerService: RegisterService, private router: Router,  private route: ActivatedRoute,) { }

   async ngOnInit(): Promise<void>  {
    this.hash = this.route.snapshot.params.id;  
    
    console.log("hash INit: ", this.hash );
    

    this.exam_data = new Exam();
    this.exam_data.name="";
    console.log("Local Storage", localStorage.getItem('txId'))
   
    this.response_data =  await  this.registerService.getExam(this.hash);
    this.exam_data = this.response_data["result"];
    this.exam_data.txId = localStorage.getItem('txId');
    
    console.log("exam_data: ",  JSON.stringify(this.exam_data));    


  }

  backtoRegister(){
    this.router.navigate(['/register']);
  }

  generatePDF(){}

}
