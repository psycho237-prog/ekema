class Procedure {
  final String id;
  final String category;
  final String title;
  final String description;
  final List<Question> questions;
  final List<String> documents;
  final List<ProcedureStep> steps;
  final List<ProcedureLocation> locations;

  Procedure({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.questions,
    required this.documents,
    required this.steps,
    required this.locations,
  });

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      documents: List<String>.from(json['documents']),
      steps: (json['steps'] as List)
          .map((s) => ProcedureStep.fromJson(s))
          .toList(),
      locations: (json['locations'] as List)
          .map((l) => ProcedureLocation.fromJson(l))
          .toList(),
    );
  }
}

class Question {
  final String id;
  final String text;
  final List<String> options;

  Question({
    required this.id,
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
    );
  }
}

class ProcedureStep {
  final String title;
  final String description;
  final String cost;
  final String time;

  ProcedureStep({
    required this.title,
    required this.description,
    required this.cost,
    required this.time,
  });

  factory ProcedureStep.fromJson(Map<String, dynamic> json) {
    return ProcedureStep(
      title: json['title'],
      description: json['description'],
      cost: json['cost'],
      time: json['time'],
    );
  }
}

class ProcedureLocation {
  final String name;
  final double lat;
  final double lon;
  final String address;
  final String phone;

  ProcedureLocation({
    required this.name,
    required this.lat,
    required this.lon,
    required this.address,
    required this.phone,
  });

  factory ProcedureLocation.fromJson(Map<String, dynamic> json) {
    return ProcedureLocation(
      name: json['name'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      address: json['address'],
      phone: json['phone'],
    );
  }
}
