/* UPUTE ZA KORIŠTENJE FUNKCIJA ZA SPREMANJE I DOHVAT REZULTATA:
 ----------
 1) spremanje rezultata
 - Želimo spremiti rezultat igrača "Mirko" u igri Spaceship, dakle igri koja 
 ima id 3, i koji je ostvario 1035 bodova. To radimo sljedećom linijom koda:
 ---> spremiRezultat("Mirko", 1035, 3);
 ----------
 2) dohvaćanje rezultata (tj. bodova)
 - Želimo dohvatiti rezultat (tj. bodove) 1. igrača (tj. najboljeg) u igri sa idjem 3:
 ---> int rezultat = dohvatiBrojBodova(1, 3);
 ----------
 3) dohvaćanje imena igrača
 - Želimo dohvatiti ime 3. igrača (tj. na 3. mjestu po broju bodova) u igri sa idjem 2:
 ---> String ime = dohvatiImeIgraca(3, 2);
 */

Table sviRezultati;

String[] anonimneZivotinje = new String[] {
  "anonimniVrabac", "anonimniSlon", "anonimnaKobila", 
  "anonimnaLisica", "anonimniPapagaj", "anonimniPas", 
  "anonimniPMFovac", "anonimniTigar", "anonimniLav", 
  "anonimniBik", "anonimniUnicorn", "anonimnoPrase"
};


void ucitajRezultate() {
  //pokušaj učitati rezultate iz datoteke - inače ju stvori
  try {
    sviRezultati = loadTable("data.csv", "header");

    sviRezultati.setColumnType("id", Table.INT);
    sviRezultati.setColumnType("brojBodova", Table.INT);
    sviRezultati.setColumnType("idIgre", Table.INT);
  }
  catch(Exception e) {
    sviRezultati = new Table();

    sviRezultati.setColumnTitles(new String[] {
      "id", "imeIgraca", "brojBodova", "idIgre"
      }
      );

    sviRezultati.setColumnType("id", Table.INT);
    sviRezultati.setColumnType("brojBodova", Table.INT);
    sviRezultati.setColumnType("idIgre", Table.INT);

    saveTable(sviRezultati, "data/data.csv");
    println("Napravio novu datoteku data.csv.");
  }
}


//-----DOHVAĆANJE REZULTATA-----
//dohvati broj bodova koji ima neki igrač na poziciji pozicija (1, 2, 3, ...),
//po bodovima silazno (jer tablica tako sortirana), za igru idIgre
int dohvatiBrojBodova(int pozicija, int idIgre) {
  ucitajRezultate();
  int brojZapisaZaTuIgru = 1;

  //pogledaj zapise u datoteci za igru idIgre
  for (TableRow redak : sviRezultati.rows()) {
    if (redak.getInt("idIgre") == idIgre) {
      if (brojZapisaZaTuIgru == pozicija) {
        return redak.getInt("brojBodova");
      } else {
        brojZapisaZaTuIgru++;
      }
    }
  }
  //ako nije bilo dovoljno zapisa, vrati 0 bodova
  return 0;
}

//dohvati ime igrača koji je na poziciji pozicija (1, 2, 3, ...),
//po bodovima silazno (jer tablica tako sortirana), za igru idIgre
String dohvatiImeIgraca(int pozicija, int idIgre) {
  ucitajRezultate();
  int brojZapisaZaTuIgru = 1;

  //pogledaj zapise u datoteci za igru idIgre
  for (TableRow redak : sviRezultati.rows()) {
    if (redak.getInt("idIgre") == idIgre) {
      if (brojZapisaZaTuIgru == pozicija) {
        return redak.getString("imeIgraca");
      } else {
        brojZapisaZaTuIgru++;
      }
    }
  }
  //ako nema dovoljno zapisa vrati neku (slučajno odabranu) anonimnu životinju
  return anonimneZivotinje[int(random(anonimneZivotinje.length))];
}


//-----SPREMANJE REZULTATA-----
//spremi rezultat igrača igrac, koji je ostvario broj bodova bodovi,
//u igri sa idjem idIgre (1,2 ili 3) (samo ako je veći od postojećeg za tog igrača)
void spremiRezultat(String igrac, int bodovi, int idIgre) {

  //ne spremamo rezultat 0 (Kakav je to rezultat?)
  if (bodovi == 0) {
    println("---Pokusao spremiti rezultat 0. Ne spremam nista.");
    return;
  }

  //id igre mora biti 1, 2 ili 3
  if (idIgre <= 0 || idIgre >= 4) {
    println("---Pokusao spremiti idIgre " + idIgre + ". Ne spremam nista.");
    return;
  }

  //igrac ne smije biti prazno
  if (igrac.equals("") == true) {
    println("---Pokusao spremiti prazno ime igraca. Ne spremam nista.");
    return;
  }

  ucitajRezultate();
  boolean promijenjenNekiRedak = false;

  for (TableRow redak : sviRezultati.rows()) {
    //pogledaj ima li taj igrač već neke bodove u toj igri
    if (redak.getString("imeIgraca").equals(igrac) == true &&
      redak.getInt("idIgre") == idIgre) {
      promijenjenNekiRedak = true; //nije nužno promijenjen,
      //ako je broj bodova manji, tada se redak ne mijenja niti kasnije dodaje!
      if (redak.getInt("brojBodova") < bodovi)
      {
        redak.setInt("brojBodova", bodovi);
      }
    }
  }

  //ako nije neki redak gore izmijenjen, onda dodaj novi redak
  if (promijenjenNekiRedak == false) {
    TableRow noviRedak = sviRezultati.addRow();
    noviRedak.setInt("id", sviRezultati.getRowCount());
    noviRedak.setString("imeIgraca", igrac);
    noviRedak.setInt("brojBodova", bodovi);
    noviRedak.setInt("idIgre", idIgre);
  }

  //sortiraj tablicu po broju bodova, padajuće (ali ne kao stringove, nego
  //kao numeričke vrijednosti - zato ova konverzija int()
  sviRezultati.sortReverse("brojBodova");

  //spremi promijenjenu tablicu
  saveTable(sviRezultati, "data/data.csv");
}