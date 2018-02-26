PImage mapaLevelaPozadina;

int mapaBrojLevela = 3;
PImage[] slikeLevela = new PImage[mapaBrojLevela];
PImage[] slikeLevelaFilter = new PImage[mapaBrojLevela];

class Tocka { 
  float x, y;

  Tocka(float a, float b) {
    x = a;
    y = b;
  }
};

Tocka[] koordinateLevelPrikaza = new Tocka[mapaBrojLevela];

void mapaUcitajSlike() {
  int manjaDimenzija = (width < height) ? width : height;

  for (int i=0; i<mapaBrojLevela; ++i) {
    slikeLevela[i] = loadImage("planet"+i+".png");
    slikeLevela[i].resize(manjaDimenzija/3, manjaDimenzija/3);

    slikeLevelaFilter[i] = loadImage("planet"+i+".png");
    slikeLevelaFilter[i].resize(manjaDimenzija/3, manjaDimenzija/3);
    slikeLevelaFilter[i].filter(GRAY);
  }

  mapaLevelaPozadina = loadImage("mapaLeveli.jpg");
  mapaLevelaPozadina.resize(width, height);
}

void pocetnePostavkeZaMapuLevela() {
  textAlign(CENTER, CENTER);
  imageMode(CENTER);
  for (int i=0; i<mapaBrojLevela; ++i)
  {
    koordinateLevelPrikaza[i] = new Tocka(width/3*i+width/6, height/6*(i%2)+height/3);
  }
}


void crtajMapu() {

  textSize(slikeLevela[0].width/3);
  textAlign(CENTER, CENTER);

  //zakomentirano radi performansi
  //image(mapaLevelaPozadina, width/2, height/2);


  fill(255); //bijeli brojevi na planetima

  for (int i=0; i<mapaBrojLevela; ++i) {
    if ( pow(mouseX-koordinateLevelPrikaza[i].x, 2) + pow(mouseY - (koordinateLevelPrikaza[i].y), 2) 
      < pow(slikeLevela[i].width/2, 2)) { //pokazivač je iznad planeta
      image(slikeLevela[i], koordinateLevelPrikaza[i].x, koordinateLevelPrikaza[i].y);
    } else {
      image(slikeLevelaFilter[i], koordinateLevelPrikaza[i].x, koordinateLevelPrikaza[i].y);
    }
    
    switch (i)
    {
    case 0: 
      text("i", koordinateLevelPrikaza[i].x, koordinateLevelPrikaza[i].y);
      break;
    case 1: 
      text("ii", koordinateLevelPrikaza[i].x, koordinateLevelPrikaza[i].y);
      break;
    case 2: 
      text("iii", koordinateLevelPrikaza[i].x, koordinateLevelPrikaza[i].y);
      break;
    default:
      break;
    }
  }

  //pravokutnik sa uputama (odaberite level)
  fill(0, 0, 200);
  rectMode(CENTER);
  rect(width/2, height/6, width/3, height/6);

  //upute u pravokutnik
  fill(0); //tekst bijele boje
  textSize((height/12<width/(3*15) ? height/12 : width/(3*15)));
  text("Odaberite level!", width/2, height/6);

  //gumb za povratak
  rectMode(CENTER);
  fill(20, 86, 20);
  rect(width/2, 6*height/7, width/2, height/6);
  fill(0);
  text("Klikni za povratak.", width/2, 6*height/7);
}