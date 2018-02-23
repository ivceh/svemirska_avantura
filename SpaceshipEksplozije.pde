int spaceshipUkupanBrojEksplozija = 20;

PImage[] spaceshipFrameoviEkspozije = new PImage[17];
Boolean[] spaceshipCrtajuceEksplozije = new Boolean[spaceshipUkupanBrojEksplozija];
float[] spaceshipPolozajiEksplozija = new float[spaceshipUkupanBrojEksplozija];
float[] spaceshipVisineEksplozija = new float[spaceshipUkupanBrojEksplozija];
int[] spaceshipFrameNaRedu = new int[spaceshipUkupanBrojEksplozija];

void spaceshipUcitajEksplozije()
{
  for (int i=0; i<17; ++i)
  {
    spaceshipFrameoviEkspozije[i] = loadImage("explosion"+i+".png");
    spaceshipFrameoviEkspozije[i].resize(spaceship.width, spaceship.width);
  }

  for (int i=0; i<spaceshipCrtajuceEksplozije.length; ++i)
  {
    spaceshipCrtajuceEksplozije[i] = false;
  }
}

void spaceshipDodajEksploziju(float polozaj, float visina)
{
  for (int i=0; i<spaceshipCrtajuceEksplozije.length; ++i)
  {
    if (spaceshipCrtajuceEksplozije[i] == false)
    {
      spaceshipFrameNaRedu[i] = 0;
      spaceshipPolozajiEksplozija[i] = polozaj;
      spaceshipVisineEksplozija[i] = visina+spaceshipFrameoviEkspozije[0].height/4;
      spaceshipCrtajuceEksplozije[i] = true;
      i = spaceshipCrtajuceEksplozije.length; //ovo izlazi iz for petlje
    }
  }
}

void spaceshipCrtajEksplozije()
{
  for (int i=0; i<spaceshipCrtajuceEksplozije.length; ++i)
  {
    if (spaceshipCrtajuceEksplozije[i] == true)
    {
      image(spaceshipFrameoviEkspozije[spaceshipFrameNaRedu[i]], spaceshipPolozajiEksplozija[i], spaceshipVisineEksplozija[i]);
      ++spaceshipFrameNaRedu[i];
      if ( spaceshipFrameNaRedu[i] == 17)
        spaceshipCrtajuceEksplozije[i] = false;
    }
  }
}