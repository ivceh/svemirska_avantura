PImage spaceshipPozadina, redDwarf, povrsina1, povrsina2;
float polozajPozadine, brzinaPozadine;
int polozajRedDwarfa, polozajPovrsine1, polozajPovrsine2;


void ucitajPozadine()
{
  //učitam potrebne slike
  spaceshipPozadina = loadImage("pozadinaSvemir.jpg");
  spaceshipPozadina.resize(width, 4*height/5);

  povrsina1 = loadImage("sloj1.png");
  povrsina1.resize(width, height/2);

  povrsina2 = loadImage("sloj2.png");
  povrsina2.resize(width, height/2);

  redDwarf = loadImage("redDwarf.png");
  redDwarf.resize(width/6, height/3);

  polozajPozadine = width/2;
  polozajPovrsine1 = width/2;
  polozajRedDwarfa = width;
}

void crtajPozadinu()
{
  polozajPozadine-=brzinaPozadine;
  if (polozajPozadine < -width/2) 
  {
    polozajPozadine = width/2;
  }
  image(spaceshipPozadina, polozajPozadine, 4*height/10);
  image(spaceshipPozadina, polozajPozadine+width, 4*height/10);

  polozajRedDwarfa-=brzinaPozadine;
  if (polozajRedDwarfa < -redDwarf.width) 
  {
    polozajRedDwarfa = width*2;
  }
  if (polozajRedDwarfa < width+redDwarf.width)
    image(redDwarf, polozajRedDwarfa, height/20+redDwarf.height/2);

  polozajPovrsine1-=brzinaPozadine*2;
  if (polozajPovrsine1 < -width/2) 
  {
    polozajPovrsine1 = width/2;
  }
  image(povrsina1, polozajPovrsine1, height-povrsina1.height/2+(height-polozajY)/20);
  image(povrsina1, polozajPovrsine1+width, height-povrsina1.height/2+(height-polozajY)/20);


  polozajPovrsine2-=brzinaPozadine*4;
  if (polozajPovrsine2 < -width/2) 
  {
    polozajPovrsine2 = width/2;
  }
  image(povrsina2, polozajPovrsine2, 0.8*height+(height-polozajY)/7);
  image(povrsina2, polozajPovrsine2+width, 0.8*height+(height-polozajY)/7);
}