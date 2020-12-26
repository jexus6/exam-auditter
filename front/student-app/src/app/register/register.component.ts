
import { Component, OnInit } from '@angular/core';
import { SHA256 } from "crypto-js";
import { FormGroup, FormControl, Validators} from '@angular/forms';
import {RegisterService} from './../register.service';
import {
  Router
} from '@angular/router';
import { Subject } from "rxjs";

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  private fileContent: string | ArrayBuffer;
   data :{}; 
  
  constructor(private registerService: RegisterService, private router: Router) { }
  private documentError = new Subject<boolean>();
  ngOnInit(): void {

  }
 
  myForm = new FormGroup({
    name: new FormControl('', [Validators.required, Validators.minLength(3)]),
    subject: new FormControl('', [Validators.required, Validators.minLength(3)]),
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
    args[0]= this.calculateHash(this.fileContent);
    args[1]= this.myForm.get("name").value;
    args[2]= this.myForm.get("subject").value;
    args[3]= ""+Date.now();
    args[4]= "";
   
     let createResponse = await this.registerService.newExam(args);
     localStorage.setItem('txId',createResponse["result"]["result"]["txId"]);
     this.goCert(createResponse["result"]["result"]["exam"]["hash"]);

  }

    public goCert(hash : string) {
      this.router.navigate(['/cert', {
        id: hash
      }])
    }
  
 
  private calculateHash(fileContent: string | ArrayBuffer) {
    return SHA256(fileContent).toString();
  }

}

