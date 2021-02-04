import { Component, OnInit } from '@angular/core';
import {
   ActivatedRoute
} from '@angular/router';

@Component({
  selector: 'app-check-ok',
  templateUrl: './check-ok.component.html',
  styleUrls: ['./check-ok.component.css']
})
export class CheckOkComponent implements OnInit {

  name: string;
  time:string;
  constructor(private route: ActivatedRoute) { }

  ngOnInit(): void {

    this.name = this.route.snapshot.params.id;  
    this.time =  localStorage.getItem('recordTime');
    console.log("Record time", localStorage.getItem('recordTime'))
  }

}
