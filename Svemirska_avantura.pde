PImage pozadina, 
  mars, venera, neptun, pluton;

Boolean crtanjeHelpa = false;
PImage[] slikeHelpova = new PImage[3];

void setup()
{
  fullScreen();

  introPocetnePostavke(); //ovo će i ispisati loading...

  stanjeIgre = -1; //na početku smo u uvodnoj animaciji 
  stanjeIzbornika = 0; //za izbornik, počinjemo od glavnog izbornika 

  ucitajSvePotrebneSlikeZaIzbornik();
  mapaUcitajSlike(); //učitaj slike za mapu levela
  ucitajSlikeOpcija(); //učitaj slike za opcije

  ucitajPodatkeZaInfoMenu();

  //učitaj font za izbornik
  izbornikNaslovFont = createFont("SPACEBAR.ttf", 32);
}

int stanjeIgre = 0, stanjeIzbornika = 0;
//stanjeIgre ==  0 akko smo u nekom izborniku
//           == -1 akko smo u uvodnoj animaciji
//stanjeIgre > 0 ako smo u igri, nekom levelu, npr. 1 znači u 1. levelu
//stanjeIzbornika == 0 akko smo u glavnom izborniku
//    == 1 akko smo na mapi za biranje levela
//    == 2 akko smo u informacijama
//    == 3 akko smo u izborniku za opcije

float pomakIzbornika = 0;
float easingPomakaIzbornika = 0.15;


void draw()
{
  if (glazbaUkljucena == false) {
    try { 
      player.close();
    }
    catch(Exception e) {
    };
  }

  //ako smo u igi i pritisnut je h za help
  if (stanjeIgre > 0 && crtanjeHelpa == true) {
    image(slikeHelpova[stanjeIgre-1], width/2, height/2);
    return;
  }

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
    race();
  } else if (stanjeIgre == 2)
  {
    //ovdje se poziva funkcija (tj. igra) za 2. level
    pacman();
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

  //učitam slike helpova (koje se prikazuju pritiskom na tipku h)
  for (int i=0; i < slikeHelpova.length; ++i) {
    slikeHelpova[i] = loadImage("help"+(i+1)+".png");
    slikeHelpova[i].resize(width, height);
  }
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
            stanjeIgre = 1;
            ucitajTopListu(); //pogledaj top rezultate za tu igru
            //početne postavke za igru 1
            raceSetup();
            //pokreni igru 1
            race();
            break;
          case 1:
            println("Odabrana igra 2");
            //stanjeIgre = 2;
            ucitajTopListu(); //pogledaj top rezultate za tu igru
            stanjeIgre = 2;
            //početne postavke za igru 2
            pacmanSetup();
            //pokreni igru 2
            pacman();
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
      if (stanjeIzbornika == 2 )//u meniju informacije smo 
      { //reakcija na gumb za povratak je ista za info i opcije 
        if (mouseX > width/4 && mouseX < 3*width/4 && mouseY < 6*height/7+height/12 && mouseY > 6*height/7-height/12)
        {
          pomakIzbornika = height;
          stanjeIzbornika = 0;
          refreshHighScore=true; //pri sljedecem crtanju InfoMenija refreshaj HighScores      
          brojIgreZaPrikaz=0;//pri sljedecem crtanju opet pocni od igre#1
        }

        //reakcija na strelice
        //ako klikne na desnu strelicu
        if ((pow(mouseX-21*width/24, 2)+pow(mouseY-6*height/7, 2)) < pow(height/12, 2))
        {
          brojIgreZaPrikaz=(brojIgreZaPrikaz+1)%3;
        }
        //ako klikne na lijevu strelicu
        else if ((pow(mouseX-width/8, 2)+pow(mouseY-6*height/7, 2)) < pow(height/12, 2))
        {
          brojIgreZaPrikaz=(brojIgreZaPrikaz+2)%3; //+2= +3 -1 = -1 mod 3 ___ da izbjegnem modulo s negativnim brojevima
        }
      }


      //kliknut je gumb za povratak na glavni izbornik
      if (mouseX > width/4 && mouseX < 3*width/4 && mouseY < 6*height/7+height/12 && mouseY > 6*height/7-height/12)
      {
        pomakIzbornika = height;
        stanjeIzbornika = 0;
      }
    }
  } else if (stanjeIgre == 1)
  {
    if (raceGameOver == true) //nastupio je Game Over za igru Race
    {
      //ukoliko je klinuto na gumb za restart, ponovo pokreni igru
      if (pow(mouseX-width/4, 2)+pow(mouseY-0.8*height, 2) <= pow(restartGumb.width/2, 2))
      {
        raceGameOver = false;
        imeIgraca = ""; //očisti ime igrača
        raceSetup();
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
        //player.play();
        player.loop(); //želimo da se glazba ponavlja
      }
      //ukoliko je kliknuto na gumb za save, spremi rezultat
      else if (pow(mouseX-width/2, 2)+pow(mouseY-0.8*height, 2) <= pow(saveGumb.width/2, 2) && brojBodova>0)
      {
        spremiRezultat(imeIgraca, brojBodova, stanjeIgre);
        if (imeIgraca.equals("") == false) {
          imeIgraca = "";
          brojBodova = 0;
          ucitajTopListu();
        }
      }
    }
  } else if (stanjeIgre == 2) //znači u igri Pacman sam
  {
    if (pacmanIgraGotova) //nastupio je Game Over za igru Pacman
    {
      //ukoliko je klinuto na gumb za restart, ponovo pokreni igru
      if (pow(mouseX-width/4, 2)+pow(mouseY-0.8*height, 2) <= pow(restartGumb.width/2, 2))
      {
        pacmanIgraGotova = false;
        imeIgraca = ""; //očisti ime igrača
        pacmanSetup();
        pacman();
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
        //player.play();
        player.loop(); //želimo da se glazba ponavlja
      }
      //ukoliko je kliknuto na gumb za save, spremi rezultat
      else if (pow(mouseX-width/2, 2)+pow(mouseY-0.8*height, 2) <= pow(saveGumb.width/2, 2) && brojBodova>0)
      {
        spremiRezultat(imeIgraca, brojBodova, stanjeIgre);
        if (imeIgraca.equals("") == false) {
          imeIgraca = "";
          brojBodova = 0;
          ucitajTopListu();
        }
      }
    }
  } else if (stanjeIgre == 3) //znači u igri Spaceship sam
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
        //player.play();
        player.loop(); //želimo da se glazba ponavlja
      }
      //ukoliko je kliknuto na gumb za save, spremi rezultat
      else if (pow(mouseX-width/2, 2)+pow(mouseY-0.8*height, 2) <= pow(saveGumb.width/2, 2) && brojBodova>0)
      {
        spremiRezultat(imeIgraca, brojBodova, stanjeIgre);
        if (imeIgraca.equals("") == false) {
          imeIgraca = "";
          brojBodova = 0;
          ucitajTopListu();
        }
      }
    }
  }
}

