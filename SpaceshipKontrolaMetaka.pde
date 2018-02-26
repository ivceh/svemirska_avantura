PImage raketa, metak;

int brzinaMetka;
int ukupnoMetakaDostupno = 20;
int[] metciVisine = new int[ukupnoMetakaDostupno];
int[] metciPolozaji = new int[ukupnoMetakaDostupno];
int raketaVisina, raketaPolozaj, brzinaRakete;
Boolean raketaDostupna; //za true se ne crta, za false se raketa crta
Boolean[] avaiable = new Boolean[ukupnoMetakaDostupno]; //crta li se metak ili ne (false ili true)
int[] metciBrzine = new int[ukupnoMetakaDostupno];

int vrijemePotrebnoZaPunjenje;
int vrijemePotrebnoZaRaketu;
int punimMetke = 0, punimRaketu; //koliko mi treba da ispalim sljedeći metak/raketu

void ucitajStreljivo()
{
  raketa = loadImage("rocket.png");
  raketa.resize(width/15, width/40);
  metak = loadImage("bullet.png");
  metak.resize(width/40, width/40);

  vrijemePotrebnoZaPunjenje = 20;

  vrijemePotrebnoZaRaketu = 400;
  punimRaketu = vrijemePotrebnoZaRaketu;

  //na početku nema metaka na ekranu - svi su dostupni
  for (int i=0; i<ukupnoMetakaDostupno; ++i)
    avaiable[i] = true;

  raketaDostupna = true;
}

void pucaj()
{
  //punim metke ako treba
  if (punimMetke > 0)
    --punimMetke;
  if (punimRaketu > 0)
    --punimRaketu;

  if (mousePressed)
  {
    if (mouseButton == LEFT && punimMetke == 0)
    {
      for (int i=0; i<ukupnoMetakaDostupno; ++i)
      {
        if (avaiable[i] == true) //metak se još ne crta, ispali ga
        {
          //metak više nije dostupan jer je ispaljen
          avaiable[i] = false;
          metciVisine[i] = polozajY+spaceship.height/4-(height-polozajY)/5;
          metciPolozaji[i] = polozajX+spaceship.width/4;
          metciBrzine[i] = brzinaMetka;
          i = ukupnoMetakaDostupno; //ovo će prekinuti for petlju
          punimMetke = vrijemePotrebnoZaPunjenje; //počni puniti oružje
        }
      }
    } else if (mouseButton == RIGHT && punimRaketu == 0)//ide raketa
    {
      raketaVisina = polozajY+spaceship.height/4-(height-polozajY)/5;
      raketaPolozaj = polozajX + spaceship.width/4;
      raketaDostupna = false;
      punimRaketu = vrijemePotrebnoZaRaketu;
    }
  }

  //iscrtam sve metke koje trebam na ekranu
  for (int i=0; i < ukupnoMetakaDostupno; ++i)
  {
    if (avaiable[i] == false)
    {
      image(metak, metciPolozaji[i], metciVisine[i]+(height-polozajY)/5);
      metciPolozaji[i] += metciBrzine[i];
      if (metciPolozaji[i] > width+metak.width) //metak izašao iz ekrana
        avaiable[i] = true;
    }
  }
  //iscrtam raketu ako je ispaljena
  if (raketaDostupna == false)
  {
    image(raketa, raketaPolozaj, raketaVisina+(height-polozajY)/5);
    raketaPolozaj += brzinaRakete;
    if (raketaPolozaj > width+raketa.width) //raketa izašla iz ekrana
      raketaDostupna = true;
  }
}