class GeneralFunctions {
  String formatIndianNumber(String number) {
    // Convert the string to an integer to avoid leading zeros issues
    int num = int.parse(number);

    // Convert back to string after parsing
    String numStr = num.toString();

    // Check if number is less than 1000, no need to format
    if (numStr.length <= 3) return numStr;

    // Handle the first group (before the commas)
    String lastThree = numStr.substring(numStr.length - 3);
    String rest = numStr.substring(0, numStr.length - 3);

    // Add a comma after every two digits in the rest of the number
    String formattedRest =
        rest.replaceAllMapped(RegExp(r'(\d+)(\d{2})'), (Match match) {
      return '${match[1]},${match[2]}';
    });

    return '$formattedRest,$lastThree';
  }
}
