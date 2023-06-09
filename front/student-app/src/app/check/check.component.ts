import { Component, OnInit } from '@angular/core';
import {RegisterService} from './../register.service';
import { SHA256 } from "crypto-js";
import { FormGroup, FormControl, Validators} from '@angular/forms';
import {
  Router
} from '@angular/router';

@Component({
  selector: 'app-check',
  templateUrl: './check.component.html',
  styleUrls: ['./check.component.css']
})
export class CheckComponent implements OnInit {
  private fileContent: string | ArrayBuffer;
  constructor (private router: Router,private registerService: RegisterService) { }

  ngOnInit(): void {
  }

  myForm = new FormGroup({
    file: new FormControl('', [Validators.required]),
    fileSource: new FormControl('', [Validators.required])
  });
     
  get f(){
    return this.myForm.controls;
  }
     
  onFileChange(event) {
  
   const file = (event.target as HTMLInputElement).files[0];
    if (!file) {
      return;
    }
    var reader = new FileReader();
    reader.onload = () => {
      this.fileContent = reader.result;
    };
    reader.readAsBinaryString(file);
  }

  
  async submit(){
    let args: string[] = new Array(5);
    const formData = new FormData();
    formData.append('file', this.myForm.get('fileSource').value);
    
    console.log("HASH DEL FICHERO: "+this.calculateHash(this.fileContent));
    
    const createResponse = await this.registerService.getExam(this.calculateHash(this.fileContent));
    console.log("debug: "+JSON.stringify(createResponse));
    if ((typeof createResponse["result"] === 'string' || createResponse["result"] instanceof String )&& createResponse["result"].indexOf("error")!=-1){
      this.router.navigate(['/ko', {
        id: ''
      }]);
    }else{
    
      localStorage.setItem('recordTime', createResponse["result"]["timeStamp"]);
     
      this.router.navigate(['/ok', {
        id: createResponse["result"]["name"]
      }]);
    }

    
    

  }

  


  private calculateHash(fileContent: string | ArrayBuffer) {
    return SHA256(fileContent).toString();
  }

}
