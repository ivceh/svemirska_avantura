void raceKolizija(){

  raceKolizijaSBrodom(1);  //sudar s meteorom  //on se brine za GameOver
  raceKolizijaSBrodom(2);  //sudar sa zvijezdom
  raceKolizijaSBrodom(3);  //sudar s boosterom
  
  raceCheckTimeOfBoost();
}

void raceKolizijaSBrodom(int objekt) //1=bomba, 2=zvjezda, 3=boost
{
  //kolizija s bombom
  if(objekt==1){
    for (int i=0; i<raceBombY.size(); ++i) //za svaku bombu na ekranu provjeri
    {
    
      if ( raceDetekcijaPreklapanja(new float[]{49, 124, 121, 58, 171, 39, 294, 38, 325, 48, 378, 84, 389, 109, 389, 201, 96, 201}, //tijelo broda igrača
         462, 247, objekt, i) == true
        || raceDetekcijaPreklapanja(new float[]{106, 201, 375, 201, 375, 215, 366, 233, 350, 247, 132, 246, 116, 235, 106, 215}, //top broda igrača
         462, 247, objekt, i) == true
        || raceDetekcijaPreklapanja(new float[]{389, 109, 461, 162, 461, 176, 389, 201}, //kljun broda igrača
         462, 247, objekt, i) == true
        || raceDetekcijaPreklapanja(new float[]{47, 25, 94, 25, 138, 51, 63, 104}, //rep broda igrača
         462, 247, objekt, i) == true
        || raceDetekcijaPreklapanja(new float[]{16, 0, 96, 0, 102, 3, 106, 8, 106, 16, 102, 21, 97, 24, 15, 24, 9, 21, 5, 16, 5, 9, 9, 4}, //zakrilce broda igrača
         462, 247, objekt, i) == true)
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
  //kolizija sa zvijezdom
  else if (objekt==2)
  {
     for(int i=0; i<raceStarY.size();i++)
     {
       if ( raceDetekcijaPreklapanja(new float[]{49, 124, 121, 58, 171, 39, 294, 38, 325, 48, 378, 84, 389, 109, 389, 201, 96, 201}, //tijelo broda igrača
           462, 247, objekt, i) == true
          || raceDetekcijaPreklapanja(new float[]{106, 201, 375, 201, 375, 215, 366, 233, 350, 247, 132, 246, 116, 235, 106, 215}, //top broda igrača
           462, 247, objekt, i) == true
          || raceDetekcijaPreklapanja(new float[]{389, 109, 461, 162, 461, 176, 389, 201}, //kljun broda igrača
           462, 247, objekt, i) == true
          || raceDetekcijaPreklapanja(new float[]{47, 25, 94, 25, 138, 51, 63, 104}, //rep broda igrača
           462, 247, objekt, i) == true
          || raceDetekcijaPreklapanja(new float[]{16, 0, 96, 0, 102, 3, 106, 8, 106, 16, 102, 21, 97, 24, 15, 24, 9, 21, 5, 16, 5, 9, 9, 4}, //zakrilce broda igrača
           462, 247, objekt, i) == true)
        {
          raceStarX.remove(i);
          raceStarY.remove(i);
          brojBodova+=10;
        }
     }
  }
  //kolizija sa boosterom
  else if (objekt==3 && raceBoostOnScreen )//ako postoji na ekranu boost --ako ne,netreba trosit vrijeme
  {
      if ( raceDetekcijaPreklapanja(new float[]{49, 124, 121, 58, 171, 39, 294, 38, 325, 48, 378, 84, 389, 109, 389, 201, 96, 201}, //tijelo broda igrača
           462, 247, objekt, 0) == true
          || raceDetekcijaPreklapanja(new float[]{106, 201, 375, 201, 375, 215, 366, 233, 350, 247, 132, 246, 116, 235, 106, 215}, //top broda igrača
           462, 247, objekt, 0) == true
          || raceDetekcijaPreklapanja(new float[]{389, 109, 461, 162, 461, 176, 389, 201}, //kljun broda igrača
           462, 247, objekt, 0) == true
          || raceDetekcijaPreklapanja(new float[]{47, 25, 94, 25, 138, 51, 63, 104}, //rep broda igrača
           462, 247, objekt, 0) == true
          || raceDetekcijaPreklapanja(new float[]{16, 0, 96, 0, 102, 3, 106, 8, 106, 16, 102, 21, 97, 24, 15, 24, 9, 21, 5, 16, 5, 9, 9, 4}, //zakrilce broda igrača
           462, 247, objekt, 0) == true)
        {
         racePostaviBoost();
        }  
  }
}







boolean raceDetekcijaPreklapanja(float[] dobiveneKoordinate, 
  float originalDimenzijaX, float originalDimenzijaY, int objekt/*1 znaci bomba; 2 zvojezda, 3 boost*/, int indeksDobivenogMetka)
{
  spaceshipPrilagodiKoordinateLika(dobiveneKoordinate, raceShipX, raceShipY, originalDimenzijaX, originalDimenzijaY, raceShip.width, raceShip.height);
  
  
  //detekcija kolizije - treba prilagoditi polje koje se šalje - prvo su koordinate središta meteora
  //gledam samo dijelove unutar ekrana - sve negativne maknem td. dodam svima width (x koord.) i height (y koord.)
  int dimenzijaPoljaZaSlanje = dobiveneKoordinate.length + 2;

  if (dimenzijaPoljaZaSlanje < 8) //zbog kasnijeg poziva kolizijaKrugMnogokut (treba bar 8 elemenata polja)
    return false;

  float[] poljeZaSlanje = new float[dimenzijaPoljaZaSlanje];

  if(objekt==1)
  {
    poljeZaSlanje[0] = raceBombX.get(indeksDobivenogMetka);
    poljeZaSlanje[1] = raceBombY.get(indeksDobivenogMetka);
  }
  else if(objekt==2)
  {
    poljeZaSlanje[0] = raceStarX.get(indeksDobivenogMetka);
    poljeZaSlanje[1] = raceStarY.get(indeksDobivenogMetka);
  }
  else if(objekt==3)
  {
    poljeZaSlanje[0] = raceBoosterX;
    poljeZaSlanje[1] = raceBoosterY;
  }

  

  poljeZaSlanje[0] += width;
  poljeZaSlanje[1] += height;
  
  for (int r=2; r<poljeZaSlanje.length; ++r)
  {
    if (r%2==0) //x-koordinata
      poljeZaSlanje[r] = dobiveneKoordinate[r-2]+width;
    else //if(r%2==1) //y-koordinata
    poljeZaSlanje[r] = dobiveneKoordinate[r-2]+height;
  }

  float polumjer;
  polumjer=height/20; //promjer je h/10

  if(objekt==1 || objekt==2 || objekt==3)
    polumjer=height/20; //promjer je h/10


  try {
    return kolizijaKrugMnogokut(poljeZaSlanje, polumjer);
  }
  catch(Exception e) {
    println("Iznimka: kolizijaKrugMnogokut iz detekcijaMetakBrod - Poruka o grešci:");
    println(e);
    exit();
    return false;
  }
}












/*stara f-ja

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
*/


/* stara f-ja
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
*/

//stare f-je

/*
boolean raceKolizijaBooster(){
  if(!raceBoostOnScreen)  //Ako booster nije aktivan sigurno nije kolizija
    return false;
  if((raceBoosterY+height/20 >= raceShipY-raceShip.height/2) && (abs(raceBoosterX-raceShipX)<(height/20+raceShip.width/2)))//na dobroj visini && na dobroj sirini
    return true;

  return false;
}



*/


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


void raceCheckTimeOfBoost(){
  int raceTimePassed=millis()-raceTimeBoost;
  if(raceTimePassed>5000){  //boost raje 5 secundi Onda vrati na standard---------------------------TODO: ovo prilagoditi
    raceBoostActive=false;
    raceBrzinaPozadine=raceBrzinaPozadineOsnova;
    raceShieldActive=false; 
  }
}
