Boolean kolizijaTempVarijabla;

//da bi mogao samo iz Paint-a pročitati koordinate svog lika
//bez da moram svaku posebno prilagođavati dimenziji i trenutnom položaju
void spaceshipPrilagodiKoordinateLika(float[] primljeneKoordinate, float polozajLikaX, float polozajLikaY, 
  float originalDimenzijaX, float originalDimenzijaY, float dimenzijaSadaX, float dimenzijaSadaY)
{
  for (int i=0; i<primljeneKoordinate.length; ++i)
  {
    if (i%2 == 0)
      primljeneKoordinate[i] = (primljeneKoordinate[i]/originalDimenzijaX)*dimenzijaSadaX + polozajLikaX - dimenzijaSadaX/2; 
    else //na parnim indeksima su x-koordinate, na neparnim indeksima su y-koordinate
    primljeneKoordinate[i] = (primljeneKoordinate[i]/originalDimenzijaY)*dimenzijaSadaY + polozajLikaY - dimenzijaSadaY/2;
  }
}



boolean detekcijaMetakBrod(float[] dobiveneKoordinate, int indeksDobivenogBroda/*-1 znači moj brod, -2 tenk*/, 
  float originalDimenzijaX, float originalDimenzijaY, int tipDobivenogMetka/*-1 znači moj metak, -2 bomba*/, int indeksDobivenogMetka)
{
  if (indeksDobivenogBroda >= 0) //znači neprijateljski brod
    spaceshipPrilagodiKoordinateLika(dobiveneKoordinate, polozajBroda[indeksDobivenogBroda], visinaBroda[indeksDobivenogBroda], 
      originalDimenzijaX, originalDimenzijaY, neprijatelji[tipoviBrodova[indeksDobivenogBroda]].width, 
      neprijatelji[tipoviBrodova[indeksDobivenogBroda]].height);
  else if (indeksDobivenogBroda == -1) //moj brod
  {
    spaceshipPrilagodiKoordinateLika(dobiveneKoordinate, polozajX, polozajY, 
      originalDimenzijaX, originalDimenzijaY, spaceship.width, 
      spaceship.height);
  } else if (indeksDobivenogBroda == -2) //tenk
  {
    spaceshipPrilagodiKoordinateLika(dobiveneKoordinate, polozajTenka, visinaTenka, 
      originalDimenzijaX, originalDimenzijaY, tenkTijelo[0].width, 
      tenkTijelo[0].height);
  }


  //detekcija kolizije - treba prilagoditi polje koje se šalje - prvo su koordinate središta metka
  //gledam samo dijelove unutar ekrana - sve negativne maknem td. dodam svima width (x koord.) i height (y koord.)
  int dimenzijaPoljaZaSlanje = dobiveneKoordinate.length + 2;

  if (dimenzijaPoljaZaSlanje < 8) //zbog kasnijeg poziva kolizijaKrugMnogokut (treba bar 8 elemenata polja)
    return false;

  float[] poljeZaSlanje = new float[dimenzijaPoljaZaSlanje];

  if (tipDobivenogMetka>=0) //znači neprijateljski metak
  {
    poljeZaSlanje[0] = polozajiNeprijateljskihMetaka[indeksDobivenogMetka];
    poljeZaSlanje[1] = visineNeprijateljskihMetaka[indeksDobivenogMetka]+(height-polozajY)/5;//poljednje jer su ostali pomaknuti s obz. na moj brod!
  } else if (tipDobivenogMetka==-1) //znači moj metak
  {
    poljeZaSlanje[0] = metciPolozaji[indeksDobivenogMetka];
    poljeZaSlanje[1] = metciVisine[indeksDobivenogMetka];
  } else if (tipDobivenogMetka==-2) //znači tenkova bomba
  {
    poljeZaSlanje[0] = bombaPolozajX;
    poljeZaSlanje[1] = bombaPolozajY+(height-polozajY)/5;
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
  if (tipDobivenogMetka >=0) //znači njihov metak
    polumjer = neprijateljskiMetak[tipoviNeprijateljskihMetaka[indeksDobivenogMetka]].width/2;
  else if (tipDobivenogMetka==-1) //za moj metak
    polumjer = metak.width/2;
  else //if(tipDobivenogMetka==-2) //znači tenkova bomba
  polumjer = bombaTenk.width/2;

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

int brZivotaIzgubljen = 0;
//je li netko pogodio moj brod - oduzmi jedan život
void detektirajGubitakZivota()
{
  for (int i=0; i<neprijateljskihMetakaDostupno; ++i)
  {
    if (avaiableEnemyBullets[i] == true) //za metke na ekranu
    {
      if ( detekcijaMetakBrod(new float[]{49, 124, 121, 58, 171, 39, 294, 38, 325, 48, 378, 84, 389, 109, 389, 201, 96, 201}, //tijelo broda igrača
        -1, 462, 247, tipoviNeprijateljskihMetaka[i], i) == true
        || detekcijaMetakBrod(new float[]{106, 201, 375, 201, 375, 215, 366, 233, 350, 247, 132, 246, 116, 235, 106, 215}, //top broda igrača
        -1, 462, 247, tipoviNeprijateljskihMetaka[i], i) == true
        || detekcijaMetakBrod(new float[]{389, 109, 461, 162, 461, 176, 389, 201}, //kljun broda igrača
        -1, 462, 247, tipoviNeprijateljskihMetaka[i], i) == true
        || detekcijaMetakBrod(new float[]{47, 25, 94, 25, 138, 51, 63, 104}, //rep broda igrača
        -1, 462, 247, tipoviNeprijateljskihMetaka[i], i) == true
        || detekcijaMetakBrod(new float[]{16, 0, 96, 0, 102, 3, 106, 8, 106, 16, 102, 21, 97, 24, 15, 24, 9, 21, 5, 16, 5, 9, 9, 4}, //zakrilce broda igrača
        -1, 462, 247, tipoviNeprijateljskihMetaka[i], i) == true)
      {
        avaiableEnemyBullets[i] = false; //metak se više ne crta
        //println("izgubio život: " + (brZivotaIzgubljen++));
        --brZivota;
      }
    }
  }

  //pogodio ga tenk
  if (bombaIspaljena == true)
  {
    if ( detekcijaMetakBrod(new float[]{49, 124, 121, 58, 171, 39, 294, 38, 325, 48, 378, 84, 389, 109, 389, 201, 96, 201}, //tijelo broda igrača
      -1, 462, 247, -2, 0) == true
      || detekcijaMetakBrod(new float[]{106, 201, 375, 201, 375, 215, 366, 233, 350, 247, 132, 246, 116, 235, 106, 215}, //top broda igrača
      -1, 462, 247, -2, 0) == true
      || detekcijaMetakBrod(new float[]{389, 109, 461, 162, 461, 176, 389, 201}, //kljun broda igrača
      -1, 462, 247, -2, 0) == true
      || detekcijaMetakBrod(new float[]{47, 25, 94, 25, 138, 51, 63, 104}, //rep broda igrača
      -1, 462, 247, -2, 0) == true
      || detekcijaMetakBrod(new float[]{16, 0, 96, 0, 102, 3, 106, 8, 106, 16, 102, 21, 97, 24, 15, 24, 9, 21, 5, 16, 5, 9, 9, 4}, //zakrilce broda igrača
      -1, 462, 247, -2, 0) == true)
    {
      bombaIspaljena = false; //bomba se više ne crta
      //println("pogođen bombom: " + (brZivotaIzgubljen++));
      --brZivota;
    }
  }
}

void detektirajUnistenjeNeprijateljskogBroda()
{
  //pogledaj za svaki moj metak/raketu i njihov brod
  for (int i=0; i<ukupnoNeprijateljskihBrodova; ++i) //za svaki neprijateljski brod
  {
    if (trenutnoAktivniBrodovi[i] == true) //samo za one brodove koji još postoje
    {
      for (int j=0; j < ukupnoMetakaDostupno; ++j) //za svaki moj metak
      {
        if (avaiable[j] == false) //samo za ispucane metke
        { 
          if (tipoviBrodova[i] == 0)
          {
            //gornje krilo broda --- koordinate iz Paint-a, za konveksni dio, u smjeru kazaljke na satu
            if ( detekcijaMetakBrod(new float[]{0, 91, 12, 58, 46, 31, 117, 0, 175, 0, 239, 19, 157, 77, 117, 89}, 
              i, 239, 221, -1, j) == true ) //-1 znači naš metak
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 5;
            }

            //donje krilo broda
            else if ( detekcijaMetakBrod(new float[]{0, 129, 117, 132, 157, 143, 239, 202, 175, 221, 117, 221, 46, 190, 12, 161}, 
              i, 239, 221, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 5;
            }

            //trup broda
            else if ( detekcijaMetakBrod(new float[]{10, 116, 10, 105, 32, 93, 117, 89, 148, 99, 148, 122, 117, 132, 32, 128}, 
              i, 239, 221, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 5;
            }

            //rep broda
            else if ( detekcijaMetakBrod(new float[]{148, 122, 148, 99, 216, 104, 227, 108, 227, 112, 218, 115}, 
              i, 239, 221, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 5;
            }
          } else if (tipoviBrodova[i] == 1)
          {
            //trup borda
            if ( detekcijaMetakBrod(new float[]{0, 180, 16, 166, 60, 145, 119, 131, 190, 131, 240, 156, 285, 180, 240, 204, 190, 230, 119, 230, 60, 216, 16, 194}, 
              i, 285, 362, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 10;
            }

            //gornji dio gornjeg krila
            else if ( detekcijaMetakBrod(new float[]{117, 59, 150, 33, 160, 28, 188, 17, 257, 0, 184, 84}, 
              i, 285, 362, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 10;
            }

            //donji dio gornjeg krila
            else if ( detekcijaMetakBrod(new float[]{62, 115, 117, 65, 184, 84, 237, 133}, 
              i, 285, 362, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 10;
            }

            //gornje zakrilce
            else if ( detekcijaMetakBrod(new float[]{160, 28, 156, 8, 171, 1, 188, 17}, 
              i, 285, 362, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 10;
            }

            //gornji dio donjeg krila
            else if ( detekcijaMetakBrod(new float[]{62, 245, 237, 227, 184, 275, 117, 294}, 
              i, 285, 362, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 10;
            }

            //donji dio donjeg krila
            else if ( detekcijaMetakBrod(new float[]{117, 301, 184, 275, 257, 360, 188, 344, 150, 326}, 
              i, 285, 362, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 10;
            }

            //donje zakrilce
            else if ( detekcijaMetakBrod(new float[]{159, 331, 188, 344, 172, 359, 156, 352}, 
              i, 285, 362, -1, j) == true )
            {
              avaiable[j] = true;
              trenutnoAktivniBrodovi[i] = false;
              spaceshipDodajEksploziju(polozajBroda[i], visinaBroda[i]);
              spaceshipBrojBodova += 10;
            }
          }
        }
      }
    }
  }
}


void detektirajPogodakTenka()
{
  for (int j=0; j < ukupnoMetakaDostupno; ++j) //za svaki moj metak
  {
    if (avaiable[j] == false) //samo za ispucane metke
    { 
      //glava tenka ili tijelo tenka
      if ( detekcijaMetakBrod(new float[]{76, 73, 76, 50, 81, 30, 90, 12, 105, 0, 160, 0, 176, 15, 187, 72}, 
        -2, 281, 267, -1, j) == true
        || detekcijaMetakBrod(new float[]{61, 82, 203, 82, 239, 115, 234, 230, 216, 266, 0, 38, 266, 12, 251, 218, 13, 150}, 
        -2, 281, 267, -1, j) == true) //-1 znači naš metak
      {
        avaiable[j] = true; //ukloni metak
        --tenkLives;
      }
    }
  }

  if (tenkLives <=0)
  {
    //malo veća eksplozija za tenk (tj. tri male eksplozije)
    spaceshipDodajEksploziju(polozajTenka, visinaTenka+tenkTijelo[0].height/4);
    spaceshipDodajEksploziju(polozajTenka-tenkTijelo[0].width/4, visinaTenka-tenkTijelo[0].height/4);
    spaceshipDodajEksploziju(polozajTenka+tenkTijelo[0].width/4, visinaTenka-tenkTijelo[0].height/4);
    polozajTenka = 4*width;
    spaceshipBrojBodova += 50; //za uništenje tenka dobiva se 50 bodova
    tenkLives = maxTenkLives;
  }
}




//provjerava nalazi li se tocka s koordinatama (tockaX, tockaY)
//unutar kruga sa sredistem u (centarX, centarY) polumjera polumj
boolean tockaUnutarKruga(float tockaX, float tockaY, float centarX, float centarY, float polumj)
{
  if ( pow(centarX-tockaX, 2) + pow(centarY-tockaY, 2) <= polumj*polumj )
  {
    return true;
  }

  return false;
}

boolean sIsteStranePravca(float p1x, float p1y, float v1x, float v1y, 
  float v2x, float v2y, float v3x, float v3y)
{
  float stranaZaVrh3 = ((v2y-v1y)/(v2x-v1x))*(v3x-v1x)+v1y-v3y;
  float stranaZaTocku = ((v2y-v1y)/(v2x-v1x))*(p1x-v1x)+v1y-p1y;

  if (stranaZaVrh3 <= 0 && stranaZaTocku <= 0)
    return true;
  else if (stranaZaVrh3 > 0 && stranaZaTocku > 0)
    return true;
  else
    return false;
}

//tocke za neki lik se navode u smjeru kazaljke na satu
//TODO: throws Exception ... if(sve tri točke leže na istom pravcu)
boolean tockaUnutarTrokuta(float p1x, float p1y, float v1x, float v1y, 
  float v2x, float v2y, float v3x, float v3y)
{
  if (sIsteStranePravca(p1x, p1y, v1x, v1y, v2x, v2y, v3x, v3y) == false)
    return false;
  else if (sIsteStranePravca(p1x, p1y, v2x, v2y, v3x, v3y, v1x, v1y) == false)
    return false;
  else if (sIsteStranePravca(p1x, p1y, v1x, v1y, v3x, v3y, v2x, v2y) == false)
    return false;
  else
    return true;
}


//lista floatova - X koordinata prve tocke, Y koordinata prve tocke, X koordinata druge tocke, ...
//prva dva floata su za koordinate točke koju provjeravamo!
boolean tockaUnutarLika(float[] koordinate) throws Exception
{  
  if (koordinate.length %2 == 1)
    throw new Exception("tockaUnutarLika: Proslijeđen krivi broj parametara funkciji tockaUnutarLika!");
  else if (koordinate.length < 8)
    throw new Exception("tockaUnutarLika: Funkcija tockaUnutarLika radi za bar 8 parametara (2 za točku i 6 za trokut)!");
  else
  {
    for (int i = 2; 2*i+3+2 < koordinate.length; ++i)
    {
      if (tockaUnutarTrokuta( koordinate[0], koordinate[1], koordinate[2], koordinate[3], 
        koordinate[2*i], koordinate[2*i+1], koordinate[2*i+2], koordinate[2*i+3]) == true)
      {
        //println("testUnutarLika"+i);
        return true;
      }
    }
    if (tockaUnutarTrokuta( koordinate[0], koordinate[1], 
      koordinate[koordinate.length-4], koordinate[koordinate.length-3], 
      koordinate[koordinate.length-2], koordinate[koordinate.length-1], 
      koordinate[2], koordinate[3]) == true)
    {
      //println("testUnutarLikaZadnji"+koordinate.length);
      return true;
    }
  }
  return false;
}


//je li tocka (tockaX, tockaY) unutar pravokutnika stranice udaljenost*2
//oko stranice (prvaX, prvaY) -- (drugaX, drugaY)
boolean unutarOkolineStranice(float tockaX, float tockaY, 
  float prvaX, float prvaY, float drugaX, float drugaY, float udaljenost)
{
  float vektorX, vektorY;
  vektorX = drugaX - prvaX;
  vektorY = drugaY - prvaY;

  float a1, a2;

  if (vektorX != 0)
  {
    a2 = sqrt( pow(udaljenost, 2) / (1 + pow(vektorY, 2)/pow(vektorX, 2)) );
    a1 = -( (vektorY*a2) / vektorX );
    try {
      return tockaUnutarLika(new float[]{tockaX, tockaY, prvaX+a1, prvaY+a2, drugaX+a1, drugaY+a2, drugaX-a1, drugaY-a2, prvaX-a1, prvaY-a2});
    } 
    catch(Exception e)
    {  
      //println(e);
      exit();
    }
  } else if (vektorY != 0)
  {
    a1 = sqrt( pow(udaljenost, 2) / (1 + pow(vektorX, 2)/pow(vektorY, 2)) );
    a2 = -( (vektorY*a1) / vektorX );
    try {
      return tockaUnutarLika(new float[]{tockaX, tockaY, prvaX+a1, prvaY+a2, drugaX+a1, drugaY+a2, drugaX-a1, drugaY-a2, prvaX-a1, prvaY-a2});
    } 
    catch(Exception e)
    {  
      //println(e);
      exit();
    }
  } else //nulvektor, tj. tocke iste
  return tockaUnutarKruga(tockaX, tockaY, prvaX, prvaY, udaljenost);

  return false;
}


//kao gore, s dodatnim argumentom (polumjer kruga)
boolean kolizijaKrugMnogokut(float[] koordinate, float polumj) throws Exception
{
  if (koordinate.length %2 == 1)
    throw new Exception("kolizijaKrugMnogokut: Proslijeđen krivi broj parametara funkciji tockaUnutarLika!");
  else if (koordinate.length < 8)
    throw new Exception("kolizijaKrugMnogokut: Funkcija tockaUnutarLika radi za bar 8 parametara (2 za točku i 6 za trokut)!");
  else if (polumj <= 0)
    throw new Exception("kolizijaKrugMnogokut: Polumjer kruga mora biti nenegativan!");
  else
  {
    if (tockaUnutarLika(koordinate) == true)
    {
      //println("testUnutarLika");
      return true;
    } else {
      for (int i=1; 2*i+1<koordinate.length; ++i)
      {
        if (tockaUnutarKruga(koordinate[2*i], koordinate[2*i+1], koordinate[0], koordinate[1], polumj) == true)
        {
          //println("testUnutarKruga"+i);
          return true;
        }
      }
      for (int i=1; 2*i+3<koordinate.length; ++i)
      {
        if (unutarOkolineStranice(koordinate[0], koordinate[1], koordinate[2*i], koordinate[2*i+1], koordinate[2*i+2], koordinate[2*i+3], polumj ) == true)
        {
          //println("testUnutarStranice"+i);
          return true;
        }
      }
      if (unutarOkolineStranice(koordinate[0], koordinate[1], koordinate[koordinate.length-2], koordinate[koordinate.length-1], koordinate[2], koordinate[3], polumj ) == true)
      {
        //println("testUnutarZadnje");
        return true;
      }
    }
  }

  return false;
}