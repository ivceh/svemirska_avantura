import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioInput input;
//AudioMetaData meta;

int uvodBrzinaPrikaza; //koliko se brzo uvod prikazuje
//slike koje se koriste u uvodu
PImage uvodSlikaBoja, uvodSlikaVideo, uvodSlikaTekst, uvodSlikaZvuk;
int uvodStartTime; //vrijeme kad je pokrenut uvod (u milisekundama)

//koliko je krug velik na početku, te kasnije u programu (treba zbog smanjivanja veličine)
//pomak treba kasnije kad krug ide prema gore
float uvodPocetniPromjerKruga, uvodPromjerKruga, uvodPomakKruga;

boolean uvodRotacijaKruga; //true ako se krug rotira, false ako se ne rotira
float uvodTranX, uvodTranY; //translatacija potrebna kod rotacije (koordinate novog ishodišta)

int  uvodKutRotacije; //kod rotacije, za koji kut se krug zarotira (u stupnjevima, smjer kaz. na satu)
int[] uvodBrojacZaOdsjecke = new int[4]; //ovo će pratiti koliki dio kojeg odsječka (1 do 4) treba iscrtati

int uvodVrijemeZaPauzu, uvodVrijemeZaPauzu2; //služi kasnije za mali predah nakon iscrtavanja, tj. rotacije, kruga

//riječi za ispis - slova se ispisuju jedno po jedno pa pamti koje je slovo na redu
String uvodMultimedijski = "MULTIMEDIJSKI", uvodSustavi = "SUSTAVI";
int uvodSlovoNaRedu;


void introPocetnePostavke()
{
  //ispiši loading...
  background(0); //crna pozadina
  textSize( (width < height) ? width/20 : height/20); //veličina slova za loading...
  fill(255); //slova (tj. znakovi) u loading... su bijele boje
  textAlign(CENTER, CENTER); //tekst je horizontalno i vertikalno centriran
  text("loading...", width/2, height/2); //tekst loading... se ispisuje na sredini ekrana

  //učitaj sve potrebne slike
  uvodSlikaBoja = loadImage("color.png");
  uvodSlikaVideo = loadImage("video.png"); 
  uvodSlikaTekst = loadImage("letter.png");
  uvodSlikaZvuk = loadImage("sound.png");

  //učitaj glazbu i pokreni je
  try {
    minim = new Minim(this);
    player = minim.loadFile("TimmyTrumpetMantra.mp3");
    input = minim.getLineIn();
    //meta = player.getMetaData();
    player.play();
  } 
  catch (Exception e) {
  }
  
  uvodBrzinaPrikaza = 4; //brzina kojom se uvod prikazuje

  for (int j=0; j<4; ++j) //na kojem kutu koji odsječak počinje (1. na -90, 2. na 0, 3. na 90, 4. na 180)
  {
    uvodBrojacZaOdsjecke[j] = -90 + j*90; 
  }

  uvodStartTime = millis(); //vrijeme kad je pokrenut uvoda postavljeno (u milisekundama)
  uvodPromjerKruga = 0; //na početku krug nije nacrtan (tj. promjera 0)
  uvodPomakKruga = 0; //na početku se krug ne miče
  uvodRotacijaKruga = false; //na početku se krug ne rotira
  uvodTranX = 0; //na početku nema translacije, tj. koordinate ishodišta su i dalje (0,0)
  uvodTranY = 0;
  uvodKutRotacije = 0; //krug na početku nije rotiran (tj. rotiran je za 0 stupnjeva)
  uvodVrijemeZaPauzu = 50; //služi kasnije za mali predah nakon iscrtavanja, tj. rotacije, kruga
  uvodVrijemeZaPauzu2 = 50;
  uvodSlovoNaRedu = 0; //koje je slovo na redu u ispisu riječi "Multimedijski" i "sustavi"
}


