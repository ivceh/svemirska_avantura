abstract public class PacmanLik
{
  protected int[] trenutnoPolje; // = {20,7};
  protected int trenutniSmjer, tockaIzmedu;
  
  public PacmanLik(int[] pocetnoPolje, int pocetniSmjer)
  {
    trenutnoPolje = pocetnoPolje;
    trenutniSmjer = pocetniSmjer;
    tockaIzmedu = 0;
  }
  
  abstract public void Pomakni();
  
  abstract public void Nacrtaj(float sirinaPolja, float visinaPolja);
}

public class Pacman extends PacmanLik
{
  public int sljedeciSmjer;
  
  public Pacman(int[] pocetnoPolje, int pocetniSmjer, int sljedeciSmjer)
  {
    super(pocetnoPolje, pocetniSmjer);
    this.sljedeciSmjer = sljedeciSmjer;
  }
  
  public void Pomakni()
  {
    if (++tockaIzmedu == pacmanBrojPomakaZaJednoPolje)
    {
      trenutnoPolje = PacmanSljedecePolje(trenutnoPolje, trenutniSmjer);
      tockaIzmedu = 0;
    
      println(trenutnoPolje);
    }
  }
  
  public void Nacrtaj(float sirinaPolja, float visinaPolja)
  {
    fill(255,255,0); // zuta
    stroke(255,255,0);
  
    // crtanje pacmana
    ellipse(sirinaPolja*(trenutnoPolje[0]+0.5+tockaIzmedu/(float)pacmanBrojPomakaZaJednoPolje*pacmanVektorSmjera[trenutniSmjer][0]),
            visinaPolja*(trenutnoPolje[1]+0.5+tockaIzmedu/(float)pacmanBrojPomakaZaJednoPolje*pacmanVektorSmjera[trenutniSmjer][1]),
            sirinaPolja*0.8, visinaPolja*0.8);
  }
}

abstract public class PacmanProtivnik extends PacmanLik
{
  public PacmanProtivnik(int[] pocetnoPolje, int pocetniSmjer)
  {
    super(pocetnoPolje, pocetniSmjer);
  }
}

public class PacmanPametniProtivnik extends PacmanProtivnik
{
  public PacmanPametniProtivnik(int[] pocetnoPolje, int pocetniSmjer)
  {
    super(pocetnoPolje, pocetniSmjer);
  }
  
  public void Pomakni()
  {
    
  }
  
  public void Nacrtaj(float sirinaPolja, float visinaPolja)
  {
    
  }
}

public class PacmanGlupiProtivnik extends PacmanProtivnik
{
  public PacmanGlupiProtivnik(int[] pocetnoPolje, int pocetniSmjer)
  {
    super(pocetnoPolje, pocetniSmjer);
  }
  
  public void Pomakni()
  {
    
  }
  
  public void Nacrtaj(float sirinaPolja, float visinaPolja)
  {
    
  }
}