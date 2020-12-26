import { Injectable } from '@angular/core';
import { environment } from "../environments/environment";
import { Subject } from "rxjs";
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Router } from "@angular/router";

import { Response } from "./response-model";
import { newArray } from '@angular/compiler/src/util';
import { analyzeAndValidateNgModules } from '@angular/compiler';


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

  async newExam( args : string []
  ) : Promise<any> {
    
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

   return await this.http
      .post<Response>(environment.apiExamAuditer + service, exam_data).toPromise();
     
  }

  async getExam(hashExam : string 
    ): Promise<any> {
      const service: string = "/channels/mychannel/chaincodes/exam_auditter";
      return await this.http
        .get<Response>(environment.apiExamAuditer + service+"?args=[\""+hashExam+"\"]&peer=peer0.udima.example.com&fcn=getExam&username=admin&orgName=Udima").toPromise();
      
    }
 
}
