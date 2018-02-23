PImage tenkCijev, bombaTenk, tenkShield;
PImage[] tenkTijelo = new PImage[3];
int skinTenkaNaRedu = 0;

int tenkLives = 10, maxTenkLives = 10; //koliko je tenku preostalo života

int polozajTenka, visinaTenka, krajnjiPolozajTenka; //visina je uvijek ista jer tenk ide po zemlji
float visinaCijevi, polozajCijevi; //pomoćne varijable, kasnije kod translacije i rotacije cijevi

Boolean bombaIspaljena;
float bombaBrzinaX, bombaBrzinaY;
float bombaPolozajX, bombaPolozajY;

int brzinaBombe;

void crtajBombu()
{
  if (bombaIspaljena == true) //crtam bombu samo ako je ispaljena (tj. treba biti na ekranu)
  {
    image(bombaTenk, bombaPolozajX, bombaPolozajY+(height-polozajY)/5);

    bombaPolozajX += bombaBrzinaX;
    bombaPolozajY += bombaBrzinaY;

    if (bombaPolozajX < -bombaTenk.width/2)
    {
      //bomba izašla iz ekrana, više ju ne crtaj
      bombaIspaljena = false;
    }
  }
}

void ucitajTenk() //učitava i tenk i bombu
{
  for (int i=0; i<3; ++i)
  {
    tenkTijelo[i]=loadImage("tenkTijelo"+i+".png");
    tenkTijelo[i].resize(width/5, height/3);
  }

  tenkCijev=loadImage("tenkCijev.png");
  tenkCijev.resize(int(tenkTijelo[0].width/2), int(tenkTijelo[0].height/6));

  tenkShield=loadImage("tenkShield.png");
  tenkShield.resize(3*tenkTijelo[0].width/2, 3*tenkTijelo[0].height/2);

  bombaTenk=loadImage("bomb.png");
  bombaTenk.resize(2*tenkCijev.height/3, 2*tenkCijev.height/3);

  polozajTenka = width*4;
  krajnjiPolozajTenka = 19*width/20-tenkTijelo[0].width/2;
  visinaTenka = height-15-tenkTijelo[0].height/2;

  bombaIspaljena = false;
}

void crtajTenk()
{
  if (frameCount % 2 == 0)
    skinTenkaNaRedu = (++skinTenkaNaRedu)%3;

  //crtanje cijevi koja cilja brod
  pushMatrix(); //cijev rotiram pa zato push i pop (da ostalo ne bude rotirano) (i zbog translacije)

  //rotira se ishodište, a ja rotiram cijev pa treba cijev u ishodište (ishodište u desni rub cijevi)
  visinaCijevi  = visinaTenka-0.35*tenkTijelo[0].height+(height-polozajY)/5;
  polozajCijevi = polozajTenka-0.34*tenkTijelo[0].width+tenkCijev.width/2;
  translate(polozajCijevi, visinaCijevi);

  //x = polozajCijevi - polozajX (gdje je polozaj X polozaj broda)
  //y = visinaCijevi - polozajY  (gdje je polozaj Y visina broda)
  //kut cijevi je (u radijanima) arcus tangens od y/x
  float kut = atan((visinaCijevi-polozajY)/(polozajCijevi-polozajX));
  rotate(kut);
  image(tenkCijev, -tenkCijev.width/2, 0);

  popMatrix();

  //svakih 100 frameova ispali bombu (ako već nije)
  if (polozajTenka<width && frameCount%100 == 0 && bombaIspaljena == false)
  {
    bombaIspaljena = true;

    bombaPolozajX = polozajCijevi-tenkCijev.width*cos(kut);
    bombaPolozajY = visinaCijevi - (polozajCijevi-bombaPolozajX)*tan(kut)-(height-polozajY)/5;

    bombaBrzinaX = -brzinaBombe;
    bombaBrzinaY = -brzinaBombe*(bombaPolozajY+(height-polozajY)/5 - polozajY)/(bombaPolozajX - polozajX);
  }

  image(tenkTijelo[skinTenkaNaRedu], polozajTenka, visinaTenka+(height-polozajY)/5);
  crtajBombu();

  //nacrtati život tenka
  rectMode(CENTER);
  fill(0);
  rect(polozajTenka+7*tenkTijelo[0].width/12, 
    visinaTenka+(height-polozajY)/5, 
    tenkTijelo[0].width/10, 
    2*tenkTijelo[0].height/3);
  fill(160, 0, 0);
  rect(polozajTenka+7*tenkTijelo[0].width/12, 
    visinaTenka+(height-polozajY)/5, 
    tenkTijelo[0].width/10, 
    tenkLives*2*tenkTijelo[0].height/3/maxTenkLives);
  strokeWeight(3);
  if (polozajTenka > krajnjiPolozajTenka)//crtam štit oko tenka
  {
    image(tenkShield, polozajTenka, visinaTenka+(height-polozajY)/5);
    polozajTenka -= osnovnaBrzinaBroda*10;
  }
}