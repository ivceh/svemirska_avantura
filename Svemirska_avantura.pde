PImage pozadina, 
  mars, venera, neptun, pluton;

void setup()
{
  fullScreen();

  introPocetnePostavke(); //ovo će i ispisati loading...

  stanjeIgre = -1; //na početku smo u uvodnoj animaciji
  stanjeIzbornika = 0; //za izbornik, počinjemo od glavnog izbornika

  ucitajSvePotrebneSlikeZaIzbornik();
  mapaUcitajSlike(); //učitaj slike za mapu levela

  //učitaj font za izbornik
  izbornikNaslovFont = createFont("SPACEBAR.ttf", 32);
}

int stanjeIgre = 0, stanjeIzbornika = 0;
//stanjeIgre ==  0 akko smo u nekom izborniku
//           == -1 akko smo u uvodnoj animaciji
//stanjeIgre > 0 ako smo u igre, nekom levelu, npr. 1 znači u 1. levelu
//stanjeIzbornika == 0 akko smo u glavnom izborniku
//    == 1 akko smo na mapi za biranje levela
//    == 2 akko smo u izborniku za postavljanje opcija
//    == 3 akko smo u glavnom izborniku kliknuli na informacije, pa smo tamo

float pomakIzbornika = 0;
float easingPomakaIzbornika = 0.15;


void draw()
{
  background(0);
  //println(frameRate);
  if (stanjeIgre == -1) //crta se uvodna animacija
  {
    crtanjeUvoda();
  } else if (stanjeIgre == 0) //u nekom izborniku smo
  {
    cursor(); //u izborniku nam treba pokazivač miša, pa ga pokaži
    textFont(izbornikNaslovFont);

    textAlign(CENTER);
    imageMode(CENTER);

    if (pomakIzbornika>0)
      pomakIzbornika = pomakIzbornika - easingPomakaIzbornika*pomakIzbornika - height/200.0;
    else
      pomakIzbornika = 0;

    if (stanjeIzbornika == 0)
    {
      image(pozadina, width/2, height/2);
      translate(0, pomakIzbornika);
      crtajIzbornik();
    } else if (stanjeIzbornika == 1)
    {
      image(mapaLevelaPozadina, width/2, height/2);
      translate(0, pomakIzbornika);
      crtajMapu();
    } else if (stanjeIzbornika == 2)
    {
      image(pozadina, width/2, height/2);
      translate(0, pomakIzbornika);
      crtajInformacije();
    } else if (stanjeIzbornika == 3)
    {
      image(pozadina, width/2, height/2);
      translate(0, pomakIzbornika);
      crtajOpcije();
    }
  } else if (stanjeIgre == 1)
  {
    //ovdje se poziva funkcija (tj. igra) za 1. level
    crtajIgru1();
  } else if (stanjeIgre == 2)
  {
    //ovdje se poziva funkcija (tj. igra) za 2. level
    crtajIgru2();
  } else if (stanjeIgre == 3)
  {
    //ovdje se poziva funkcija (tj. igra) za 3. level
    spaceship();
  }
}


void ucitajSvePotrebneSlikeZaIzbornik()
{
  //slike učitam i resizam na početku da se poslije ne moraju resizati svaki put (usporava program)
  pozadina = loadImage("tamni_svemir.jpg"); 
  pozadina.resize(width, height);
  mars = loadImage("mars.png"); 
  mars.resize((int)(width*0.15), (int)(width*0.15));
  venera = loadImage("venera.png"); 
  venera.resize((int)(width*0.15), (int)(width*0.15));
  neptun = loadImage("neptun.png"); 
  neptun.resize((int)(width*0.15), (int)(width*0.15));
  pluton = loadImage("pluton.png"); 
  pluton.resize((int)(width*0.15), (int)(width*0.15));
  
  restartGumb = loadImage("restartButton.png");
  restartGumb.resize((width>height) ? height/4 : width/4, (width>height) ? height/4 : width/4);

  exitGumb = loadImage("exitButton.png");
  exitGumb.resize((width>height) ? height/4 : width/4, (width>height) ? height/4 : width/4);

  saveGumb = loadImage("saveButton.png");
  saveGumb.resize((width>height) ? height/4 : width/4, (width>height) ? height/4 : width/4);
}