void mouseClicked() {
  if (stanjeIgre == 0 && stanjeIzbornika == 3) {
    //kliknuto na gumb za uključi/isključi glazbu
    if (mouseX >= width/24 && mouseX <= 23*width/24) {
      if (mouseY >= height/6 && mouseY <= height/3) {
        glazbaUkljucena = !glazbaUkljucena;
        if (glazbaUkljucena == true) {
          try {
            player = minim.loadFile("TimmyTrumpetMantra.mp3");
            player.loop();
          } 
          catch(Exception e) {
          }
        }
      }
    }
    //odabrana neka slika broda
    for (int i=0; i<prikaziBrodova.length; ++i) {
      println(mouseX, mouseY);
      if (mouseX >= (i+1)*width/4-width/8 && mouseX <= (i+1)*width/4+width/8) {
        if (mouseY >= height/2+height/24-height/6 && mouseY <= height/2+height/24+height/6) {
          indeksOznacenogBroda = i; //jer je kliknuto na i-ti pravokutnik (tj. i-tu sliku)
        }
      }
    }
  }
}

void keyPressed()
{
  PacmanKeyPressed();
  GameOverKeyPressed();

  //ako je nacrtan help, isključuje se pritiskom na bilo koju tipku
  if (crtanjeHelpa == true) {
    crtanjeHelpa = false;
  }

  //pritiskom na tipku h se help krene crtati (u igri, ali da nije Game Over)
  else if (crtanjeHelpa == false && (key == 'h' || key == 'H' || key == 'p' || key == 'P')) {
    if (stanjeIgre == 1 && raceGameOver == false) {
      crtanjeHelpa = true;
    } else if (stanjeIgre == 2 && pacmanIgraGotova == false) {
      crtanjeHelpa = true;
    } else if (stanjeIgre == 3 && spaceshipGameOver == false) {
      crtanjeHelpa = true;
    }
    //nedostaje još za igru 2
    /*else if (stanjeIgre == 2 && NEKA_VAR_ZA_GAME_OVER_U_IGRI_2 == false){
     crtanjeHelpa = true;
     }*/
  }
}