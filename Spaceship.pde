PImage spaceship, restartGumb, exitGumb;
int polozajX, polozajY; //polozaj broda
int brzinaBroda; //koja je brzina broda

PImage[] zivotiBrod = new PImage[3];
int brZivota;

//import processing.sound.*;
//SoundFile file;

int spaceshipBrojBodova, spaceshipBodoviZaIspis;
boolean spaceshipGameOver;

PFont spaceshipFont;

void spaceshipSetup()
{
  player.close(); //zaustavi prethodnu stvar
  player = minim.loadFile("Galactic.mp3"); //učitaj novu stvar
  player.play(); //pokreni novu stvar

  //font za igru postavljen
  spaceshipFont = createFont("MONO.ttf", 32);
  textFont(spaceshipFont);
  noCursor(); //makni pokazivač miša dok si u igri
  background(0);
  textSize(width/20);
  text("loading...", width/20, height/2);

  //try {    
  //  file = new SoundFile(this, "Galactic.mp3");
  //  file.play();
  //} 
  //catch (Exception e) {
  //}

  imageMode(CENTER);

  odrediBrzinu();

  //učitam potrebne slike i postavim na početne uvjete
  ucitajPozadine();
  ucitajBrod();
  ucitajStreljivo(); 
  ucitajNeprijatelje();
  ucitajNeprijateljskeMetke();
  ucitajTenk();
  spaceshipUcitajEksplozije();
}

float[] izmjereniFpsovi = new float[]{35, 35, 35, 35, 35, 35, 35, 35, 35, 35};
int indeksZaMjerenjeFpsova = 0;
float prosjecanFps;
float korekcijaZbogFpsa = 1;


void odrediBrzinu()
{ 
  izmjereniFpsovi[indeksZaMjerenjeFpsova] = frameRate;
  prosjecanFps = 0;
  for (int i=0; i<izmjereniFpsovi.length; ++i)
    prosjecanFps += izmjereniFpsovi[i];
  prosjecanFps /= izmjereniFpsovi.length; 
  korekcijaZbogFpsa = 40.0/prosjecanFps; 

  brzinaBombe = int(width/50.0 * korekcijaZbogFpsa);
  brzinaMetakaNeprijatelja= int(width/70 * korekcijaZbogFpsa);
  osnovnaBrzinaBroda = 1/20.0*width/150.0 * korekcijaZbogFpsa;
  //brzinaPozadine = (1 > osnovnaBrzinaBroda) ? osnovnaBrzinaBroda : 1;
  brzinaPozadine = 1;
  brzinaMetka = int(width/60 * korekcijaZbogFpsa);
  brzinaRakete = int(width/80 * korekcijaZbogFpsa);

  //postavim brzinu kojom se brod kreće
  brzinaBroda = int(height/40 * korekcijaZbogFpsa);

  indeksZaMjerenjeFpsova = (indeksZaMjerenjeFpsova+1)%(izmjereniFpsovi.length);
  //razni kontrolni ispisi
  //println("prosjecanFps = " + prosjecanFps); println("korekcijaZbogFpsa = " + korekcijaZbogFpsa);
  //println("brzinaBombe = " + brzinaBombe); println("brzinaMetakaNeprijatelja = " + brzinaMetakaNeprijatelja);
  //println("osnovnaBrzinaBroda = " + osnovnaBrzinaBroda);  println("brzinaMetka = " + brzinaMetka);
  //println("brzinaRakete = " + brzinaRakete); println("brzinaBroda = " + brzinaBroda);
}

void spaceship()
{
  odrediBrzinu();
  //println(frameRate);

  //pomicanje i crtanje pozadine
  crtajPozadinu();

  if (spaceshipGameOver == false)
  {
    //pomicanje i crtanje broda
    crtajBrod();

    //pucanje
    pucaj();

    //crtanje neprijatelja
    kontrolaNeprijatelja();
    crtajNeprijateljskeMetke();
    detektirajUnistenjeNeprijateljskogBroda();
    detektirajGubitakZivota(); //je li me netko pogodio
    crtajTenk();

    if (polozajTenka <= krajnjiPolozajTenka)
      detektirajPogodakTenka();

    spaceshipIspisiRezultat();
    spaceshipCrtajEksplozije();
  } else //funkcija spaceshipIspisiRezultat brine o prelasku u stanje GAME OVER
  {      
    spaceshipCrtajEksplozije(); //one koje su preostale
    fill(0);
    rectMode(CENTER); //pravokutnik - središte x, y, širina, visina
    rect(width/2, height/2, 4*width/5, height/2);
    fill(255);
    textAlign(CENTER, BOTTOM);
    int spaceshipGameOverVelicinaSlova = (width > height ? height : width )/10;
    textSize(spaceshipGameOverVelicinaSlova);
    text("GAME OVER", width/2, height/2);
    fill(255, 255, 0); //žuta boja
    textAlign(CENTER, TOP);
    text("Ostvareni bodovi: "+spaceshipBrojBodova, width/2, height/2);

    //nacrtaj gumb za restart
    image(restartGumb, width/3, 3*height/4);
    //nacrtaj gumb za izlaz (izbornik levela)
    image(exitGumb, 2*width/3, 3*height/4);
  }
}


