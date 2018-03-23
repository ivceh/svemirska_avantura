 PImage booster1,booster2,booster3,raceShield;
 int raceBoosterX,raceBoosterY,raceTipBoost;
 boolean raceBoostOnScreen,raceBoostActive;//Boost prikazan na ekranu  , boost aktivan
 int raceTimeTilBoodEnds, raceTimePas;
 int raceTimeBoost; //vrijeme za Boost
 int raceKorekcijaBrzineBoost; //koliko treba korigirati brzinu za boost
 boolean raceShieldActive;

 
 
 void raceUcitajBoosters(){
  booster1 = loadImage("raceBoost1.png");    
  booster1.resize(height/10, height/10);
    
  booster2 = loadImage("raceBoost2.png");  
  booster2.resize(height/10, height/10);
  
  booster3 = loadImage("tenkShield.png");
  booster3.resize(height/10, height/10);
  
  raceShield = loadImage("tenkShield.png");
  raceShield.resize(raceShip.width,raceShip.height);
  
 }
 
 
 void raceNoviBoost(){
   raceBoosterX=(int)random(width)+height/20;
   raceBoosterY=0;
   raceTipBoost=(int)random(60)%3; //0=speed, 1=slow, 2=shield
   raceBoostOnScreen=true;
   
 }
 
 void raceCrtajBoost(){
   if(raceBoostOnScreen){
      rectMode(CENTER);
      if(raceTipBoost==0){
        image(booster1,raceBoosterX , raceBoosterY);
      }else if(raceTipBoost==1)
      {
        image(booster2,raceBoosterX , raceBoosterY);
      }else if(raceTipBoost==2)
      {
        image(booster3,raceBoosterX , raceBoosterY);
      }
    }
    rectMode(CORNER);
    raceBoosterY+=raceBrzinaPozadine+raceUbrzanjePozadine;
    if(raceBoosterY>=height){
      raceBoostOnScreen=false;
    }
 }
