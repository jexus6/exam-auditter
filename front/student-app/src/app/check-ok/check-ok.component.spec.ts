import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CheckOkComponent } from './check-ok.component';

describe('CheckOkComponent', () => {
  let component: CheckOkComponent;
  let fixture: ComponentFixture<CheckOkComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CheckOkComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CheckOkComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
