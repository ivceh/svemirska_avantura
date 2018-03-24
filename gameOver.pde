PImage saveGumb;
int maxBrojSlovaImena = 10;
String imeIgraca = "";
char[] dopusteniZnakoviImena = new char[]{
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 
  'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 
  'w', 'x', 'y', 'z', 
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 
  'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 
  'W', 'X', 'Y', 'Z'
};

String[] topListaImena = new String[5];
int[] topListaBodova = new int[5];

void ucitajTopListu(){
  for(int i=0; i<topListaImena.length; ++i)
  {
    topListaImena[i] = dohvatiImeIgraca(i+1, stanjeIgre);
    topListaBodova[i] = dohvatiBrojBodova(i+1, stanjeIgre);
  }
}

void crtajTopListu() {
  for(int i=0; i < topListaImena.length; ++i){
    textAlign(LEFT);
    text((i+1)+".", 0.15*width, (0.2+i*0.1)*height);
    text(topListaImena[i],0.3*width,(0.2+i*0.1)*height);
    textAlign(RIGHT); //da kod crtanja bodova broj ne raste udesno
    text(topListaBodova[i],0.85*width,(0.2+i*0.1)*height);
  }
}

void crtajGameOverFormu() {
  noStroke(); //bez obruba
  fill(0); //crna pozadina velikog pravokutnika iza
  rectMode(CENTER); //pravokutnik - središte x, y, širina, visina
  rect(width/2, 4.5*height/10, 4*width/5, 7*height/10);
  fill(255);
  textAlign(CENTER, BOTTOM);
  int spaceshipGameOverVelicinaSlova = (width > height ? height : width )/10;
  textSize(spaceshipGameOverVelicinaSlova);

  //ako nema bodova ispisuje se forma za unos imena igrača i spremanje, inače top lista
  if (brojBodova > 0) {
    text("GAME OVER", width/2, height/4);
    fill(255, 255, 0); //žuta boja
    textAlign(CENTER, TOP);
    text("Ostvareni bodovi: "+brojBodova, width/2, height/4);

    fill(255, 0, 0); //crvena slova
    text("IME:", 0.175*width, 0.45*height);
    noFill();
    stroke(255, 0, 0); //crveni obrub pravokutnika za unos imena
    strokeWeight(height/100+2);
    float sredinaPravX=0.55*width, sredinaPravY=0.51*height, 
      sirPrav=0.62*width, visPrav=0.15*height;
    rect(sredinaPravX, sredinaPravY, sirPrav, visPrav);

    //crtanje polja za znakove imena (jedan znak jedno polje)
    strokeWeight(height/200+2);
    for (int i = 1; i < maxBrojSlovaImena; ++i) {
      line(sredinaPravX-sirPrav/2+i*sirPrav/maxBrojSlovaImena, 
        sredinaPravY-visPrav/2, 
        sredinaPravX-sirPrav/2+i*sirPrav/maxBrojSlovaImena, 
        sredinaPravY+visPrav/2);
    }

    //upiši ime igrača u polja (ako broj bodova != 0)
    textSize((visPrav > sirPrav/maxBrojSlovaImena) ?
      sirPrav/maxBrojSlovaImena : visPrav);
    fill(255); //bijela slova
    textAlign(CENTER, TOP); //slovo u sredini polja
    for (int i = 0; i < imeIgraca.length(); ++i) {
      text(imeIgraca.charAt(i), 
        sredinaPravX - sirPrav/2 + i*sirPrav/maxBrojSlovaImena
        + sirPrav/(2*maxBrojSlovaImena), 
        sredinaPravY-visPrav/2);
    }

    //crta pravokutnik u polju u koje se može upisati novi znak
    fill(255); //bijeli pravokutnik
    if (imeIgraca.length() < maxBrojSlovaImena && frameCount % 100 < 50) {
      rect(sredinaPravX - sirPrav/2 
        + imeIgraca.length()*sirPrav/maxBrojSlovaImena + sirPrav/(2*maxBrojSlovaImena), 
        sredinaPravY, 
        sirPrav/maxBrojSlovaImena, 
        visPrav);
    }

    //nacrtaj gumb za spremanje rezultata
    image(saveGumb, width/2, 0.8*height);
  } else { //inače ispiši top ljestvicu igrača
    crtajTopListu();
  }

  //nacrtaj gumb za restart
  image(restartGumb, width/4, 0.8*height); 
  //nacrtaj gumb za izlaz (izbornik levela)
  image(exitGumb, 3*width/4, 0.8*height);

  stroke(0); //vraćam boju na crnu
}

boolean uDopustenimZnakovima(char znak) {
  for (int i = 0; i < dopusteniZnakoviImena.length; ++i) {
    if (dopusteniZnakoviImena[i] == znak) {
      return true;
    }
  }
  return false;
}

void GameOverKeyPressed() {
  if (uDopustenimZnakovima(key) && imeIgraca.length() < maxBrojSlovaImena) {
    imeIgraca += key;
  } else if (key == BACKSPACE && imeIgraca.length() > 0) {
    imeIgraca = imeIgraca.substring(0, imeIgraca.length()-1);
  }
}