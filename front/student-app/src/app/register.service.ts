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
data : {};
  constructor(
    private http: HttpClient,
    private router: Router,

  ) { }

  newExam( args : string []
  ) {
    const service: string = "/channels/mychannel/chaincodes/exam_auditter";

    const exam_data = {
      "fcn": "createExam",
      "username": "admin",
      "orgName": "Udima",
      "peers": [
        "peer0.udima.example.com",
        "peer0.ministerio.example.com"
      ],
      "chaincodeName": "ExamContract",
      "channelName": "mychannel",
      args
    }

    this.http
      .post<Response>(environment.apiExamAuditer + service, exam_data)
      .subscribe(
        responseData => {
          let data2 : {} ;
         data2 = responseData;
     
          console.log("RESPONSE message: "+data2["result"]["message"]);
          console.log("RESPONSE DATA: "+JSON.stringify(responseData));
         //this.openDialog(responseData.data);
         return responseData;
        },
        error => {
          return this.documentError.next(false);
        }
      );
  }

  getExam(hashExam : string 
    ) {
      const service: string = "/channels/mychannel/chaincodes/exam_auditter";
       this.http
        .get<Response>(environment.apiExamAuditer + service+"?args=[\""+hashExam+"\"]&peer=peer0.udima.example.com&fcn=getExam&username=admin&orgName=Udima")
        .subscribe(
          responseData => {
            this.data = responseData;
            console.log("RESPONSE DATA: ", JSON.stringify(responseData));
            
           return this.data;
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
