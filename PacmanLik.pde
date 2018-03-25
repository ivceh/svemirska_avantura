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
}

public class PacmanPametniProtivnik extends PacmanProtivnik
{
  public PacmanPametniProtivnik(int[] pocetnoPolje, int pocetniSmjer)
  {
    super(pocetnoPolje, pocetniSmjer);
  }
  
  public void OdluciOSljedecemSmjeru()
  {
    
  }
  
  public void NacrtajNaPoziciji(float[] pozicija, float sirinaPolja, float visinaPolja)
  {
  
  }
}

public class PacmanGlupiProtivnik extends PacmanProtivnik
{
  public PacmanGlupiProtivnik(int[] pocetnoPolje, int pocetniSmjer)
  {
    super(pocetnoPolje, pocetniSmjer);
  }
  
  public void OdluciOSljedecemSmjeru()
  {
    
  }
  
  public void NacrtajNaPoziciji(float[] pozicija, float sirinaPolja, float visinaPolja)
  {
    
  }
}