import 'dart:convert';

import 'package:flag_app/controllers/country_continent_controller.dart';
import 'package:flag_app/models/country_model.dart';
import 'package:flag_app/repos/country_repo.dart';
import 'package:get/get.dart';

class CountryController extends GetxController implements GetxService {
  CountryRepo countryRepo;

  CountryController({required this.countryRepo});

  int _countryCount = 0;
  List<CountryModel> _countries = [];
  List<CountryModel> get getCountries => _countries;

  Future<void> readCountries() async {
    final list =
        json.decode(await countryRepo.readCountries()) as List<dynamic>;
    _countries = [];
    _countries = list.map((e) => CountryModel.fromJson(e)).toList();
    Get.find<CountryContinentController>()
        .readCountries()
        .then((value) => removeUnUsed());
    update();
    _countries.shuffle();
  }

  void removeUnUsed() {
    List<CountryModel> result = [];
    Get.find<CountryContinentController>().getCountries.forEach((continent) {
      _countries.forEach((country) {
        if (country.countryName == continent.country) {
          result.add(country);
        }
      });
    });
    _countries = result;
  }

  String getCountryCode(String country) {
    String countryCode = 'error';
    _countries.forEach((element) {
      if (country == element.countryName) {
        countryCode = element.countryCode!;
      }
    });
    return countryCode;
  }

  CountryModel getACountry() {
    if (_countries.isEmpty) {
      readCountries();
    }
    if (_countryCount == 0) {
      _countries.shuffle();
    }
    CountryModel result = _countries[_countryCount];
    _countryCount++;
    if (_countryCount >= _countries.length) {
      _countryCount = 0;
    }
    return result;
  }

  void resetCount() {
    _countryCount = 0;
  }

  CountryModel getCountryByName(String countryName) {
    CountryModel? country;

    for (var element in _countries) {
      if (element.countryName == countryName) {
        country = element;
      }
    }
    return country!;
  }

  List<CountryModel> generateCountries(String selectedCountry, int amount) {
    if (_countries.isEmpty) {
      readCountries();
    }

    List<CountryModel> all = _countries;
    List<CountryModel> result = [];
    int count = amount - 2;

    for (var country in _countries) {
      if (country.countryName == selectedCountry) {
        result.add(country);
      }
    }

    for (int i = 0; i <= count; i++) {
      if (all[i].countryName == selectedCountry) {
        count++;
      } else {
        result.add(all[i]);
      }
    }
    result.shuffle();
    update();

    return result;
  }
}
