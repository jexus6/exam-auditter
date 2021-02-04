import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { RegisterComponent } from './register/register.component';
import { CheckComponent } from './check/check.component';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { HttpClientModule } from '@angular/common/http';


import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CertComponent } from './cert/cert.component';
import { ErrorComponent } from './error/error.component';
import { CheckOkComponent } from './check-ok/check-ok.component';
import { CheckKoComponent } from './check-ko/check-ko.component';

@NgModule({
  declarations: [
    AppComponent,
    RegisterComponent,
    CheckComponent,
    CertComponent,
    ErrorComponent,
    CheckOkComponent,
    CheckKoComponent
  ],
  imports: [
    BrowserModule,
    FontAwesomeModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
     HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
