import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/models/user_leader_board.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._privateConstructor();

  UserRepository._privateConstructor();

  static UserRepository get instance => _instance;

  List<UserLeaderBoard> getUserPointList() {
    List<UserLeaderBoard> list = List<UserLeaderBoard>();
    list.add(UserLeaderBoard(id: "1", userId: "1", point: 450));
    list.add(UserLeaderBoard(id: "2", userId: "2", point: 435));
    list.add(UserLeaderBoard(id: "3", userId: "3", point: 300));
    list.add(UserLeaderBoard(id: "4", userId: "4", point: 100));
    list.add(UserLeaderBoard(id: "5", userId: "5", point: 250));
    list.add(UserLeaderBoard(id: "6", userId: "6", point: 70));
    list.add(UserLeaderBoard(id: "7", userId: "7", point: 70));
    list.add(UserLeaderBoard(id: "8", userId: "8", point: 70));
    list.add(UserLeaderBoard(id: "9", userId: "9", point: 70));
    list.add(UserLeaderBoard(id: "10", userId: "10", point: 70));
    list.add(UserLeaderBoard(id: "11", userId: "11", point: 70));
    list.sort((a, b) => b.point.compareTo(a.point));
    return list;
  }

  List<User> getUserList() {
    List<User> list = List<User>();
    list.add(User(id: "1", name: "Çağrı Aydın", point: 200, branchId: "1"));
    list.add(User(id: "2", name: "Oğuz Akpınar", point: 200, branchId: "2"));
    list.add(User(id: "3", name: "Selin Aydın", point: 200, branchId: "3"));
    list.add(User(id: "4", name: "Onat Çipli", point: 200, branchId: "4"));
    list.add(User(id: "5", name: "Mustafa Berkay", point: 200, branchId: "5"));
    list.add(User(id: "6", name: "Ramazan Demir", point: 200, branchId: "6"));
    list.add(User(id: "7", name: "Ramazan Demir", point: 200, branchId: "6"));
    list.add(User(id: "8", name: "Ramazan Demir", point: 200, branchId: "6"));
    list.add(User(id: "9", name: "Ramazan Demir", point: 200, branchId: "6"));
    list.add(User(id: "10", name: "Ramazan Demir", point: 200, branchId: "6"));
    list.add(User(id: "11", name: "Ramazan Demir", point: 200, branchId: "6"));
    return list;
  }

  int getUserRank(){
  }
}
