 PImage raceBomb;
 IntList raceBombX = new IntList(),raceBombY = new IntList();//pozicije bombi
 int raceTimeBomb;
 
 void raceEmptyBomb(){
   raceBombX.clear();
   raceBombY.clear();
 }
 
 void raceUcitaBomb(){ 
  raceBomb = loadImage("fireBall.png");    
  raceBomb.resize(height/10, height/10);
 }
 
 
 void raceNoviBomb(){
   raceBombX.append((int)random(width)+height/20);
   raceBombY.append(0);
 }
 
 
 void raceCrtajBomb(){
   for(int i=0; i<raceBombY.size();i++)
   {
    rectMode(CENTER);
    image(raceBomb,raceBombX.get(i) , raceBombY.get(i));
    raceBombY.add(i,raceBrzinaPozadine+raceUbrzanjePozadine);
    if(raceBombY.get(i)>=height){
      raceBombX.remove(i);
      raceBombY.remove(i);
    }
   }
   rectMode(CORNER);
 }
