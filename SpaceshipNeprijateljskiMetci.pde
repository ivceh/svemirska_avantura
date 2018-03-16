int brojVrstaNeprijateljskihMetaka = 2;
PImage[] neprijateljskiMetak = new PImage[brojVrstaNeprijateljskihMetaka];

int brzinaMetakaNeprijatelja;
int neprijateljskihMetakaDostupno = 40;

Boolean[] avaiableEnemyBullets = new Boolean[neprijateljskihMetakaDostupno]; //crta li se metak ili ne (true ili false)
int[] visineNeprijateljskihMetaka = new int[neprijateljskihMetakaDostupno];
int[] polozajiNeprijateljskihMetaka = new int[neprijateljskihMetakaDostupno];
int[] tipoviNeprijateljskihMetaka = new int[neprijateljskihMetakaDostupno];
int[] smjerNeprijateljskihMetaka =  new int[neprijateljskihMetakaDostupno]; //1 je gore, a -1 je dolje, 0 je ravno


void ucitajNeprijateljskeMetke()
{
  for (int i=0; i<brojVrstaNeprijateljskihMetaka; ++i)
  {
    neprijateljskiMetak[i] = loadImage("enemyBullet"+i+".png");
    if (i==0)
    {
      neprijateljskiMetak[i].resize(width/30, width/30);
    } else if (i==1)
    {
      neprijateljskiMetak[i].resize(width/40, width/40);
    }
  }

  for (int i=0; i<neprijateljskihMetakaDostupno; ++i)
    avaiableEnemyBullets[i] = false;
}



void ispaliNeprijateljskiMetak(int polozajIspaljivanja, int visinaIspaljivanja, int tipMetka)
{
  //preostalo za ispalu treba jer žuti avioni ispaljuju 3 metak
  int smjerIspaleMetka=1, preostaloZaIspalu=3; //smjer metak (1 gore, 0 ravno, -1 dolje)

  for (int i=0; i<neprijateljskihMetakaDostupno; ++i)
  {
    if (preostaloZaIspalu == 0) { //ako nemaš što ispaliti prekini
      return;
    }

    if (avaiableEnemyBullets[i] == false) //ima neki dostupan metak koji se ne crta
    {
      visineNeprijateljskihMetaka[i] = visinaIspaljivanja;
      polozajiNeprijateljskihMetaka[i] = polozajIspaljivanja;
      avaiableEnemyBullets[i] = true; //metak se od sada crta
      tipoviNeprijateljskihMetaka[i] = tipMetka;
      if (tipMetka==1 && preostaloZaIspalu>0)
      {
        smjerNeprijateljskihMetaka[i] = smjerIspaleMetka;
        --smjerIspaleMetka;
        --preostaloZaIspalu;
      } else { //ako tip metka 0 (1 več ispalili) ili nema više što za ispalu
        return;
      }
    }
  }
}



void crtajNeprijateljskeMetke()
{
  for (int i=0; i<neprijateljskihMetakaDostupno; ++i)
  {
    if (avaiableEnemyBullets[i] == true)
    {
      image(neprijateljskiMetak[tipoviNeprijateljskihMetaka[i]], polozajiNeprijateljskihMetaka[i], visineNeprijateljskihMetaka[i]+(height-polozajY)/5);
      polozajiNeprijateljskihMetaka[i] -= brzinaMetakaNeprijatelja;

      if (tipoviNeprijateljskihMetaka[i]==1)
      {
        visineNeprijateljskihMetaka[i] += (smjerNeprijateljskihMetaka[i]*brzinaMetakaNeprijatelja/3);
      }

      if (polozajiNeprijateljskihMetaka[i]<neprijateljskiMetak[tipoviNeprijateljskihMetaka[i]].width/2)
        avaiableEnemyBullets[i] = false;  //metak izašao iz ekrana, više ga ne crtaj
    }
  }
}