void spaceshipIspisiRezultat()
{
  fill(255);
  textAlign(RIGHT, TOP);
  textSize(width/30);
  text(spaceshipBodoviZaIspis, width-width/60, width/60);
  if (spaceshipBodoviZaIspis < spaceshipBrojBodova)
    ++spaceshipBodoviZaIspis;
  if (brZivota<=0)
  {
    spaceshipGameOver = true;
    spaceshipDodajEksploziju(polozajX, polozajY);
    cursor(); //pokaži pokazivač miša da bi korisnik mogao kliknuti neki gumb
    //try { 
    //  file.stop();
    //} 
    //catch(Exception e) {
    //} //zaustavi sviranje glazbe
    //eventualno tu počinje neka glazba kod prikaza Game Overa
  }
}



void ucitajBrod()
{
  spaceship = loadImage("spaceship.png");
  spaceship.resize(width/10, width/20);

  for (int i=0; i<3; ++i)
  {
    zivotiBrod[i] = loadImage("life"+i+".png");
    zivotiBrod[i].resize(width/20, height/10);
  }

  //postavim brod na početni položaj
  polozajY = height/2;
  polozajX = width/5;

  //postavim broj života broda
  brZivota = 3;
  spaceshipBrojBodova = 0; //početni rezultat na 0
  spaceshipGameOver = false;
  spaceshipBodoviZaIspis = 0; //početno se ispiše 0 bodova

  restartGumb = loadImage("restartButton.png");
  restartGumb.resize((width>height) ? height/4 : width/4, (width>height) ? height/4 : width/4);

  exitGumb = loadImage("exitButton.png");
  exitGumb.resize((width>height) ? height/4 : width/4, (width>height) ? height/4 : width/4);
}

void crtajBrod()
{
  for (int i=0; i<brZivota; ++i)
  {
    image(zivotiBrod[i], (2*i+1)*zivotiBrod[i].width/2, zivotiBrod[i].height/2);
  }

  //pomicanje broda
  if (polozajY > mouseY+brzinaBroda && polozajY > spaceship.height)
  {
    polozajY -= brzinaBroda;
  } else if (polozajY < mouseY-brzinaBroda && polozajY < height-spaceship.height)
  {
    polozajY += brzinaBroda;
  }

  //noStroke();
  strokeWeight(1);
  rectMode(CORNER);

  //crtanje broda
  image(spaceship, polozajX, polozajY);
  rectMode(CORNER);
  fill(255);
  rect( polozajX-spaceship.width/2, 
    polozajY+spaceship.height/2, 
    spaceship.width, 
    spaceship.height/10);
  rect( polozajX-spaceship.width/2, 
    polozajY+spaceship.height/2+spaceship.height/10, 
    spaceship.width, 
    spaceship.height/10);

  if (punimMetke == 0)  //crtanje loading trake za metke
    fill(0, 255, 0);  //napunjeno je zelene boje
  else
    fill(255, 0, 0);  //ako se puni onda je crvene boje
  rect( polozajX-spaceship.width/2, 
    polozajY+spaceship.height/2, 
    (vrijemePotrebnoZaPunjenje-punimMetke)*spaceship.width/vrijemePotrebnoZaPunjenje, 
    spaceship.height/10);

  if (punimRaketu == 0) //crtanje loading trake za raketu
    fill(0, 0, 255);  //napunjeno je plave boje
  else
    fill(255, 150, 0);  //ako se puni onda je narančaste boje
  rect( polozajX-spaceship.width/2, 
    polozajY+spaceship.height/2+spaceship.height/10, 
    (vrijemePotrebnoZaRaketu-punimRaketu)*spaceship.width/vrijemePotrebnoZaRaketu, 
    spaceship.height/10);
}

/* void stop()
 {
 
 } */