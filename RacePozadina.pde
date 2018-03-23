int raceBrzinaPozadine,raceBrzinaPozadineOsnova;  //osnovna brzina je baza , a brzina sluzi za prikaz.. brzinu mjenjam pomocu bustera a osnovnu koristim da ponistim bustere
int racePolozajPozadine;
int raceTimePozadina;
int raceUbrzanjePozadine; //periodicno se ubrzava igra
PImage racePozadina1, racePozadina2;


void raceUcitajPozadine(){
  //učitam potrebne slike
  racePozadina1 = loadImage("raceBackground1.png");
  racePozadina1.resize(width,height);
  
  racePozadina2 = loadImage("raceBackground2.png");
  racePozadina2.resize(width,height);

  racePolozajPozadine = 4*height/5;
}


void raceCrtajPozadinu(){ 

  racePolozajPozadine+=raceBrzinaPozadine+raceUbrzanjePozadine;
  if (racePolozajPozadine > height/2) 
  {
    racePolozajPozadine = -height/2;
  }
  image(racePozadina1,width/2, racePolozajPozadine);
  image(racePozadina2, width/2, racePolozajPozadine+height);

}
