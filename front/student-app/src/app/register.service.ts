import { Injectable } from '@angular/core';
import { environment } from "../environments/environment";
import { Subject } from "rxjs";
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Router } from "@angular/router";

import { Response } from "./response-model";


@Injectable({
  providedIn: 'root'
})
export class RegisterService {
  private documentError = new Subject<boolean>();

  constructor(
    private http: HttpClient,
    private router: Router,

  ) { }

  newExam(
    hashFile: string,
    curse: string,
    subject: string,
    owner: string
  ) {
    const service: string = "/register";
  
    const examData = new FormData();
    examData.append("hashFile", hashFile);
    examData.append("curse", curse);
    examData.append("subject", subject);
    examData.append("owner", owner);

    this.http
      .post<Response>(environment.apiExamAuditer + service, examData)
      .subscribe(
        responseData => {
          console.log("RESPONSE DATA: ", responseData);
          this.openDialog(responseData.data);         
        },
        error => {
          return this.documentError.next(false);
        }
      );
  }

  private openDialog(data: any): void {
    console.log(data);
  
  }


}
