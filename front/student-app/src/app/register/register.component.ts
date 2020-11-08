
import { Component, OnInit } from '@angular/core';
import { SHA256 } from "crypto-js";
import { HttpClient } from '@angular/common/http';
import { FormGroup, FormControl, Validators} from '@angular/forms';
import {Router, ActivatedRoute} from '@angular/router'


@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  private fileContent: string | ArrayBuffer;
  constructor(private router: Router) { }

  ngOnInit(): void {

  }
  

  myForm = new FormGroup({
    name: new FormControl('', [Validators.required, Validators.minLength(3)]),
    file: new FormControl('', [Validators.required]),
    fileSource: new FormControl('', [Validators.required])
  });
    

      
  get f(){
    return this.myForm.controls;
  }
     
  onFileChange(event) {
  
    /*if (event.target.files.length > 0) {
      const file = event.target.files[0];
      this.myForm.patchValue({
        fileSource: file
      });
    }*/

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


  submit(){
    const formData = new FormData();
    formData.append('file', this.myForm.get('fileSource').value);
    console.log
    console.log("HASH DEL FICHERO: "+this.calculateHash(this.fileContent));
   
    /*this.http.post('http://localhost:8001/upload.php', formData)
      .subscribe(res => {
        console.log(res);
        alert('Uploaded Successfully.');
      })*/
  }

  private calculateHash(fileContent: string | ArrayBuffer) {
    return SHA256(fileContent).toString();
  }
 
  /*private sign(){
    this.router.navigate(['/sign']);
  }*/


}