void mousePressed()
{
  if (stanjeIgre == 0 && pomakIzbornika == 0) //u nekom smo izborniku (i slika se više ne miče)
  {
    if (stanjeIzbornika == 0) //u glavnom smo izborniku
    {
      //je li kliknut gumb za start
      if (pow(mouseX-0.2*width, 2)+pow(mouseY-0.45*height, 2)<pow(0.075*width, 2)) //0.075=0.15/2
      {
        pomakIzbornika = height;
        pocetnePostavkeZaMapuLevela();
        stanjeIzbornika = 1;
      }

      //je li kliknut gumb za info
      if (pow(mouseX-0.6*width, 2)+pow(mouseY-0.45*height, 2)<pow(0.075*width, 2))
      {
        pomakIzbornika = height;
        stanjeIzbornika = 2;
      }

      //je li kliknut gumb za opcije
      if (pow(mouseX-0.4*width, 2)+pow(mouseY-0.75*height, 2)<pow(0.075*width, 2))
      {
        pomakIzbornika = height;
        stanjeIzbornika = 3;
      }

      //je li kliknut gumb za izlaz
      if (pow(mouseX-0.8*width, 2)+pow(mouseY-0.75*height, 2)<pow(0.075*width, 2))
      {
        exit();
      }
    } else if (stanjeIzbornika == 1) //u mapi za biranje levela sam
    {
      //odabran je neki level
      for (int i=0; i<mapaBrojLevela; ++i)
      {
        koordinateLevelPrikaza[i] = new Tocka(width/3*i+width/6, height/6*(i%2)+height/3);
        if (pow(mouseX-(width/3*i+width/6), 2)+pow(mouseY-(height/6*(i%2)+height/3), 2) <= slikeLevela[i].width/2*slikeLevela[i].width/2)
        {
          switch (i) {
          case 0:
            println("Odabrana igra 1");
            //stanjeIgre = 1;
            ucitajTopListu(); //pogledaj top rezultate za tu igru
            //početne postavke za igru 1
            //...
            //pokreni igru 1
            //...
            break;
          case 1:
            println("Odabrana igra 2");
            //stanjeIgre = 2;
            ucitajTopListu(); //pogledaj top rezultate za tu igru
            //početne postavke za igru 2
            //...
            //pokreni igru 2
            //...
            break;
          case 2:
            println("Odabrana igra 3");
            stanjeIgre = 3;
            ucitajTopListu(); //pogledaj top rezultate za tu igru
            //početne postavke za igru 3
            spaceshipSetup();
            //pokreni igru 3
            spaceship();
            break;
          }
        }
      }
      //kliknut je gumb za povratak na glavni izbornik
      if (mouseX > width/4 && mouseX < 3*width/4 && mouseY < 6*height/7+height/12 && mouseY > 6*height/7-height/12)
      {
        pomakIzbornika = height;
        stanjeIzbornika = 0;
      }
    } else if (stanjeIzbornika == 2 || stanjeIzbornika == 3) //u informacijama, opcijama ili mapi
    {
      //kliknut je gumb za povratak na glavni izbornik
      if (mouseX > width/4 && mouseX < 3*width/4 && mouseY < 6*height/7+height/12 && mouseY > 6*height/7-height/12)
      {
        pomakIzbornika = height;
        stanjeIzbornika = 0;
      }
    }
  }
  //nedostaje if ako sam u igri 1
  //else if(stanjeIgre == 1)
  //neki kod
  //nedostaje if ako sam u igri 2
  //else if(stanjeIgre == 2)
  //neki kod
  else if (stanjeIgre == 3) //znači u igri Spaceship sam
  {
    if (spaceshipGameOver == true) //nastupio je Game Over za igru Spaceship
    {
      //ukoliko je klinuto na gumb za restart, ponovo pokreni igru
      if (pow(mouseX-width/4, 2)+pow(mouseY-0.8*height, 2) <= pow(restartGumb.width/2, 2))
      {
        spaceshipGameOver = false;
        imeIgraca = ""; //očisti ime igrača
        spaceshipSetup();
      }
      //ukoliko je kliknuto na gumb za exit, odi na izbornik levela
      else if (pow(mouseX-3*width/4, 2)+pow(mouseY-0.8*height, 2) <= pow(exitGumb.width/2, 2))
      {
        pomakIzbornika = height;
        imeIgraca = ""; //očisti ime igrača
        stanjeIgre= 0; //Idemo u izbornik. Koji:
        stanjeIzbornika = 1; //pa izbornik za biranje levela!

        //zaustavi glazbu igre i pokreni onu od izbornika
        player.close();
        player = minim.loadFile("TimmyTrumpetMantra.mp3");
        player.play();
      }
      //ukoliko je kliknuto na gumb za save, spremi rezultat
      else if(pow(mouseX-width/2, 2)+pow(mouseY-0.8*height,2) <= pow(saveGumb.width/2, 2) && brojBodova>0)
      {
        spremiRezultat(imeIgraca, brojBodova, stanjeIgre);
        if(imeIgraca.equals("") == false) {
           imeIgraca = "";
           brojBodova = 0;
           ucitajTopListu();
        }
      }
    }
  }
}