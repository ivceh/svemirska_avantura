PImage raceShip;//,raceRestartGumb,raceExitGumb; //igracev brod, gubbovi za meni kada igrac izgubi
PImage[] raceZivotiBrod= new PImage[3];
int raceShipX,raceShipY ;//pozicija igraca
int raceShipSpeed;    //brzina kojom se brod krece lijevo-desno
int raceBrojZivota;
boolean raceGameOver;// dal je igrac izgubio
PFont raceFont;
int racePassedMillis; //pomocna varijabla koju koristim za provjeru vremena proslog od zadnje aktivacije neke instance nekog objekta

void raceSetup()
{
  player.close(); //stop music
  player = minim.loadFile("Galactic.mp3"); //play music TODO: find music for the race
  player.loop(); //play music

  //set Font
  raceFont = createFont("MONO.ttf", 32);
  textFont(raceFont);
  noCursor(); //REMOVE CURSOR
  background(0);
  textSize(width/20);
  text("loading...", width/20, height/2);

  imageMode(CENTER);
  
  raceOdrediBrzinu();
  //ocisti objekte s ekrana
  raceEmptyBomb();
  raceEmptyStar();
  raceBoostOnScreen=false;

  
  //pocni mjeriti vrijeme
  raceTimeBoost=millis();
  raceTimeStar=millis();
  raceTimeBomb=millis();
  raceTimePozadina=millis();

  //učitam potrebne slike i postavim na početne uvjete
  raceUcitajPozadine();       
  raceUcitajBrod();      
  raceUcitaBomb();    
  raceUcitaStar();
  raceUcitajBoosters();

  raceUbrzanjePozadine=0;
  raceBrzinaPozadineOsnova=raceShipSpeed/4;
  raceBrzinaPozadine=raceBrzinaPozadineOsnova;
}


//ovaj dio za odredit brzinu je Sebastianov !
float[] raceIzmjereniFpsovi = new float[]{35, 35, 35, 35, 35, 35, 35, 35, 35, 35};
int raceIndeksZaMjerenjeFpsova = 0;
float raceProsjecanFps;
float raceKorekcijaZbogFpsa = 1;


void raceOdrediBrzinu() // edit(zapravo copy) Sebastijanovog :)
{ 
  raceIzmjereniFpsovi[raceIndeksZaMjerenjeFpsova] = frameRate;
  raceProsjecanFps = 0;
  for (int i=0; i<raceIzmjereniFpsovi.length; ++i)
    raceProsjecanFps += raceIzmjereniFpsovi[i];
  raceProsjecanFps /= raceIzmjereniFpsovi.length; 
  raceKorekcijaZbogFpsa = 40.0/raceProsjecanFps; 


  //postavim brzinu kojom se trkać kreće
  raceShipSpeed = int(height/40 * raceKorekcijaZbogFpsa);
  raceIndeksZaMjerenjeFpsova = (raceIndeksZaMjerenjeFpsova+1)%(raceIzmjereniFpsovi.length);
}


void race()
{
  raceOdrediBrzinu();
  
  //pomicanje i crtanje pozadine
  raceCrtajPozadinu();

  if (raceGameOver == false)//ako nije izgubio generiraj boostere,zvijezde i prepreke
  {
    racePassedMillis=millis()-raceTimeBoost;
    if(racePassedMillis>3000 && !raceBoostActive && !raceBoostOnScreen){  //svakih 3 secundi ako nije neki drugi aktivan  ------------- TODO: ovo prilagoditi kolicinu
       raceTimeBoost=millis();
       raceNoviBoost();
    }
    
    racePassedMillis=millis()-raceTimeStar;
    if(racePassedMillis>2000){  //svakih 2 secunde dodaj novi star-------------------------TODO: ovo prilagoditi kolicinu
       raceTimeStar=millis();
       raceNoviStar();
    }
    
    racePassedMillis=millis()-raceTimeBomb;
    if(racePassedMillis>1500){  //svakih 1.5 secunde dodaj novi bomb---------------------------TODO: ovo prilagoditi kolicinu
       raceTimeBomb=millis();
       raceNoviBomb();
    }
    
    racePassedMillis=millis()-raceTimePozadina;
    if(racePassedMillis>1000){  //svakih 1 secund1 se malo ubrza---------------------------TODO: ovo prilagoditi akceleraciju
       raceTimePozadina=millis();
       raceUbrzanjePozadine++;
    }
    
    //pomicanje i crtanje broda i ostalih objekata
    raceCrtajBrod();
    raceCrtajStar();
    raceCrtajBoost();
    raceCrtajBomb();
 
    raceKolizija();//provjeri dal je neka kolizija
    raceIspisiRezultat();
  } else 
  {      
  
    crtajGameOverFormu();//Design by Sebastijan

  }
}




void raceUcitajBrod(){  
  raceShip = loadImage("spaceship.png");    
  raceShip.resize(width/10, width/20);

  for (int i=0; i<3; ++i)
  {
    raceZivotiBrod[i] = loadImage("life"+i+".png");
    raceZivotiBrod[i].resize(width/20, height/10);
  }

  //postavim brod na početni položaj
  raceShipY = 5*height/6;
  raceShipX = width/2;

  //postavim broj života broda
  raceBrojZivota = 3;
  //raceBrojBodova = 0; //početni rezultat na 0
  brojBodova=0;//ovo koristim(umjesto raceBrojBodova) zbog funkcije za spremanje rezultata
  raceGameOver = false;

}  

 
void raceCrtajBrod(){

  for (int i=0; i<raceBrojZivota; ++i)
  {
    image(raceZivotiBrod[i], (2*i+1)*raceZivotiBrod[i].width/2, raceZivotiBrod[i].height/2);
  }

  //pomicanje broda lijevo-desno pomocu misa   //TODO: eventualo prebaciti na upravljanje strelicama
  if (raceShipX > mouseX+raceShipSpeed && raceShipX > 0+raceShip.width/2)    //ako mozes lijevo idi lijevo
  {
    raceShipX -= raceShipSpeed;
  } else if (raceShipX < mouseX-raceShipSpeed && raceShipX < width-raceShip.width/2)  //ako mozes ici desno idi desno
  {
    raceShipX += raceShipSpeed;
  }
  
  //crtanje broda
  image(raceShip, raceShipX, raceShipY);
  if(raceShieldActive){
      image(raceShield, raceShipX, raceShipY);
  }
  rectMode(CORNER);
}
    
void raceIspisiRezultat(){
  fill(255);
  textAlign(RIGHT, TOP);
  textSize(width/30);
  //text(raceBrojBodova, width-width/60, width/60);
  text(brojBodova, width-width/60, width/60);
  
}
