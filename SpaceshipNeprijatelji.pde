int ukupnoVrstaNeprijatelja = 2;
PImage[] neprijatelji = new PImage[ukupnoVrstaNeprijatelja];

int ukupnoNeprijateljskihBrodova = 20;
//ako je trenutnoAktivniBrodovi[i] true, brod se crta i aktivan je u igri
Boolean[] trenutnoAktivniBrodovi = new Boolean[ukupnoNeprijateljskihBrodova];
int[] tipoviBrodova = new int[ukupnoNeprijateljskihBrodova];
int[] polozajBroda = new int[ukupnoNeprijateljskihBrodova];
int[] visinaBroda = new int[ukupnoNeprijateljskihBrodova];
int[] brzineBrodova = new int[ukupnoNeprijateljskihBrodova];
int[] vrijemeDoIspaljivanjaMetka = new int[ukupnoNeprijateljskihBrodova];
int[] vertikalniSmjerKretanja = new int[ukupnoNeprijateljskihBrodova]; //ako brod ide prema gore ili dolje
int vrijemeDoNovogBroda;
float osnovnaBrzinaBroda;

void ucitajNeprijatelje()
{
  for (int i=0; i<ukupnoVrstaNeprijatelja; ++i)
  {
    neprijatelji[i] = loadImage("enemy"+i+".png");
    if (i==0)
      neprijatelji[i].resize(width/14, height/7);
    else //if(i==1)
    neprijatelji[i].resize(width/10, height/5);
  }

  //na početku nema neprijateljskih brodova
  for (int i=0; i<ukupnoNeprijateljskihBrodova; ++i)
  {
    trenutnoAktivniBrodovi[i] = false;
  }

  vrijemeDoNovogBroda = 100;
}



void kontrolaNeprijatelja()
{
  if (vrijemeDoNovogBroda == 0)
  {
    if (random(1, 10)>8)
    {
      dodajNeprijatelja(1);
    } else
      dodajNeprijatelja(0);
  }

  if (vrijemeDoNovogBroda > 0)
    --vrijemeDoNovogBroda;
  else
    vrijemeDoNovogBroda = int(random(10, 100));

  crtajSveNeprijatelje();
}



void dodajNeprijatelja(int tip)
{
  for (int i=0; i<ukupnoNeprijateljskihBrodova; ++i)
  {
    if (trenutnoAktivniBrodovi[i] == false)
    {
      trenutnoAktivniBrodovi[i] = true; //aktivirali smo brod (tj. crtat će se)
      tipoviBrodova[i] = tip;
      polozajBroda[i] = width + neprijatelji[tip].width/2;
      visinaBroda[i] = int(random(neprijatelji[tip].height/2, height-neprijatelji[tip].height/2));
      vrijemeDoIspaljivanjaMetka[i] = int(random(5, 30));
      brzineBrodova[i] = int((20.0-2.0*tip)*osnovnaBrzinaBroda);
      if (tip==1)
      {
        if (random(1, 10)>5)
          vertikalniSmjerKretanja[i] = 1; //gore
        else
          vertikalniSmjerKretanja[i] = -1; //dolje
      }

      i=ukupnoNeprijateljskihBrodova; //ovo prekida for petlju
    }
  }
}


void crtajSveNeprijatelje()
{
  for (int i=0; i<ukupnoNeprijateljskihBrodova; ++i)
  {
    if (trenutnoAktivniBrodovi[i] == true)
    {
      brzineBrodova[i] = int((20.0-2.0*tipoviBrodova[i])*osnovnaBrzinaBroda);
    }
  }

  for (int i=0; i<ukupnoNeprijateljskihBrodova; ++i)
  {
    if (trenutnoAktivniBrodovi[i] == true)
    {
      image(neprijatelji[tipoviBrodova[i]], polozajBroda[i], visinaBroda[i]+(height-polozajY)/5);
      polozajBroda[i] -= brzineBrodova[i];

      if (tipoviBrodova[i] == 1)
      {
        visinaBroda[i] -= vertikalniSmjerKretanja[i]*brzineBrodova[i]/2;
        if (visinaBroda[i] < -neprijatelji[tipoviBrodova[i]].height/2) 
          vertikalniSmjerKretanja[i] = (-1);
        else if (visinaBroda[i] > height-neprijatelji[tipoviBrodova[i]].height/2)
          vertikalniSmjerKretanja[i] = 1;
      }

      if (vrijemeDoIspaljivanjaMetka[i]==0)
        ispaliNeprijateljskiMetak(polozajBroda[i], visinaBroda[i], tipoviBrodova[i]);

      if (vrijemeDoIspaljivanjaMetka[i] > 0)
        --vrijemeDoIspaljivanjaMetka[i];
      else
        vrijemeDoIspaljivanjaMetka[i] = int(random(50, 200));

      if (polozajBroda[i] < -neprijatelji[tipoviBrodova[i]].width/2) //brod izašao iz ekrana
        trenutnoAktivniBrodovi[i] = false; //ne crtaj više taj brod
    }
  }
}