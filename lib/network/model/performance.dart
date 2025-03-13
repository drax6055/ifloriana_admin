class PerformanceModel {
  List<Performance> performance;

  PerformanceModel({required this.performance});

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    var list = json['Performance'] as List;
    List<Performance> performanceList =
        list.map((i) => Performance.fromJson(i)).toList();

    return PerformanceModel(performance: performanceList);
  }

  Map<String, dynamic> toJson() {
    return {
      'Performance': performance.map((e) => e.toJson()).toList(),
    };
  }
}

class Performance {
  String label;
  dynamic number;

  Performance({required this.label, required this.number});

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      label: json['label'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'number': number,
    };
  }
}
