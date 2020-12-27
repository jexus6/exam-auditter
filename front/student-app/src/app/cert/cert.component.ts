import { Expansion } from '@angular/compiler';
import { Component, OnInit } from '@angular/core';
import {
  Router, ActivatedRoute
} from '@angular/router';
import { Exam } from '../exam-model';
import {RegisterService} from './../register.service';

import html2canvas from 'html2canvas';
import {
  jsPDF
} from 'jspdf';


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

  generatePDF(){
    var data = document.getElementById('contAll'); //Id of the table
    html2canvas(data).then(canvas => {
      // Few necessary setting options  
      let imgWidth = 208;
      let pageHeight = 294;
      let imgHeight = canvas.height * imgWidth / canvas.width;
      let heightLeft = imgHeight;

      const contentDataURL = canvas.toDataURL('image/png')
      let pdf = new jsPDF('p', 'mm', 'a4'); // A4 size page of PDF  
      let position = 5;
      pdf.addImage(contentDataURL, 'PNG', 0, position, imgWidth, imgHeight);

      heightLeft -= pageHeight;

      while (heightLeft >= 0) {
        position += heightLeft - imgHeight; // top padding for other pages
        pdf.addPage();
        pdf.addImage(contentDataURL, 'PNG', 0, position, imgWidth, imgHeight);
        heightLeft -= pageHeight;
      }

      pdf.save('certificado_registro_blockchain_examen_' +  this.exam_data.name + '.pdf'); // Generated PDF   
    });

  }

}
