import 'package:clipboard/clipboard.dart';
import 'package:db_miner_quotes_app/helper/quotesdatabase_helper.dart';
import 'package:db_miner_quotes_app/models/quotes_model.dart';
import 'package:db_miner_quotes_app/views/home/homepage_controller.dart';
import 'package:db_miner_quotes_app/views/home/screen/favorite_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class Homepage extends StatelessWidget {
  final QuoteController quoteController = Get.put(QuoteController());
  final dbHelper = DatabaseHelper.instance;

  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/quotes_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                title: Hero(
                  tag: 'Quotes',
                  flightShuttleBuilder: (context, _, __, ___, ____) {
                    return const Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Text(
                        "Quotes",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Quotes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                centerTitle: true,
                leading: const SizedBox(),
                actions: [
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        PopupMenuItem(
                          child: const Text("Favorite"),
                          onTap: () {
                            Get.to(const FavoritesScreen());
                          },
                        ),
                      ];
                    },
                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                child: Obx(
                  () {
                    if (quoteController.quotes.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: quoteController.quotes.length,
                        itemBuilder: (context, index) {
                          Quote quote = quoteController.quotes[index];
                          return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 7.0,
                                  blurStyle: BlurStyle.solid,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 20,
                                    right: 20,
                                    bottom: 8,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Hero(
                                    tag: quote.quote,
                                    flightShuttleBuilder:
                                        (context, _, __, ___, ____) {
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                quote.quote,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Author: ${quote.author}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          quote.quote,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Author: ${quote.author}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          quoteController.addToFavorites(quote);
                                        },
                                        icon: Obx(
                                          () {
                                            return Icon(
                                              quote.isFavorite.value
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: quote.isFavorite.value
                                                  ? Colors.red
                                                  : Colors.white,
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          FlutterClipboard.copy(quote.quote)
                                              .then((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('Quote copied'),
                                              ),
                                            );
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.copy,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Share.share(quote.quote);
                                        },
                                        icon: const Icon(
                                          Icons.share_outlined,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
