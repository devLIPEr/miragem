class Card {
  Card();

  int id;
  int colectionId;
  String name;
  Quality quality;
  int quantity;
  Idiom idiom;
  String img;
}

enum Quality { M, NM, SP, MP, HP, D }

enum Idiom { PT, EN, JP }