void crtanjeUvoda()
{
  while ( millis() - uvodStartTime < 2000 ); //malo loadinga
  background(0); //crna pozadina na početak (da prekrije ono što je prethodno iscrtano)

  int uvodVelicinaSlike;
  if (uvodPromjerKruga == 0) //ako je promjer kruga 0 znači da se još nije crtao
  {
    //krug mora biti takav da stane na ekran, znači malo manji od manje dimenzije ekrana
    uvodPromjerKruga = 0.95 * ((width < height) ? width : height);
    uvodPocetniPromjerKruga = uvodPromjerKruga; //zabilježi taj početni promjer kruga

    //radimo resize slika (moraju stati u pripadnu četvrtinu kruga)
    //duljina stranice slike (kvadrata) je td. je duljina dijagonale polumjer kruga
    uvodVelicinaSlike = int(0.90*(uvodPromjerKruga/2.0)/sqrt(2));
    uvodSlikaBoja.resize(uvodVelicinaSlike, uvodVelicinaSlike); //sve slike su kvadratnog oblika
    uvodSlikaVideo.resize(uvodVelicinaSlike, uvodVelicinaSlike);
    uvodSlikaTekst.resize(uvodVelicinaSlike, uvodVelicinaSlike);
    uvodSlikaZvuk.resize(uvodVelicinaSlike, uvodVelicinaSlike);
  } 


  if (uvodRotacijaKruga == true) //ako se krug treba rotirati
  {
    pushMatrix(); //zapamti prethodno stanje (ekran bez rotacija i translacija)

    //krug se treba rotirati oko središta kruga, pa se prvo treba translatirati
    //u središte kruga (jer rotacije idu oko trenutnog ishodišta)
    uvodTranX = width/2; //središte kruga je na sredini ekrana,
    uvodTranY = height/2-uvodPomakKruga; //eventualno (ako se krug pomiče prema gore) pomaknuto za taj pomak
    translate(uvodTranX, uvodTranY); //pomakni se u središte kružnice
    uvodKutRotacije += uvodBrzinaPrikaza*3; //koliko se brzo krug rotira
    if (uvodKutRotacije >= 720) //uvod je gotov kad se krug dva puta zarotira (2*360)
    {
      //exit();
      ++stanjeIgre; // tj. stanjeIgre == 1 --> prelazimo na glavni izbornik
    }
    rotate(radians(uvodKutRotacije)); //rotiram krug od početnog položaja za uvodKutRotacije (konv. u radijane!)
  } else //ako nema rotacije, nema ni potrebe translatirati (stoga je ishodište i dalje u (0,0)
  {
    uvodTranX = 0;
    uvodTranY = 0;
  }

  //crtam crveni, plavi, zeleni i žuti odsječak
  //iscrtam onolik dio pojedinog odsječka koliki bi sad trebao biti na redu
  uvodCrtajOdsjecak(color(255, 0, 0), 0); //crvena
  if (uvodBrojacZaOdsjecke[0] >= 0)
    uvodCrtajOdsjecak(color(0, 0, 255), 2); //plava
  if (uvodBrojacZaOdsjecke[2] >= 180)  
    uvodCrtajOdsjecak(color(0, 255, 0), 1); //zelena
  if (uvodBrojacZaOdsjecke[1] >= 90)
    uvodCrtajOdsjecak(color(255, 255, 0), 3); //žuta
  if (uvodBrojacZaOdsjecke[3] >= 270 && uvodVrijemeZaPauzu > 0)
    uvodVrijemeZaPauzu -= uvodBrzinaPrikaza; //malo se čeka nakon tih iscrtavanja

  //veličina slike td. stane u krug (koji se sad smanjuje)
  uvodVelicinaSlike = int(0.90*(uvodPromjerKruga/2.0)/sqrt(2));
  if (uvodVrijemeZaPauzu <= 0) //nakon pauze (od iscrtavanja kruga)
  {
    if (uvodPomakKruga < uvodPocetniPromjerKruga/6) //pomiče se gore do uvodPocetniPromjerKruga/6
    {
      uvodPomakKruga += uvodBrzinaPrikaza; //pomakni krug gore
      uvodPromjerKruga -= 2.5*uvodBrzinaPrikaza; //smanji krug
      uvodVelicinaSlike = int(0.90*(uvodPromjerKruga/2.0)/sqrt(2));

      //resize slika td. stanu u (sad malo manji) krug
      uvodSlikaBoja.resize(uvodVelicinaSlike, uvodVelicinaSlike);
      uvodSlikaVideo.resize(uvodVelicinaSlike, uvodVelicinaSlike);
      uvodSlikaTekst.resize(uvodVelicinaSlike, uvodVelicinaSlike);
      uvodSlikaZvuk.resize(uvodVelicinaSlike, uvodVelicinaSlike);
    } else if (uvodVrijemeZaPauzu2 > 0) //ako smo gotovi u pauzi smo prije rotiranja kruga
      uvodVrijemeZaPauzu2 -= uvodBrzinaPrikaza;
  }

  imageMode(CORNER);

  //crtamo sve slike u pripadnim četvrtinama kruga
  image(uvodSlikaBoja, width/1.95-uvodTranX, height/2.05-uvodPomakKruga-uvodVelicinaSlike-uvodTranY);
  image(uvodSlikaVideo, width/1.95-uvodTranX, height/1.95-uvodPomakKruga-uvodTranY);
  image(uvodSlikaTekst, width/2.05-uvodVelicinaSlike-uvodTranX, height/1.95-uvodPomakKruga-uvodTranY);
  image(uvodSlikaZvuk, width/2.05-uvodVelicinaSlike-uvodTranX, height/2.10-uvodPomakKruga-uvodVelicinaSlike-uvodTranY);


  if (uvodRotacijaKruga == true) //ako je bilo rotacije bilo je i pushMatrix, zato sad popMatrix
  {
    popMatrix();
  }

  textAlign(CENTER);

  if (uvodVrijemeZaPauzu2 <= 0) //druga pauza odrađena, nastavi sa tekstom
  {
    //ispis slovo po slovo, komad riječi koji se ispisuje je u uvodIspisRijeci
    //ako je slovo na redu veće od 12, tada se ispiše cijela riječ MULTIMEDIJSKI
    String uvodIspisRijeci = uvodMultimedijski.substring(0, (uvodSlovoNaRedu >= 13)? 13 : uvodSlovoNaRedu);

    //ispisuju se siva (iza) i bijela (ispred) slova
    textSize(uvodPocetniPromjerKruga/10);
    fill(100);
    text(uvodIspisRijeci, 0.5*width, 0.8*height);
    fill(255);
    text(uvodIspisRijeci, 0.5*width+5, 0.8*height);

    //sljedeći put ispiši slovo više (ali ne prebrzo: frameCount % (10/uvodBrzinaPrikaza))
    if (uvodSlovoNaRedu < uvodMultimedijski.length() && frameCount % (10/uvodBrzinaPrikaza) == 0)
      ++uvodSlovoNaRedu;
  }

  if (uvodSlovoNaRedu >= uvodMultimedijski.length())
  {
    String uvodIspisRijeci = uvodSustavi.substring(0, uvodSlovoNaRedu % uvodMultimedijski.length());
    textSize(uvodPocetniPromjerKruga/8);
    fill(100);
    text(uvodIspisRijeci, 0.5*width, 0.95*height);
    fill(255);
    text(uvodIspisRijeci, 0.5*width+5, 0.95*height);
    //idi na sljedeće slovo (ali ne prebrzo)
    if (uvodSlovoNaRedu < uvodSustavi.length() + uvodMultimedijski.length() && frameCount % (15/uvodBrzinaPrikaza) == 0)
      ++uvodSlovoNaRedu;
    else if (uvodSlovoNaRedu >= uvodSustavi.length() + uvodMultimedijski.length()) //tekst ispisan, pokreni rotaciju
      uvodRotacijaKruga = true;
  }
}


//pomoćna funkcija koja se poziva iz gornje funkcije
void uvodCrtajOdsjecak(color boja, int i)
{
  fill(boja); //odsječak se ispuni proslijeđenom bojom
  //crtam luk kruga (ispunjeno) sa središtem u prva dva argumenta, i promjera uvodPromjerKruga,
  //od do kuteva koji su navedeni kao 3. i 4. argument 
  arc(width/2-uvodTranX, height/2-uvodPomakKruga-uvodTranY, uvodPromjerKruga, uvodPromjerKruga, radians(i*90-90), radians(uvodBrojacZaOdsjecke[i]));
  if (uvodBrojacZaOdsjecke[i] < i*90) //ako pojedini odsječak nije došao do kraja (nije sav iscrtan)
    uvodBrojacZaOdsjecke[i] += uvodBrzinaPrikaza; //iscrtat ću veći dio njega sljedeći put
}