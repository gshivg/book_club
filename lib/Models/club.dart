class ClubModel {
  String? name;
  String? uid;
  String? description;
  String? topic;

  String? ownerID;
  List<String?> adminsIDs = [];
  List<String?> membersIDs = [];

  String? searchTag;

  DateTime? createdAt;
  DateTime? updatedAt;

  ClubModel(
    this.name,
    this.uid,
    this.description,
    this.topic,
    this.ownerID,
    this.adminsIDs,
    this.membersIDs,
    this.createdAt,
    this.updatedAt,
    this.searchTag,
  );

  ClubModel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    uid = map['uid'];
    description = map['description'];
    topic = map['topic'];
    ownerID = map['ownerID'];

    // adminsIDs = map['adminsIDs'];
    for (var adminId in map['adminsIDs']) {
      adminsIDs.add(adminId);
    }
    // membersIDs = map['membersIDs'];
    for (var memberId in map['membersIDs']) {
      membersIDs.add(memberId);
    }

    createdAt = map['createdAt'].toDate();
    updatedAt = map['updatedAt'].toDate();

    searchTag = map['searchTag'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'description': description,
      'topic': topic,
      'ownerID': ownerID,
      'adminsIDs': adminsIDs,
      'membersIDs': membersIDs,
      'searchTag': searchTag,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  updateClubModel({
    String? name,
    String? uid,
    String? description,
    String? topic,
    String? ownerID,
  }) {
    this.name = name ?? this.name;
    searchTag =
        name == null ? searchTag : name.toLowerCase().replaceAll(' ', '');
    this.uid = uid ?? this.uid;
    this.description = description ?? this.description;
    this.topic = topic ?? this.topic;
    this.ownerID = ownerID ?? this.ownerID;
    updatedAt = DateTime.now();
  }

  addAdmin(String? adminID) {
    adminsIDs.add(adminID);
  }

  addMember(String? memberID) {
    membersIDs.add(memberID);
  }

  removeAdmin(String? adminID) {
    adminsIDs.remove(adminID);
  }

  removeMember(String? memberID) {
    membersIDs.remove(memberID);
  }
}
