PImage spaceship, restartGumb, exitGumb, spaceshipShield;
int polozajX, polozajY; //polozaj broda
int brzinaBroda; //koja je brzina broda

int spaceShipStanjeArmagedona = 0;
int spaceshipMaxTrajanjeStita = 180, 
  spaceshipTrajanjeStita;

PImage[] zivotiBrod = new PImage[3];
int brZivota;


int brojBodova, spaceshipBodoviZaIspis;
boolean spaceshipGameOver;

PFont spaceshipFont;

void spaceshipSetup()
{
  player.close(); //zaustavi prethodnu stvar
  player = minim.loadFile("Galactic.mp3"); //učitaj novu stvar
  player.loop(); //glazba se ponavlja

  //font za igru postavljen
  spaceshipFont = createFont("MONO.ttf", 32);
  textFont(spaceshipFont);
  noCursor(); //makni pokazivač miša dok si u igri
  background(0);
  textSize(width/20);
  text("loading...", width/20, height/2);

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
    if (spaceshipTrajanjeStita > 0) {
      //ako imam štit, crtam ga, nitko me ne može pogoditi
      --spaceshipTrajanjeStita;
      //crtam prikaz (u obliku luka oko broda) koliko još štit traje
      noFill(); //bez ispune
      stroke(0, 0, 255); //plava crta
      strokeWeight(spaceship.width/20+1); //debljina crte
      arc(polozajX, polozajY,
        spaceship.width, spaceship.width, 
        radians(-90), radians(-90+spaceshipTrajanjeStita*(360/spaceshipMaxTrajanjeStita)));
      //crtam sliku štita oko broda
      image(spaceshipShield, polozajX, polozajY);

      //vrati kako je bilo prije
      stroke(0);
      strokeWeight(1);
    } else { //nemam štit
      detektirajGubitakZivota(); //pogledam je li me netko pogodio
    }

    crtajTenk();

    if (polozajTenka <= krajnjiPolozajTenka)
      detektirajPogodakTenka();

    spaceshipIspisiRezultat();
    spaceshipCrtajEksplozije();
  } else //funkcija spaceshipIspisiRezultat brine o prelasku u stanje GAME OVER
  {      
    spaceshipCrtajEksplozije(); //one koje su preostale

    //ispis teksta GAME OVER, broja bodova, spremanje rezultata, top ljestvica
    crtajGameOverFormu();
  }

  if (spaceShipStanjeArmagedona>0)
  {
    fill(255, 255, 0, spaceShipStanjeArmagedona*2);
    rect(width/2, height/2, width, height);
    --spaceShipStanjeArmagedona;
  }
}


void spaceshipIspisiRezultat()
{
  fill(255);
  textAlign(RIGHT, TOP);
  textSize(width/30);
  text(spaceshipBodoviZaIspis, width-width/60, width/60);
  if (spaceshipBodoviZaIspis < brojBodova)
    ++spaceshipBodoviZaIspis;
  if (brZivota<=0)
  {
    spaceshipGameOver = true;
    spaceshipDodajEksploziju(polozajX, polozajY);
    cursor(); //pokaži pokazivač miša da bi korisnik mogao kliknuti neki gumb
  }
}



void ucitajBrod()
{
  spaceship = loadImage("spaceship.png");
  spaceship.resize(width/10, width/20);

  spaceshipShield = loadImage("tenkShield.png"); //učitaj sliku štita od broda
  spaceshipShield.resize(spaceship.width, spaceship.width);

  spaceshipTrajanjeStita = spaceshipMaxTrajanjeStita; //početno aktiviraj štit


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
  brojBodova = 0; //početni rezultat na 0
  spaceshipGameOver = false;
  spaceshipBodoviZaIspis = 0; //početno se ispiše 0 bodova
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


void pokreniArmagedon()
{
  if (raketaDostupna == false) //ako je raketa ispucana
  {
    //promjena zaslona ekrana
    spaceShipStanjeArmagedona = 50;

    //uništi raketu (iskorištena je)
    raketaDostupna = true;

    //uništi sve brodove na ekranu i tenku oduzmi tri života
    for (int i=0; i<ukupnoNeprijateljskihBrodova; ++i) //za svaki neprijateljski brod
    {
      if (trenutnoAktivniBrodovi[i] == true) //samo za one brodove koji još postoje
      {
        trenutnoAktivniBrodovi[i] = false;
        spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
        brojBodova += 5;
      }
    }

    if (polozajTenka <= krajnjiPolozajTenka) //ako tenk nema štit
    {
      tenkLives = tenkLives - 3;
      if (tenkLives <=0)
      {
        //malo veća eksplozija za tenk (tj. tri male eksplozije)
        spaceshipDodajEksploziju(polozajTenka, visinaTenka+tenkTijelo[0].height/4);
        spaceshipDodajEksploziju(polozajTenka-tenkTijelo[0].width/4, visinaTenka-tenkTijelo[0].height/4);
        spaceshipDodajEksploziju(polozajTenka+tenkTijelo[0].width/4, visinaTenka-tenkTijelo[0].height/4);
        polozajTenka = 4*width;
        brojBodova += 50; //za uništenje tenka dobiva se 50 bodova
        tenkLives = maxTenkLives;
      }
    }
  }
}