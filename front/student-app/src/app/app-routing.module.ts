import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { RegisterComponent } from './register/register.component';
import { CheckComponent } from './check/check.component';
import { CertComponent } from './cert/cert.component';
import { ErrorComponent } from './error/error.component';
import {CheckOkComponent} from './check-ok/check-ok.component';
import {CheckKoComponent} from './check-ko/check-ko.component';

const routes: Routes = [
  {path: '', redirectTo: '/register', pathMatch: 'full'},
  {path: 'cert', component: CertComponent},
  {path: 'register', component: RegisterComponent},
  {path: 'check', component: CheckComponent},
  {path: 'error', component: ErrorComponent},
  {path: 'ok', component: CheckOkComponent},
  {path: 'ko', component: CheckKoComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
