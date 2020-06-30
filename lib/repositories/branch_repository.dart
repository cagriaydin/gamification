import 'package:dio/dio.dart';
import 'package:yorglass_ik/models/branch.dart';
import 'package:yorglass_ik/models/branch_leader_board.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';
import 'package:yorglass_ik/repositories/image-repository.dart';

class BranchRepository {
  static final BranchRepository _instance =
      BranchRepository._privateConstructor();

  BranchRepository._privateConstructor() {
    getBranchList();
  }

  List<Branch> _branchList;
  static BranchRepository get instance => _instance;

  Future<List<BranchLeaderBoard>> getBoardPointList() async {
    List<BranchLeaderBoard> list = [];

    Response branchLeaderBoardRes = await RestApi.instance.dio
        .get('/branchleaderboard/getAllBranchLeaderBoard');
    if (branchLeaderBoardRes.data != null) {
      list = branchLeaderBoardListFromJson(branchLeaderBoardRes.data);
    }
    return list;
  }

  Future<List<Branch>> getBranchList() async {
    if (_branchList == null) {
      _branchList = [];

      Response branchRes =
          await RestApi.instance.dio.get('/branch/getAllBranch');
      if (branchRes.data != null) {
        _branchList = branchListFromJson(branchRes.data);
        for (var branch in _branchList) {
          ImageRepository.instance.getImage(branch.image);
        }
      }
    }
    return _branchList;
  }

  Future<List<Branch>> getTopBranchPointList() async {
    var branchList = await getBranchList();
    branchList.sort((a, b) => b.point.compareTo(a.point));
    branchList = branchList.take(3).toList();
    return branchList;
  }

  Future<Branch> getBranch(String id) async {
    if (_branchList != null &&
        _branchList.where((element) => element.id == id).length > 0) {
      return _branchList.where((element) => element.id == id).elementAt(0);
    }
    Branch branch;
    Response branchRes = await RestApi.instance.dio.get('/branch/byId/$id');
    if (branchRes != null) {
      branch = Branch.fromJson(branchRes.data);
    }
    return branch;
  }
}
