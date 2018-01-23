PImage pozadina,
       mars, venera, neptun, pluton,
       start_znak, info_znak, opcije_znak, exit_znak;

void setup()
{
  fullScreen();
  
  //ispiše se "loading..." dok se donje slike ne učitaju
  background(0);
  textSize(width/20);
  text("loading...", width/3, height/2);
  
  //slike učitam i resizam na početku da se poslije ne moraju resizati svaki put (usporava program)
  pozadina = loadImage("tamni_svemir.jpg"); 
  pozadina.resize(width,height);
  mars = loadImage("mars.png"); 
  mars.resize((int)(width*0.15), (int)(width*0.15));
  venera = loadImage("venera.png"); 
  venera.resize((int)(width*0.15), (int)(width*0.15));
  neptun = loadImage("neptun.png"); 
  neptun.resize((int)(width*0.15), (int)(width*0.15));
  pluton = loadImage("pluton.png"); 
  pluton.resize((int)(width*0.15), (int)(width*0.15));
  start_znak = loadImage("start_znak.png"); 
  start_znak.resize((int)(width*0.15), (int)(width*0.15));
  info_znak = loadImage("info_znak.png"); 
  info_znak.resize((int)(width*0.185), (int)(width*0.185));
  opcije_znak = loadImage("opcije_znak.png"); 
  opcije_znak.resize((int)(width*0.10), (int)(width*0.10));
  exit_znak = loadImage("exit_znak.png"); 
  exit_znak.resize((int)(width*0.17), (int)(width*0.17));
  
  //textMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
}

int stanjeIgre = 0, stanjeIzbornika = 0;
//stanjeIgre == 0 akko smo u nekom izborniku
//stanjeIgre > 0 ako smo u igre, nekom levelu, npr. 1 znači u 1. levelu
//stanjeIzbornika == 0 akko smo u glavnom izborniku
//    == 1 akko smo na mapi za biranje levela
//    == 2 akko smo u izborniku za postavljanje opcija
//    == 3 akko smo u glavnom izborniku kliknuli na informacije, pa smo tamo

void draw()
{
  if(stanjeIgre == 0) //u glavnom izborniku smo
  {
    if(stanjeIzbornika == 0)
    {
      crtajIzbornik();
      if(mousePressed)
      {
        
        //je li kliknut gumb za start
         if(pow(mouseX-0.2*width,2)+pow(mouseY-0.45*height,2)<pow(0.075*width,2)) //0.075=0.15/2
         {
           stanjeIzbornika = 1;
         }
         
         //je li kliknut gumb za info
         if(pow(mouseX-0.6*width,2)+pow(mouseY-0.45*height,2)<pow(0.075*width,2))
         {
           stanjeIzbornika = 2; 
         }
         
         //je li kliknut gumb za opcije
         if(pow(mouseX-0.4*width,2)+pow(mouseY-0.75*height,2)<pow(0.075*width,2))
         {
           stanjeIzbornika = 3;
         }
         
         //je li kliknut gumb za izlaz
         if(pow(mouseX-0.8*width,2)+pow(mouseY-0.75*height,2)<pow(0.075*width,2))
         {
           exit(); 
         }
      }
    }
    
    else if(stanjeIzbornika == 1)
    {
      crtajMapu();
    }
    
    else if(stanjeIzbornika == 2)
    {
      crtajInformacije();
    }
    
    else if(stanjeIzbornika == 3)
    {
      crtajOpcije();
    }
    
    
  }
  
  else if(stanjeIgre == 1)
  {
     //ovdje se poziva funkcija (tj. igra) za 1. level
     crtajIgru1();
  }
  
  else if(stanjeIgre == 2)
  {
     //ovdje se poziva funkcija (tj. igra) za 2. level
     crtajIgru2();
  }
  
  else if(stanjeIgre == 3)
  {
     //ovdje se poziva funkcija (tj. igra) za 3. level
     crtajIgru3();
  }
  
}