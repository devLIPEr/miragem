import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miragem/common/alert.dart';
import 'package:miragem/common/custom_colors.dart';
import 'package:miragem/components/custom_button.dart';
import 'package:miragem/components/custom_imagepicker.dart';
import 'package:miragem/components/custom_textfield.dart';
import 'package:miragem/helper/collection_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miragem/views/cards_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  CollectionHelper helper = CollectionHelper();
  // List<Collection> collections = [
  //   Collection.fromMap({idColumn: 0, nameColumn: "Col1", amountColumn: 12})
  // ];
  List<Collection> collections = [];
  TextEditingController nameController = TextEditingController();
  bool collectionEdited = false;

  @override
  void initState() {
    super.initState();
    getAllCollections();
  }

  void getAllCollections() {
    helper.getAllCollections().then((list) {
      setState(() {
        collections = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        backgroundColor: CustomColors.background,
        title: const Text(
          "COLEÇÕES",
          style: TextStyle(color: CustomColors.dark, fontSize: 32.0),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: SizedBox(
        // https://stackoverflow.com/questions/52786652/how-to-change-the-size-of-floatingactionbutton
        width: 64.0,
        height: 64.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: CustomColors.light,
            onPressed: () {
              showOpts(context);
            },
            child: const Icon(Icons.add, color: CustomColors.dark, size: 32.0),
          ),
        ),
      ),
      body: Container(
        color: CustomColors.background,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: collections.length,
          itemBuilder: ((context, index) => collectionCard(context, index)),
        ),
      ),
    );
  }

  Widget collectionCard(BuildContext context, int index) {
    Collection collection = collections[index];
    return GestureDetector(
      onTap: () {
        showEditOpts(context, index);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: CustomColors.highlight,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: collection.image != null
                        ? FileImage(File(collection.image))
                        : const AssetImage("assets/imgs/questionMark.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        collection.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.light,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "${collection.amount} Cartas",
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: CustomColors.light,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showEditOpts(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              color: CustomColors.highlight,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60.0,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: CustomColors.light,
                    ),
                    width: 350.0,
                    child: TextButton(
                      onPressed: () async {
                        // go to card page
                        final int cardsAdded = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CardPage(
                                    collections[index],
                                  )),
                        );

                        setState(() {
                          getAllCollections();
                        });

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    height: 60.0,
                    width: 350.0,
                    text: "Visualizar",
                  ),
                  const SizedBox(height: 16.0),
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                      showOpts(context, collection: collections[index]);
                    },
                    height: 60.0,
                    width: 350.0,
                    text: "Editar",
                  ),
                  const SizedBox(height: 16.0),
                  CustomButton(
                    onTap: () {
                      customAlert(
                        context,
                        "Tem certeza?",
                        24.0,
                        "Você tem certeza que quer excluir a coleção ${collections[index].name}?\nEste processo não pode ser revertido!",
                        20.0,
                        [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.dark),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(
                                color: CustomColors.light,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              helper.deleteCollection(collections[index].id);
                              setState(() {
                                collections.removeAt(index);
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.alert),
                            child: const Text(
                              "Deletar",
                              style: TextStyle(
                                color: CustomColors.light,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    height: 60.0,
                    width: 350.0,
                    text: "Deletar",
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showOpts(BuildContext context, {Collection collection}) {
    Collection editedColection = (collection != null)
        ? Collection.fromMap(collection.toMap())
        : Collection();
    nameController.text = (collection != null) ? collection.name : "";
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                // https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: CustomColors.highlight,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        controller: nameController,
                        hintText: "Nome da Coleção...",
                        obscureText: false,
                        height: 60.0,
                        width: 350.0,
                        onChanged: (value) {
                          collectionEdited = true;
                          setState(() {
                            editedColection.name = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      CustomImagePicker(
                        onTap: () {
                          ImagePicker().pickImage(source: ImageSource.gallery)
                              .then((file) {
                            setState(() {
                              editedColection.image = file.path;
                            });
                          });
                        },
                        height: 60.0,
                        width: 350.0,
                      ),
                      const SizedBox(height: 16.0),
                      CustomButton(
                        onTap: () async {
                          if (nameController.text.isNotEmpty) {
                            if (collection != null) {
                              await helper.updateCollection(editedColection);
                            } else {
                              editedColection.amount = 0;
                              await helper.saveCollection(editedColection);
                            }
                            Navigator.pop(context);
                            getAllCollections();
                          } else {
                            customAlert(
                              context,
                              "O nome da coleção é obrigatório",
                              22.0,
                              "",
                              0,
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
                          }
                        },
                        height: 60.0,
                        width: 100.0,
                        text: "Salvar",
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
