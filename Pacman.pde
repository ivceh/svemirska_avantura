import java.util.Arrays;

// globalne konstante
// stanja polja
final int pacmanTOCKA = 0, pacmanZID = 1, pacmanPRAZNO = 2;

// smjerovi
final int pacmanDesno = 0, pacmanGore = 1, pacmanLijevo = 2, pacmanDolje = 3;

// vektori smjerova
final int[][] pacmanVektorSmjera = {{1,0}, {0,-1}, {-1,0}, {0,1}};

// odredivanje brzine kretanja pacmana
final int pacmanBrojPomakaZaJednoPolje = 10;

// globalne varijable stanja
int[] pacmanTrenutnoPolje = {20,7};
int pacmanTrenutniSmjer = 0, pacmanSlijedeciSmjer, pacmanTockaIzmedu=0;

// definiranje polja: 0 za tocke, 1 za zid, 2 za prazna polja
int[][] pacmanStanjaPolja =
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
final int pacmanPoljaOkomito = pacmanStanjaPolja.length,
          pacmanPoljaVodoravno = pacmanStanjaPolja[0].length;

void pacmanSetup()
{
  rectMode(CENTER);
  
  for (int i=0; i<pacmanPoljaOkomito; ++i)
    for (int j=0; j<pacmanPoljaVodoravno; ++j)
    {
      if (pacmanStanjaPolja[i][j] != pacmanZID)
        pacmanStanjaPolja[i][j] = pacmanTOCKA;
    }
}

void pacman()
{
  
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
  
  fill(255,255,0); // zuta
  stroke(255,255,0);
  
  // crtanje pacmana
  ellipse(pacmanSirinaPolja*(pacmanTrenutnoPolje[0]+0.5+pacmanTockaIzmedu/(float)pacmanBrojPomakaZaJednoPolje*pacmanVektorSmjera[pacmanTrenutniSmjer][0]),
          pacmanVisinaPolja*(pacmanTrenutnoPolje[1]+0.5+pacmanTockaIzmedu/(float)pacmanBrojPomakaZaJednoPolje*pacmanVektorSmjera[pacmanTrenutniSmjer][1]),
          pacmanSirinaPolja*0.8, pacmanVisinaPolja*0.8);
  
  if (++pacmanTockaIzmedu == pacmanBrojPomakaZaJednoPolje)
  {
    pacmanTrenutnoPolje = PacmanSljedecePolje(pacmanTrenutnoPolje, pacmanTrenutniSmjer);
    pacmanTockaIzmedu = 0;
    
    println(pacmanTrenutnoPolje);
  }
  
  fill(0); // crna
  stroke(0);
  rectMode(CORNER);
  rect(pacmanSirinaPolja*pacmanPoljaVodoravno, 0, pacmanSirinaPolja, pacmanVisinaPolja*pacmanPoljaOkomito);
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
  return pacmanStanjaPolja[sljedece_polje[0]][sljedece_polje[1]] == pacmanZID;
}