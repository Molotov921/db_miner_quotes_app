import 'package:db_miner_quotes_app/helper/api_helper.dart';
import 'package:db_miner_quotes_app/helper/quotesdatabase_helper.dart';
import 'package:db_miner_quotes_app/models/quotes_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class QuoteController extends GetxController {
  var quotes = <Quote>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void addToFavorites(Quote quote) async {
    quote.isFavorite.toggle();
    if (quote.isFavorite.value) {
      await DatabaseHelper.instance.insertQuote(quote);
    } else {
      await DatabaseHelper.instance.deleteQuote(quote.id);
    }
  }

  void fetchData() async {
    try {
      var fetchedQuotes = await APIHelper.apiHelper.fetchedQuote();
      print('Fetched Quotes: $fetchedQuotes'); // Debug print
      if (fetchedQuotes != null) {
        var quotesFromDB = await DatabaseHelper.instance.getQuotes();
        print('Quotes from DB: $quotesFromDB'); // Debug print
        for (var quote in fetchedQuotes) {
          var isFavorite =
              quotesFromDB.any((dbQuote) => dbQuote.id == quote.id);
          quote.isFavorite = isFavorite.obs;
        }
        quotes.assignAll(fetchedQuotes);
        print('Assigned Quotes: $quotes'); // Debug print
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> refreshQuotes() async {
    try {
      var newFetchedQuotes = await APIHelper.apiHelper.fetchedQuote();
      print('New Fetched Quotes: $newFetchedQuotes'); // Debug print
      if (newFetchedQuotes != null) {
        var quotesFromDB = await DatabaseHelper.instance.getQuotes();
        print('Quotes from DB: $quotesFromDB'); // Debug print
        for (var quote in newFetchedQuotes) {
          var isFavorite =
              quotesFromDB.any((dbQuote) => dbQuote.id == quote.id);
          quote.isFavorite = isFavorite.obs;
        }
        quotes.assignAll(newFetchedQuotes);
        print('New Assigned Quotes: $quotes'); // Debug print
      }
    } catch (e) {
      print('Error refreshing quotes: $e');
    }
  }
}
