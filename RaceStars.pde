
 PImage raceStar;
 IntList raceStarX = new IntList(),raceStarY = new IntList();//pozicije zvijezda
 int raceTimeStar;
 
  void raceEmptyStar(){
   raceStarX.clear();
   raceStarY.clear();
 }
 
 void raceUcitaStar(){ 
  raceStar = loadImage("raceStar.png");    
  raceStar.resize(height/10, height/10);
 }
 
 
 void raceNoviStar(){
   raceStarX.append((int)random(width)+height/20);
   raceStarY.append(0);
 }
 
 
 void raceCrtajStar(){
   for(int i=0; i<raceStarY.size();i++)
   {
    rectMode(CENTER);
    image(raceStar,raceStarX.get(i) , raceStarY.get(i));
    raceStarY.add(i,raceBrzinaPozadine+raceUbrzanjePozadine);
    if(raceStarY.get(i)>=height){
      raceStarX.remove(i);
      raceStarY.remove(i);
    }
   }
   rectMode(CORNER);
 }