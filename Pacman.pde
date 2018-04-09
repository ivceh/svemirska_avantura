void pacmanSetup()
{
  player.close(); //stop music
  player = minim.loadFile("Galactic.mp3"); //TODO: find music for Pacman
  player.loop(); //play music
  
  rectMode(CENTER);
  strokeWeight(1);
  
  pacmanFont = createFont("MONO.ttf",18);
  pacmanFontVeliki = createFont("MONO.ttf",40);
  
  pacmanBrojTockica = 0;
  pacmanVrijeme = 0;
  
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
  
  // racunanje visine i sirine pojedinog polja
  float pacmanSirinaPolja = width*0.8/pacmanPoljaVodoravno;
  
  // ucitavanje slika likova i meteora
  pacmanShip = loadImage("spaceship"+indeksOznacenogBroda+".png");    
  pacmanShip.resize((int)(pacmanSirinaPolja*0.8), (int)(pacmanSirinaPolja*0.6));
  
  pacmanUFO = loadImage("UFO.png");
  pacmanUFO.resize((int)(pacmanSirinaPolja*0.7), (int)(pacmanSirinaPolja*0.7));
  
  pacmanAlien1 = loadImage("alien1.png");
  pacmanAlien1.resize((int)(pacmanSirinaPolja*0.7), (int)(pacmanSirinaPolja*0.7));
  pacmanAlien2 = loadImage("alien2.png");
  pacmanAlien2.resize((int)(pacmanSirinaPolja*0.7), (int)(pacmanSirinaPolja*0.7));
  pacmanAlien3 = loadImage("alien3.png");
  pacmanAlien3.resize((int)(pacmanSirinaPolja*0.7), (int)(pacmanSirinaPolja*0.7));
  pacmanAlien4 = loadImage("alien4.png");
  pacmanAlien4.resize((int)(pacmanSirinaPolja*0.7), (int)(pacmanSirinaPolja*0.7));
  pacmanAlien5 = loadImage("alien5.png");
  pacmanAlien5.resize((int)(pacmanSirinaPolja*0.7), (int)(pacmanSirinaPolja*0.7));
  
  pacmanMeteor = loadImage("meteor.png");
  pacmanMeteor.resize((int)(pacmanSirinaPolja*0.25), (int)(pacmanSirinaPolja*0.25));
  
  // inicijalizacija likova
  pacman = new Pacman(new int[]{20,7}, pacmanDesno, pacmanDesno);
  pacmanLikovi = new PacmanLik[]{
                                  pacman,
                                  new PacmanGlupiProtivnik(new int[]{5,10}, pacmanDolje, pacmanAlien1),
                                  new PacmanGlupiProtivnik(new int[]{15,18}, pacmanGore, pacmanAlien2),
                                  new PacmanGlupiProtivnik(new int[]{1,1}, pacmanDesno, pacmanAlien3),
                                  new PacmanGlupiProtivnik(new int[]{1,18}, pacmanDesno, pacmanAlien4),
                                  new PacmanGlupiProtivnik(new int[]{8,4}, pacmanDolje, pacmanAlien5),
                                  new PacmanPametniProtivnik(new int[]{26,18}, pacmanGore)
                                };
  
  pacmanDoPocetkaIgre = 180;
  brojBodova = 200;
  pacmanIgraGotova = false;
}


void pacman()
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
      
        image(pacmanMeteor, pacmanSirinaPolja*(j+0.5), pacmanVisinaPolja*(i+0.5));
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
      float fBrojPomaka = pacmanZaostatak + 60/frameRate;
      int iBrojPomaka = (int)fBrojPomaka;
      pacmanZaostatak = fBrojPomaka - iBrojPomaka;
      
      for (int i=0; i<iBrojPomaka; ++i)
      {
        for (PacmanLik lik : pacmanLikovi)
          lik.Pomakni();
        if (pacmanVrijeme < Long.MAX_VALUE)
          ++pacmanVrijeme;
      }
    }
    textFont(pacmanFont);
    textAlign(LEFT, TOP);
    fill(255);
    text("Preostalo meteora: " + pacmanBrojTockica, width * 0.83, height * 0.02);
    text("Bodovi za meteore: " + PacmanBodoviZaTockice(), width * 0.83, height * 0.05);
    text("Bodovi za vrijeme: " + PacmanBodoviZaVrijeme(), width * 0.83, height * 0.08);
  }
  
  textFont(pacmanFont);
  textAlign(LEFT, TOP);
  fill(255);
  text("Pritisnite H za help.", width * 0.83, height * 0.95);
  
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
float pacmanZaostatak = 0;


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
