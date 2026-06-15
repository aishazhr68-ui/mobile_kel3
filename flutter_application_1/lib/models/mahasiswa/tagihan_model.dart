class TagihanModel {
  final String namaTagihan;
  final String jatuhTempo;
  final int nominal;
  bool selected;

  TagihanModel({
    required this.namaTagihan,
    required this.jatuhTempo,
    required this.nominal,
    this.selected = false,
  });

  factory TagihanModel.fromJson(Map<String, dynamic> json) {
    return TagihanModel(
      namaTagihan: json['namaTagihan'] ?? '',
      jatuhTempo: json['jatuhTempo'] ?? '',
      nominal: json['nominal'] ?? 0,
      selected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namaTagihan': namaTagihan,
      'jatuhTempo': jatuhTempo,
      'nominal': nominal,
    };
  }
}