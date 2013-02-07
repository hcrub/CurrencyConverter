CurrencyConverter
=================

## Purpose 
* This application simply converts American(USD) to other currency forms. The application supports both iPhone and iPad devices running on iOS 6+ including all orientations.

## Information
* This application caches currency codes and symbols from Yahoo Finance in JSON format and parses them into a NSMutableDictionary.
*       http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json

* Since Yahoo Finance only references the currency exchange rates by International Symbols we download and parse another JSON which gives us the Country name for the code.
*       https://gist.github.com/Fluidbyte/2973986/raw/9ead0f85b6ee6071d018564fa5a314a0297212cc/Common-Currency.json

## Currencies Included

* Canadian dollars
* Euro
* United Arab Emirates Dirham
* Afghan Afghani
* Albanian Lek
* Armenian Dram
* Argentine Peso
* Australian Dollar
* Azerbaijani Manat
* Bosnia-Herzegovina Convertible Mark
* Bangladeshi Taka
* Bulgarian Lev
* Bahraini Dinar
* Burundian Franc
* Brunei Dollar
* Bolivian Boliviano
* Brazilian Real
* Botswanan Pula
* Belarusian Ruble
* Belize Dollar
* Congolese Franc
* Swiss Franc
* ~164 total
















