abstract public class PacmanLik
{
  protected int[] trenutnoPolje; // = {20,7};
  protected int trenutniSmjer, tockaIzmedu;
  
  // odredivanje brzine kretanja pacmana - koliko intervala treba proci da bi se pomakli za jedno polje
  protected final int brojPomakaZaJednoPolje;
  
  public PacmanLik(int[] pocetnoPolje, int pocetniSmjer, int brojPomakaZaJednoPolje)
  {
    trenutnoPolje = pocetnoPolje;
    trenutniSmjer = pocetniSmjer;
    tockaIzmedu = 0;
    this.brojPomakaZaJednoPolje = brojPomakaZaJednoPolje;
  }
  
  public void Pomakni()
  {
    if (tockaIzmedu == brojPomakaZaJednoPolje)
    {
      trenutnoPolje = PacmanSljedecePolje(trenutnoPolje, trenutniSmjer);
      tockaIzmedu = 0;
    }
    
    if (tockaIzmedu == 0)
      OdluciOSljedecemSmjeru();
    else
      ++tockaIzmedu;
  }
  
  // po potrebi mijenja trenutniSmjer, ako lik nije stao treba postaviti tockaIzmedu = 1
  abstract public void OdluciOSljedecemSmjeru();
  
  public void Nacrtaj(float sirinaPolja, float visinaPolja)
  {
    float x = sirinaPolja*(trenutnoPolje[0]+0.5+tockaIzmedu/(float)brojPomakaZaJednoPolje*pacmanVektorSmjera[trenutniSmjer][0]),
          y = visinaPolja*(trenutnoPolje[1]+0.5+tockaIzmedu/(float)brojPomakaZaJednoPolje*pacmanVektorSmjera[trenutniSmjer][1]);
    
    NacrtajNaPoziciji(new float[]{x,y}, sirinaPolja, visinaPolja);
    
    // prelazak s lijeve na desnu stranu ekrana
    if (trenutnoPolje[0] == 0 && trenutniSmjer == pacmanLijevo)
      NacrtajNaPoziciji(new float[]{x + pacmanPoljaVodoravno * sirinaPolja, y}, sirinaPolja, visinaPolja);
    
    // prelazak s desne na lijevu stranu ekrana
    if (trenutnoPolje[0] == pacmanPoljaVodoravno - 1 && trenutniSmjer == pacmanDesno)
      NacrtajNaPoziciji(new float[]{x - pacmanPoljaVodoravno * sirinaPolja, y}, sirinaPolja, visinaPolja);
  }
  
  abstract public void NacrtajNaPoziciji(float[] pozicija, float sirinaPolja, float visinaPolja);
}

public class Pacman extends PacmanLik
{
  public int sljedeciSmjer;
  
  public Pacman(int[] pocetnoPolje, int pocetniSmjer, int sljedeciSmjer)
  {
    super(pocetnoPolje, pocetniSmjer, 10);
    this.sljedeciSmjer = sljedeciSmjer;
  }
  
  public void OdluciOSljedecemSmjeru()
  {
    if (pacmanStanjaPolja[trenutnoPolje[1]][trenutnoPolje[0]] == pacmanTOCKA)
    {
      pacmanStanjaPolja[trenutnoPolje[1]][trenutnoPolje[0]] = pacmanPRAZNO;
      --pacmanBrojTockica;
      if (pacmanBrojTockica == 0)
      {
        pacmanIgraGotova = true;
        brojBodova = PacmanBodoviZaTockice() + PacmanBodoviZaVrijeme();
      }
    }
    
    if (PacmanSljedecePoljeJeZid(trenutnoPolje, sljedeciSmjer))
    {
      if (!PacmanSljedecePoljeJeZid(trenutnoPolje, trenutniSmjer))
        tockaIzmedu = 1;
    }
    else
    {
      trenutniSmjer = sljedeciSmjer;
      tockaIzmedu = 1;
    }
  }
  
  public void NacrtajNaPoziciji(float[] pozicija, float sirinaPolja, float visinaPolja)
  {
    fill(255,255,0); // zuta
    stroke(255,255,0);

    ellipse(pozicija[0], pozicija[1], sirinaPolja*0.8, visinaPolja*0.8);
  }
}

abstract public class PacmanProtivnik extends PacmanLik
{
  public PacmanProtivnik(int[] pocetnoPolje, int pocetniSmjer)
  {
    super(pocetnoPolje, pocetniSmjer, 11);
  }
  
  public void Pomakni()
  {
    super.Pomakni();
    float jaX = trenutnoPolje[0] + tockaIzmedu / brojPomakaZaJednoPolje * pacmanVektorSmjera[trenutniSmjer][0],
          jaY = trenutnoPolje[1] + tockaIzmedu / brojPomakaZaJednoPolje * pacmanVektorSmjera[trenutniSmjer][1],
          pacmanX = pacman.trenutnoPolje[0] + pacman.tockaIzmedu / pacman.brojPomakaZaJednoPolje * pacmanVektorSmjera[trenutniSmjer][0],
          pacmanY = pacman.trenutnoPolje[1] + pacman.tockaIzmedu / pacman.brojPomakaZaJednoPolje * pacmanVektorSmjera[trenutniSmjer][1];
    
    if ((jaX-pacmanX)*(jaX-pacmanX) + (jaY-pacmanY)*(jaY-pacmanY) < 0.8)
    {
      pacmanIgraGotova = true;
      brojBodova = PacmanBodoviZaTockice();
    }
  }
  
