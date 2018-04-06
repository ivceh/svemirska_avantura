import java.util.Arrays;

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

void pacmanSetup()
{
  rectMode(CENTER);
  strokeWeight(1);
  
  pacmanFont = createFont("MONO.ttf",18);
  pacmanFontVeliki = createFont("MONO.ttf",40);
}

void pacman()
{
  pacmanBrojTockica = 0;
  
  for (int i=0; i<pacmanPoljaOkomito; ++i)
    for (int j=0; j<pacmanPoljaVodoravno; ++j)
    {
      if (pacmanStanjaPolja[i][j] != pacmanZID)
      {
        pacmanStanjaPolja[i][j] = pacmanTOCKA;
        ++pacmanBrojTockica;
      }
    }
    
  pacmanPocetniBrojTockica = pacmanBrojTockica;
  
  pacman = new Pacman(new int[]{20,7}, pacmanDesno, pacmanDesno);
  pacmanLikovi = new PacmanLik[]{
                                  pacman,
                                  new PacmanGlupiProtivnik(new int[]{5,10}, pacmanDolje),
                                  new PacmanGlupiProtivnik(new int[]{15,18}, pacmanGore),
                                  new PacmanGlupiProtivnik(new int[]{1,1}, pacmanDesno),
                                  new PacmanGlupiProtivnik(new int[]{1,18}, pacmanDesno),
                                  new PacmanGlupiProtivnik(new int[]{8,4}, pacmanDolje),
                                  new PacmanPametniProtivnik(new int[]{26,18}, pacmanGore)
                                };
  
  pacmanDoPocetkaIgre = 180;
  brojBodova = 200;
  pacmanIgraGotova = false;
}

void crtajPacmana()
{
  fill(255); // bijela
  stroke(255);
  rectMode(CENTER);
  
  // racunanje visine i sirine pojedinog polja
  float pacmanSirinaPolja = width*0.8/pacmanPoljaVodoravno,
        pacmanVisinaPolja = height/pacmanPoljaOkomito;
  
  // crtanje polja
  for (int i=0; i<pacmanPoljaOkomito; ++i)
    for (int j=0; j<pacmanPoljaVodoravno; ++j)
    {
      if (pacmanStanjaPolja[i][j] == pacmanZID)
        rect(pacmanSirinaPolja*(j+0.5), pacmanVisinaPolja*(i+0.5), pacmanSirinaPolja, pacmanVisinaPolja);
      else if (pacmanStanjaPolja[i][j] == pacmanTOCKA)
        ellipse(pacmanSirinaPolja*(j+0.5), pacmanVisinaPolja*(i+0.5), pacmanSirinaPolja/8., pacmanVisinaPolja/8.);
    }
  
  if (pacmanDoPocetkaIgre > 0)
  {
    if (pacmanDoPocetkaIgre == 180)
    {
      textFont(pacmanFont);
      textAlign(LEFT, TOP);
      fill(255);
      text("Pritisnite strelicu \n za pocetak", width * 0.83, height * 0.08);
    }
    else
    {
      --pacmanDoPocetkaIgre;
      textFont(pacmanFontVeliki);
      textAlign(LEFT, TOP);
      fill(255);
      text(pacmanDoPocetkaIgre / 60 + 1, width * 0.89, height * 0.1);
    }
  }
  else
  {
    if (!pacmanIgraGotova)
    {
      for (PacmanLik lik : pacmanLikovi)
        lik.Pomakni();
      if (pacmanVrijeme < Integer.MAX_VALUE)
        ++pacmanVrijeme;
    }
    textFont(pacmanFont);
    textAlign(LEFT, TOP);
    fill(255);
    text("Preostalo tockica: " + pacmanBrojTockica, width * 0.83, height * 0.02);
    text("Bodovi za tockice: " + PacmanBodoviZaTockice(), width * 0.83, height * 0.05);
    text("Bodovi za vrijeme: " + PacmanBodoviZaVrijeme(), width * 0.83, height * 0.08);
  }
  
  // crtanje likova
  for (PacmanLik lik : pacmanLikovi)
    lik.Nacrtaj(pacmanSirinaPolja, pacmanVisinaPolja);
  
  // brisanje desnog dijela koji izlazi iz polja
  fill(0); // crna
  stroke(0);
  rectMode(CORNER);
  rect(pacmanSirinaPolja*pacmanPoljaVodoravno, 0, pacmanSirinaPolja, pacmanVisinaPolja*pacmanPoljaOkomito);
  
  if (pacmanIgraGotova)
  {
    crtajGameOverFormu();//Design by Sebastijan
    strokeWeight(1);
  }
}

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

void PacmanKeyPressed()
{
  if (stanjeIgre == 2 && key == CODED)
  {
    if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT)
    {
      if (keyCode == UP)
        pacman.sljedeciSmjer = pacmanGore;
      else if (keyCode == DOWN)
        pacman.sljedeciSmjer = pacmanDolje;
      else if (keyCode == LEFT)
        pacman.sljedeciSmjer = pacmanLijevo;
      else // (keyCode == RIGHT)
        pacman.sljedeciSmjer = pacmanDesno;
      
      if (pacmanDoPocetkaIgre == 180)
        --pacmanDoPocetkaIgre;
    }
  }
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
  return (int)(2000000/(float)(2000 + pacmanVrijeme));
}