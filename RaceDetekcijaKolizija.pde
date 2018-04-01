void raceKolizija(){
  if(raceKolizijaBooster()){
    racePostaviBoost();
  }
  raceKolizijaStar();
  raceKolizijaBoma();  //on se brine za GameOver
  
  raceCheckTimeOfBoost();
}


void raceKolizijaBoma(){
  for(int i=0; i<raceBombY.size();i++)
  { 
     if((raceBombY.get(i)+height/20 >= raceShipY-raceShip.height/2) && (abs(raceBombX.get(i)-raceShipX)<(height/20+raceShip.width/2)))//na dobroj visini && na dobroj sirini
     {
          raceBombX.remove(i);
          raceBombY.remove(i);
          if(!raceShieldActive)
          {//ako ima Shield mu ne oduzima zivot
            raceBrojZivota--;
          }
        if(raceBrojZivota<=0)
        {//cim se spusti na nula sredi da bude Gameover
          raceGameOver=true;
          //očistim ime igrača (jer se u igri možda pritisnulo 'h' za help)
          imeIgraca = "";
          cursor();
        };     
     }
  }
}


void raceKolizijaStar(){
 for(int i=0; i<raceStarY.size();i++)
 { 
   if((raceStarY.get(i)+height/20 >= raceShipY-raceShip.height/2) && (abs(raceStarX.get(i)-raceShipX)<(height/20+raceShip.width/2)))//na dobroj visini && na dobroj sirini
    {
      raceStarX.remove(i);
      raceStarY.remove(i);
      brojBodova+=10;
    }
  }
}


boolean raceKolizijaBooster(){
  if(!raceBoostOnScreen)  //Ako booster nije aktivan sigurno nije kolizija
    return false;
  if((raceBoosterY+height/20 >= raceShipY-raceShip.height/2) && (abs(raceBoosterX-raceShipX)<(height/20+raceShip.width/2)))//na dobroj visini && na dobroj sirini
    return true;

  return false;
}


void raceCheckTimeOfBoost(){
  int raceTimePassed=millis()-raceTimeBoost;
  if(raceTimePassed>5000){  //boost raje 5 secundi Onda vrati na standard---------------------------TODO: ovo prilagoditi
    raceBoostActive=false;
    raceBrzinaPozadine=raceBrzinaPozadineOsnova;
    raceShieldActive=false; 
  }
}


void racePostaviBoost(){
    raceBoostOnScreen=false;
    if (raceTipBoost==0){//speed
      raceBoostActive=true;
      raceBrzinaPozadine+=10;
      raceTimeBoost=millis();
    }
    if (raceTipBoost==1){
      raceBrzinaPozadine=abs(raceBrzinaPozadine-10);
      raceBoostActive=true;      
      raceTimeBoost=millis();
    }
    if (raceTipBoost==2){
      raceShieldActive=true;
      raceBoostActive=true;      
      raceTimeBoost=millis();
    }
}