import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:image_picker/image_picker.dart';
import 'package:miragem/helper/card_helper.dart';
import 'package:miragem/helper/collection_helper.dart';

/*
Quando for retornar com o Navigator.pop(context),
retorne a quantidade de cartas adicionadas(+)/removidas(-)
Navigator.pop(context, cardsAdded);
*/

class CardPage extends StatefulWidget {
  final Collection collection;

  const CardPage(this.collection, {Key key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  String collectionName = "NOME DA COLEÇÃO";
  List<Card> cards = [];

  final Color light = const Color.fromARGB(255, 204, 206, 199);
  final Color midDown = const Color.fromARGB(255, 160, 159, 151);
  final Color midUp = const Color.fromARGB(255, 119, 116, 111);
  final Color dark = const Color.fromARGB(255, 46, 38, 34);

  Idiom cardIdiom = Idiom.PT;
  Quality cardQuality = Quality.NM;
  String cardName = "";
  Uint8List cardImage = base64Decode("");
  String cardQuantity = "";

  bool editing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController qntController = TextEditingController();

  Widget builtCards = Container();
  Widget imageSelection = Container();

  int cardsAdded = 0;

  CardHelper helper = CardHelper();

  @override
  void initState() {
    super.initState();

    collectionName = widget.collection.name;
    getAllCards();
  }

  void getAllCards() {
    helper.getAllCards(widget.collection.id).then((list) {
      print("List no getAllCards: $list");
      setState(() {
        cards = list;
        builtCards = buildCards(context);
      });
      print("Cards no final do getAllCards: $cards");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, cardsAdded);
          },
        ),
        centerTitle: true,
        title: Text(
          collectionName,
          style: TextStyle(
            color: dark,
            fontSize: 30,
          ),
        ),
        backgroundColor: midDown,
        elevation: 0.0,
      ),
      backgroundColor: midDown,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCard(context, -1);
        },
        backgroundColor: midUp,
        child: Icon(
          Icons.add,
          color: dark,
        ),
      ),
      body: builtCards,
      // body: Builder(builder: (context) {
      //   builtCards = buildCards(context);
      //   return builtCards;
      // }),
      // body: Builder(
      //   builder: (context) {
      //     return SingleChildScrollView(
      //       child: buildCards(context),
      //     );
      //   },
      // ),
    );
  }

  void addCard(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        Card card = (index == -1) ? null : cards[index];
        if (card != null && !editing) {
          cardImage = base64Decode(card.img);
          cardIdiom = card.idiom;
          cardQuality = card.quality;
          cardQuantity = card.quantity.toString();
          cardName = card.name;
          nameController.text = cardName;
          qntController.text = cardQuantity;
          editing = true;
        } else if (!editing) {
          cardImage = base64Decode("");
          cardIdiom = Idiom.PT;
          cardQuality = Quality.NM;
          cardQuantity = "";
          cardName = "";
          nameController.text = cardName;
          qntController.text = cardQuantity;
          editing = true;
        }
        return BottomSheet(
          onClosing: () {
            cardIdiom = Idiom.PT;
            cardQuality = Quality.NM;
            cardImage = base64Decode("");
            cardQuantity = "";
            cardName = "";
            editing = false;
          },
          backgroundColor: midUp,
          builder: (context) {
            const double height = 60.0;
            imageSelection = GestureDetector(
              onTap: () {
                ImagePicker()
                    .pickImage(source: ImageSource.gallery)
                    .then((file) async {
                  if (file != null) {
                    Uint8List imageBytes = await file.readAsBytes();
                    setState(() {
                      cardImage = imageBytes;
                    });
                  }
                });
              },
              child: Container(
                height: height,
                width: MediaQuery.of(context).size.width * 0.425,
                decoration: BoxDecoration(
                  color: light,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("Imagem"),
                          (cardImage.isEmpty)
                              ? const Icon(Icons.attach_file)
                              : Image.memory(cardImage),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: height,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      onChanged: (value) {
                        cardName = value;
                      },
                      controller: nameController,
                      cursorColor: midUp,
                      decoration: InputDecoration(
                        constraints: const BoxConstraints.expand(),
                        filled: true,
                        labelText: "Nome da carta",
                        labelStyle: TextStyle(color: dark),
                        floatingLabelStyle:
                            TextStyle(color: dark, fontWeight: FontWeight.bold),
                        fillColor: light,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: height,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: height,
                          width: MediaQuery.of(context).size.width * 0.425,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: light,
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Quality>(
                                    value: cardQuality,
                                    items: const [
                                      DropdownMenuItem(
                                          value: Quality.M, child: Text("M")),
                                      DropdownMenuItem(
                                          value: Quality.NM, child: Text("NM")),
                                      DropdownMenuItem(
                                          value: Quality.SP, child: Text("SP")),
                                      DropdownMenuItem(
                                          value: Quality.MP, child: Text("MP")),
                                      DropdownMenuItem(
                                          value: Quality.HP, child: Text("HP")),
                                      DropdownMenuItem(
                                          value: Quality.D, child: Text("D")),
                                    ],
                                    onChanged: (choice) {
                                      setState(() {
                                        cardQuality =
                                            (choice == null) ? "" : choice;
                                      });
                                    },
                                    dropdownColor: light,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05),
                        SizedBox(
                          height: height,
                          width: MediaQuery.of(context).size.width * 0.425,
                          child: TextField(
                            onChanged: (value) {
                              cardQuantity = value;
                            },
                            controller: qntController,
                            cursorColor: midUp,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: "Quantidade",
                              labelStyle: TextStyle(color: dark),
                              floatingLabelStyle: TextStyle(
                                  color: dark, fontWeight: FontWeight.bold),
                              fillColor: light,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: height,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: height,
                          width: MediaQuery.of(context).size.width * 0.425,
                          decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: DropdownButton<Idiom>(
                                  alignment: Alignment.centerRight,
                                  value: cardIdiom,
                                  items: const [
                                    DropdownMenuItem(
                                        value: Idiom.PT, child: Text("PT")),
                                    DropdownMenuItem(
                                        value: Idiom.EN, child: Text("EN")),
                                    DropdownMenuItem(
                                        value: Idiom.JP, child: Text("JP")),
                                  ],
                                  onChanged: (choice) {
                                    setState(() {
                                      cardIdiom =
                                          (choice == null) ? "" : choice;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05),
                        imageSelection,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: height,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: light,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Card newCard = Card();
                        newCard.name = cardName;
                        newCard.quality = cardQuality;
                        newCard.quantity =
                            cardQuantity == "" ? 0 : int.parse(cardQuantity);
                        newCard.idiom = cardIdiom;
                        newCard.img = base64Encode(cardImage);
                        newCard.collectionId = widget.collection.id;
                        if (index != -1) {
                          // cards[index] = newCard;
                          newCard.id = cards[index].id;
                          helper.updateCard(newCard);
                        } else {
                          cardsAdded++;
                          helper.saveCard(newCard);
                          // cards.add(newCard);
                        }
                        setState(() {
                          getAllCards();
                          builtCards = buildCards(context);
                        });
                        editing = false;
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Salvar",
                        style: TextStyle(fontSize: 22.0, color: dark),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      editing = false;
    });
  }

  Widget buildCards(BuildContext context) {
    print("Buildando cartas: $cards");
    return GridView.builder(
      padding: const EdgeInsets.all(15.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 63.0 / 88.0,
      ),
      itemCount: cards.length + 1,
      itemBuilder: (context, index) {
        if (index == cards.length) {
          return GestureDetector(
            onTap: () => addCard(context, -1),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: midUp,
              ),
              child: Icon(
                Icons.add,
                color: dark,
                size: 65.0,
              ),
            ),
          );
        } else {
          Card card = cards[index];
          return GestureDetector(
            onTap: () {
              addCard(context, index);
            },
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: NetworkImage(card["image"]),
                      image: MemoryImage(base64Decode(card.img)),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 0.0,
                  child: Container(
                    color: light,
                    child: Text(
                      "${card.quantity}x",
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
