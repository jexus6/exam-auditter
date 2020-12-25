import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { RegisterComponent } from './register/register.component';
import { CheckComponent } from './check/check.component';
import { CertComponent } from './cert/cert.component';


const routes: Routes = [
  {path: '', redirectTo: '/register', pathMatch: 'full'},
  {path: 'cert', component: CertComponent},
  {path: 'register', component: RegisterComponent},
  {path: 'check', component: CheckComponent}

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
