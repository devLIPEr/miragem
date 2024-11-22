import 'dart:io';

import 'package:flutter/material.dart' hide Card;
import 'package:image_picker/image_picker.dart';
import 'package:miragem/common/alert.dart';
import 'package:miragem/helper/card_helper.dart';
import 'package:miragem/helper/collection_helper.dart';

import '../common/custom_colors.dart';

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
  Idiom cardIdiom = Idiom.PT;
  Quality cardQuality = Quality.NM;
  String cardName = "";
  String cardImage = "";
  String cardQuantity = "";

  bool editing = false;
  bool bottomSheetOnScreen = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController qntController = TextEditingController();

  Widget builtCards = Container();
  Widget imageSelection = Container();

  int cardsAdded = 0;

  CardHelper cardHelper = CardHelper();
  CollectionHelper collectionHelper = CollectionHelper();

  @override
  void initState() {
    super.initState();

    collectionName = "${widget.collection.name}, id: ${widget.collection.id}";
    getAllCards();

    cardHelper.getAllCardsOfAllCollections().then((list){
      for(Card element in list){
        print(element);
      }
    });
  }

  void getAllCards() {
    cardHelper.getAllCards(widget.collection.id).then((list) {
      setState(() {
        cards = list;
        builtCards = buildCards(context);
      });
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
          style: const TextStyle(
            color: CustomColors.dark,
            fontSize: 30,
          ),
        ),
        backgroundColor: CustomColors.background,
        elevation: 0.0,
      ),
      backgroundColor: CustomColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomSheetOnScreen = true;
          addCard(context, -1);
        },
        backgroundColor: CustomColors.highlight,
        child: const Icon(
          Icons.add,
          color: CustomColors.dark,
        ),
      ),
      body: builtCards,
    );
  }

  void addCard(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Card card = (index == -1) ? null : cards[index];
            if (bottomSheetOnScreen && card != null && !editing) {
              cardImage = card.img;
              cardIdiom = card.idiom;
              cardQuality = card.quality;
              cardQuantity = card.quantity.toString();
              cardName = card.name;
              nameController.text = cardName;
              qntController.text = cardQuantity;
              editing = true;
            } else if (bottomSheetOnScreen && !editing) {
              cardImage = "";
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
                cardImage = "";
                cardQuantity = "";
                cardName = "";
                editing = false;
              },
              backgroundColor: CustomColors.highlight,
              builder: (context) {
                const double height = 60.0;
                imageSelection = GestureDetector(
                  onTap: () {
                    ImagePicker()
                        .pickImage(source: ImageSource.gallery)
                        .then((file) async {
                      if (file != null) {
                        setState(() {
                          cardImage = file.path;
                        });
                      }
                    });
                  },
                  child: Container(
                    height: height,
                    width: MediaQuery.of(context).size.width * 0.425,
                    decoration: BoxDecoration(
                      color: CustomColors.light,
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
                              (cardImage == "")
                                  ? const Icon(Icons.attach_file)
                                  : Image.file(File(cardImage)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
                List<Widget> buttons = [
                  Container(
                    height: height,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: CustomColors.light,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (cardName == "") {
                          customAlert(
                            context,
                            "O campo nome da carta é obrigatório",
                            25.0,
                            "Insira um nome para salvar",
                            20.0,
                            [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.dark),
                                child: const Text(
                                  "Ok!",
                                  style: TextStyle(
                                      color: CustomColors.light,
                                      fontSize: 16.0),
                                ),
                              )
                            ],
                          );
                        } else {
                          Card newCard = Card();
                          newCard.name = cardName;
                          newCard.quality = cardQuality;
                          newCard.quantity =
                              cardQuantity == "" ? 0 : int.parse(cardQuantity);
                          newCard.idiom = cardIdiom;
                          newCard.img = cardImage;
                          newCard.collectionId = widget.collection.id;
                          if (index != -1) {
                            newCard.id = cards[index].id;
                            cardHelper.updateCard(newCard);
                          } else {
                            cardsAdded++;
                            cardHelper.saveCard(newCard);
                            Collection updatedCollection = Collection();
                            updatedCollection.amount =
                                widget.collection.amount + 1;
                            updatedCollection.id = widget.collection.id;
                            updatedCollection.image = widget.collection.image;
                            updatedCollection.name = widget.collection.name;
                            collectionHelper
                                .updateCollection(updatedCollection);
                          }
                          setState(() {
                            getAllCards();
                            builtCards = buildCards(context);
                          });
                          editing = false;
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Salvar",
                        style:
                            TextStyle(fontSize: 22.0, color: CustomColors.dark),
                      ),
                    ),
                  )
                ];
                if (index != -1) {
                  buttons.add(Container(
                    height: height,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: CustomColors.light,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        cardHelper.deleteCard(cards[index].id).then(
                          (value) {
                            setState(() {
                              cardsAdded--;
                              Collection updatedCollection = Collection();
                              updatedCollection.amount =
                                  widget.collection.amount - 1;
                              updatedCollection.id = widget.collection.id;
                              updatedCollection.image = widget.collection.image;
                              updatedCollection.name = widget.collection.name;
                              collectionHelper
                                  .updateCollection(updatedCollection)
                                  .then(
                                (value) {
                                  getAllCards();
                                  builtCards = buildCards(context);
                                  editing = false;
                                  Navigator.pop(context);
                                },
                              );
                            });
                          },
                        );
                      },
                      child: const Text(
                        "Excluir",
                        style: TextStyle(fontSize: 22.0, color: Colors.red),
                      ),
                    ),
                  ));
                }
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
                          cursorColor: CustomColors.highlight,
                          decoration: InputDecoration(
                            constraints: const BoxConstraints.expand(),
                            filled: true,
                            labelText: "Nome da carta",
                            labelStyle:
                                const TextStyle(color: CustomColors.dark),
                            floatingLabelStyle: const TextStyle(
                                color: CustomColors.dark,
                                fontWeight: FontWeight.bold),
                            fillColor: CustomColors.light,
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
                                color: CustomColors.light,
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
                                              value: Quality.M,
                                              child: Text("M")),
                                          DropdownMenuItem(
                                              value: Quality.NM,
                                              child: Text("NM")),
                                          DropdownMenuItem(
                                              value: Quality.SP,
                                              child: Text("SP")),
                                          DropdownMenuItem(
                                              value: Quality.MP,
                                              child: Text("MP")),
                                          DropdownMenuItem(
                                              value: Quality.HP,
                                              child: Text("HP")),
                                          DropdownMenuItem(
                                              value: Quality.D,
                                              child: Text("D")),
                                        ],
                                        onChanged: (choice) {
                                          setState(() {
                                            cardQuality =
                                                (choice == null) ? "" : choice;
                                          });
                                        },
                                        dropdownColor: CustomColors.light,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
                            SizedBox(
                              height: height,
                              width: MediaQuery.of(context).size.width * 0.425,
                              child: TextField(
                                onChanged: (value) {
                                  cardQuantity = value;
                                },
                                controller: qntController,
                                cursorColor: CustomColors.highlight,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: "Quantidade",
                                  labelStyle:
                                      const TextStyle(color: CustomColors.dark),
                                  floatingLabelStyle: const TextStyle(
                                      color: CustomColors.dark,
                                      fontWeight: FontWeight.bold),
                                  fillColor: CustomColors.light,
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
                                color: CustomColors.light,
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
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
                            imageSelection,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: buttons,
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
        );
      },
    ).then((value) {
      setState(() {
        editing = false;
        bottomSheetOnScreen = false;
      });
    });
  }

  Widget buildCards(BuildContext context) {
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
            onTap: () {
              bottomSheetOnScreen = true;
              addCard(context, -1);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: CustomColors.highlight,
              ),
              child: const Icon(
                Icons.add,
                color: CustomColors.dark,
                size: 65.0,
              ),
            ),
          );
        } else {
          Card card = cards[index];
          return GestureDetector(
            onTap: () {
              bottomSheetOnScreen = true;
              addCard(context, index);
            },
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: card.img != ""
                          ? FileImage(File(card.img))
                          : const AssetImage("assets/imgs/questionMark.png"),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 0.0,
                  child: Container(
                    color: CustomColors.light,
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
