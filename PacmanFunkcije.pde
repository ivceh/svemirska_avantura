//import java.util.Arrays;
//???

// globalne konstante za stanja polja
final int pacmanTOCKA = 0, pacmanZID = 1, pacmanPRAZNO = 2;

// smjerovi
final static int pacmanDesno = 0, pacmanGore = 1, pacmanLijevo = 2, pacmanDolje = 3;

// vektori smjerova
final int[][] pacmanVektorSmjera = {{1,0}, {0,-1}, {-1,0}, {0,1}};

// likovi
Pacman pacman;
PacmanLik[] pacmanLikovi;

// odbrojavanje do pocetka igre
int pacmanDoPocetkaIgre;

// fontovi
PFont pacmanFont;
PFont pacmanFontVeliki;

// definiranje polja: 0 za tocke, 1 za zid, 2 za prazna polja
static int[][] pacmanStanjaPolja =
  {{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
   {1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
   {1,0,1,1,0,0,0,1,0,1,1,1,0,1,0,1,1,1,1,0,1,1,1,1,1,1,0,1},
   {1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
   {1,1,1,0,1,1,0,1,0,1,1,1,0,1,0,1,1,1,0,1,0,1,1,1,0,1,0,1},
   {0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0},
   {1,0,1,0,1,0,1,1,0,0,0,1,1,1,0,1,1,1,0,1,0,1,1,1,0,0,1,1},
   {1,0,1,0,1,0,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,1},
   {1,0,0,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,0,1,1,0,1},
   {1,0,1,1,1,0,0,1,0,1,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,1},
   {1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,0,1},
   {1,0,1,1,1,0,1,0,0,1,1,1,0,1,0,1,1,1,0,1,1,0,1,0,1,0,0,1},
   {1,0,1,0,1,0,1,0,1,1,0,0,0,1,0,0,0,0,0,0,1,0,1,0,1,1,0,1},
   {0,0,1,0,1,0,1,0,1,0,0,1,0,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0},
   {1,0,0,0,0,0,0,0,1,0,1,1,0,1,1,0,0,0,1,1,0,1,1,1,1,1,0,1},
   {1,0,1,0,1,0,1,1,1,0,0,0,0,1,0,0,1,0,0,1,0,0,0,1,0,0,0,1},
   {1,0,1,0,1,0,1,0,0,0,1,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,0,1},
   {1,0,1,1,1,0,1,0,1,1,1,0,0,1,0,0,1,0,0,1,0,1,1,1,1,1,0,1},
   {1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,1},
   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}};

// racunanje velicine polje
final static int pacmanPoljaOkomito = pacmanStanjaPolja.length,
                 pacmanPoljaVodoravno = pacmanStanjaPolja[0].length;
          
// broj tockica
int pacmanPocetniBrojTockica;
int pacmanBrojTockica;

// je li igra gotova
boolean pacmanIgraGotova;

// brojac vremena
int pacmanVrijeme = 0;

int[] PacmanSljedecePolje(int[] trenutno_polje, int smjer)
{
  int sljedece_polje[] = {trenutno_polje[0]+pacmanVektorSmjera[smjer][0],
                          trenutno_polje[1]+pacmanVektorSmjera[smjer][1]};
  if (sljedece_polje[0] < 0)
    sljedece_polje[0] += pacmanPoljaVodoravno;
  else if (sljedece_polje[0] >= pacmanPoljaVodoravno)
    sljedece_polje[0] -= pacmanPoljaVodoravno;
  
  return sljedece_polje;
}

boolean PacmanSljedecePoljeJeZid(int[] trenutno_polje, int smjer)
{
  int sljedece_polje[] = PacmanSljedecePolje(trenutno_polje, smjer);
  return pacmanStanjaPolja[sljedece_polje[1]][sljedece_polje[0]] == pacmanZID;
}

int PacmanSuprotniSmjer(int smjer)
{
  return (smjer+2)%4;
}

// brojanje bodova
int PacmanBodoviZaTockice()
{
  return pacmanPocetniBrojTockica - pacmanBrojTockica;
}

int PacmanBodoviZaVrijeme()
{
  return (int)(10000000/(float)(10000 + pacmanVrijeme));
}