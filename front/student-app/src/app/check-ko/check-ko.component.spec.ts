import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CheckKoComponent } from './check-ko.component';

describe('CheckKoComponent', () => {
  let component: CheckKoComponent;
  let fixture: ComponentFixture<CheckKoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CheckKoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CheckKoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
