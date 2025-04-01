class SeatClass {
  final String value;
  final String title;
  final String subtitle;

  SeatClass(this.value, this.title, this.subtitle);
}

final List<SeatClass> seatClassesData = [ // Rename to seatClassesData
  SeatClass('Economy', "Economy", "Fly at the lowest cost, with all your basic needs covered."),
  SeatClass('Premium Economy', "Premium Economy", "An affordable way to fly, with a tasty meal and bigger seats."),
  SeatClass('Business', "Business", "Fly in style, with exclusive check-in counters and seating."),
  SeatClass('First Class', "First Class", "The most luxurious class, with personalized five-star services."),
];