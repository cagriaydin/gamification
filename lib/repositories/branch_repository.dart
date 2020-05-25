import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/branch.dart';
import 'package:yorglass_ik/models/branch_leader_board.dart';
import 'package:yorglass_ik/repositories/image-repository.dart';
import 'package:yorglass_ik/repositories/task-repository.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class BranchRepository {
  static final BranchRepository _instance = BranchRepository._privateConstructor();

  BranchRepository._privateConstructor() {
    getBranchList();
  }

  List<Branch> _branchList;
  static BranchRepository get instance => _instance;

  Future<List<BranchLeaderBoard>> getBoardPointList() async {
    Results res = await DbConnection.query("SELECT * FROM branchleaderboard where enddate IS NULL ORDER BY point DESC");
    List<BranchLeaderBoard> list = [];
    if (res.length > 0) {
      forEach(res, (element) {
        list.add(BranchLeaderBoard(branchId: element[0], point: element[1]));
      });
    }
    return list;
  }

  Future<List<Branch>> getBranchList() async {
    if (_branchList == null) {
      Results res = await DbConnection.query("SELECT branch.*, bl.point FROM branch, branchleaderboard as bl WHERE branch.id = bl.branchid AND bl.enddate IS NULL");
      _branchList = [];
      if (res.length > 0) {
        for (Row element in res) {
          _branchList.add(Branch(
            id: element[0],
            name: element[1],
            image: element[2],
            employeeCount: element[3],
            color: element[4],
            point: element[5],
          ));
          ImageRepository.instance.getImage(element[2]);
        }
      }
    }
    return _branchList;
  }

  Future<List<Branch>> getTopBranchPointList() async {
    var branchList = await getBranchList();
    branchList.sort((a, b) => a.point.compareTo(b.point));
    branchList = branchList.take(3).toList();
    return branchList;
  }

  Future<Branch> getBranch(String id) async {
    if (_branchList != null && _branchList.where((element) => element.id == id).length > 0) {
      return _branchList.where((element) => element.id == id).elementAt(0);
    }
    Results res = await DbConnection.query(
      "SELECT branch.*, bl.point FROM branch, branchleaderboard as bl WHERE branch.id = bl.branchid AND bl.enddate IS NULL AND branch.id = ?",
      [id],
    );
    return Branch(
      id: res.single[0],
      name: res.single[1],
      image: res.single[2],
      employeeCount: res.single[3],
      color: res.single[4],
      point: res.single[5],
    );
  }
}
