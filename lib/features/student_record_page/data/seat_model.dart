class Seat {
  final String seatNo;
  final String status;

  Seat({required this.seatNo, required this.status});

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatNo: json['seat_no'],
      status: json['status'],
    );
  }
}

class SeatDetails {
  final int totalAvailable;
  final int totalReserved;
  final int totalAvailableSoon;
  final List<Seat> seats;

  SeatDetails({
    required this.totalAvailable,
    required this.totalReserved,
    required this.totalAvailableSoon,
    required this.seats,
  });

  factory SeatDetails.fromJson(Map<String, dynamic> json) {
    var seatList = json['seats'] as List;
    List<Seat> seatItems = seatList.map((i) => Seat.fromJson(i)).toList();

    return SeatDetails(
      totalAvailable: json['total_available'],
      totalReserved: json['total_reserved'],
      totalAvailableSoon: json['total_available_soon'],
      seats: seatItems,
    );
  }
}
