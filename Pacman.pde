int[][] pacmanStanjaPolja = {{1,0,1}, {0,1,0}, {1,0,1}};

void pacmanSetup()
{
  rectMode(CORNER);
}

void pacman()
{
  fill(255);
  rect(50,50,100,100);
}

void crtajPacmana()
{
  int pacmanPoljaOkomito = pacmanStanjaPolja.length,
      pacmanPoljaVodoravno = pacmanStanjaPolja[0].length;
  float sirinaPolja = width/pacmanPoljaVodoravno,
        visinaPolja = height/pacmanPoljaOkomito;
  
  fill(255);
  for (int i=0; i<pacmanPoljaOkomito; ++i)
    for (int j=0; j<pacmanPoljaVodoravno; ++j)
    {
      if (pacmanStanjaPolja[i][j] == 1)
        rect(sirinaPolja*j, visinaPolja*i, sirinaPolja, visinaPolja);
    }
}