  public void OdluciOSljedecemSmjeru()
  {
    boolean[] moguciSmjerovi = new boolean[4];
    
    for (int i=0; i<4; ++i)
      moguciSmjerovi[i] = !PacmanSljedecePoljeJeZid(trenutnoPolje, i);
    
    int brojMogucihSmjerova = 0;
    for (int i=0; i<4; ++i)
      if (moguciSmjerovi[i])
        ++brojMogucihSmjerova;
    
    if (brojMogucihSmjerova == 1)
    {
      for (int i=0; i<4; ++i)
        if (moguciSmjerovi[i])
          trenutniSmjer = i;
    }
    else if (brojMogucihSmjerova == 2)
    {
      int suprotniSmjer = PacmanSuprotniSmjer(trenutniSmjer);
      for (int i=0; i<4; ++i)
        if (moguciSmjerovi[i] && i != suprotniSmjer)
          trenutniSmjer = i;
    }
    else
    {
      int suprotniSmjer = PacmanSuprotniSmjer(trenutniSmjer);
      ArrayList<Integer> listaMogucihSmjerova = new ArrayList<Integer>();
      for (int i=0; i<4; ++i)
        if (moguciSmjerovi[i] && i != suprotniSmjer)
          listaMogucihSmjerova.add(new Integer(i));
      OdluciKadImasIzbora(listaMogucihSmjerova);
    }
    
    tockaIzmedu = 1;
  }
  
  abstract protected void OdluciKadImasIzbora(ArrayList<Integer> moguciSmjerovi);
}

public class PacmanPametniProtivnik extends PacmanProtivnik
{
  public PacmanPametniProtivnik(int[] pocetnoPolje, int pocetniSmjer)
  {
    super(pocetnoPolje, pocetniSmjer);
  }
  
  public void NacrtajNaPoziciji(float[] pozicija, float sirinaPolja, float visinaPolja)
  {
    fill(255,0,0); // crvena
    stroke(255,0,0);

    ellipse(pozicija[0], pozicija[1], sirinaPolja*0.8, visinaPolja*0.8);
  }
  
  void OdluciKadImasIzbora(ArrayList<Integer> moguciSmjerovi)
  {
    int maxi = 0, maxdobrota = KolikoJeSmjerDobar(pacman.trenutnoPolje, this.trenutnoPolje, moguciSmjerovi.get(0));
    float maxrandom = random(1);
    for (int i = 1; i < moguciSmjerovi.size(); ++i)
    {
      int dobrota = KolikoJeSmjerDobar(pacman.trenutnoPolje, this.trenutnoPolje, moguciSmjerovi.get(i));
      if (dobrota > maxdobrota)
      {
        maxi = i;
        maxdobrota = dobrota;
        maxrandom = random(1);
      }
      else if (dobrota == maxdobrota)
      {
        float random = random(1);
        if (random > maxrandom)
        {
          maxi = i;
          maxdobrota = dobrota;
          maxrandom = random;
        }
      }
    }
    
    trenutniSmjer = moguciSmjerovi.get(maxi);
  }
}

private static int NenegativniOstatak(int a, int b)
{
  int c = a % b;
  if (c >= 0)
    return c;
  else
    return c + b;
}
  
static private int KolikoJeSmjerDobar(int[] pacmanPolje, int[] protivnikPolje, int smjer)
{
  switch(smjer)
  {
    case pacmanDesno:
      int udaljenostDesno = NenegativniOstatak(pacmanPolje[0] - protivnikPolje[0], pacmanPoljaVodoravno);
      if (udaljenostDesno < pacmanPoljaVodoravno / 2)
        return udaljenostDesno;
      else
        return pacmanPoljaVodoravno / 2 - udaljenostDesno;  
    case pacmanGore:
      return protivnikPolje[1] - pacmanPolje[1];
    case pacmanLijevo:
      int udaljenostLijevo = NenegativniOstatak(protivnikPolje[0] - pacmanPolje[0], pacmanPoljaVodoravno);
      if (udaljenostLijevo < pacmanPoljaVodoravno / 2)
        return udaljenostLijevo;
      else
        return pacmanPoljaVodoravno / 2 - udaljenostLijevo;
    case pacmanDolje:
      return pacmanPolje[1] - protivnikPolje[1];
    default:
      print("??????");
      return -1000; // ovo se nikad ne bi trebalo dogoditi
  }
}



public class PacmanGlupiProtivnik extends PacmanProtivnik
{
  public PacmanGlupiProtivnik(int[] pocetnoPolje, int pocetniSmjer)
  {
    super(pocetnoPolje, pocetniSmjer);
  }
  
  public void NacrtajNaPoziciji(float[] pozicija, float sirinaPolja, float visinaPolja)
  {
    fill(255,128,0); // narancasta
    stroke(255,128,0);

    ellipse(pozicija[0], pozicija[1], sirinaPolja*0.8, visinaPolja*0.8);
  }
  
  void OdluciKadImasIzbora(ArrayList<Integer> moguciSmjerovi)
  {
    trenutniSmjer = moguciSmjerovi.get(int(random(moguciSmjerovi.size())));
  }
}