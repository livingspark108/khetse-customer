class TimeSlot {
  String? timeslot;
  String? availability;

  TimeSlot({this.timeslot, this.availability});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    timeslot = json["timeslot"];
    availability = json["availability"] ?? json["availibility"];
  }

  Map<String, dynamic> toJson() => {
    "timeslot": timeslot,
    "availability": availability,
  };
}
