String formatCreatedDate(DateTime createdAt) {
  var dateParse = DateTime.parse(createdAt.toString());

  var formattedDate = "${dateParse.day.toString().padLeft(2, "0")}.${dateParse.month.toString().padLeft(2, "0")}.${dateParse.year} - ${dateParse.hour.toString().padLeft(2, "0")}:${dateParse.minute.toString().padLeft(2, "0")}";

  return formattedDate;
}
