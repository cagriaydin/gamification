import 'dart:async';

import 'package:dio/src/response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:yorglass_ik/models/task.dart';
import 'package:yorglass_ik/models/user-task.dart';
import 'package:yorglass_ik/repositories/dio_repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

forEach(Iterable list, Function(dynamic) function) {
  for (var element in list) {
    function(element);
  }
}

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._privateConstructor();

  TaskRepository._privateConstructor();

  static TaskRepository get instance => _instance;

  StreamController<List<UserTask>> _currentTasks = BehaviorSubject();

  Stream get currentUserTasks => _currentTasks.stream;

  Future<List<UserTask>> getUserTasks() async {
    List<Task> taskList = [];
    Response allTaskResponse = await RestApi.instance.dio.get(
      '/task/getAllTasks',
    );
    if (allTaskResponse.data != null) {
      taskList = taskListFromJson(allTaskResponse.data);
    }

    Response userTaskResponse = await RestApi.instance.dio.get(
      '/usertask/getUserTasks/${AuthenticationService.verifiedUser.id}',
    );
    List<UserTask> userTaskList = [];
    if (userTaskResponse.data != null) {
      userTaskList = userTaskListFromJson(userTaskResponse.data);
      print(userTaskList.length);
    }

    forEach(taskList, (task) {
      List<UserTask> tasks = userTaskList.where((userTask) {
        return userTask.taskId == task.id;
      }).toList();
      if (tasks.length > 0) {
        UserTask userTask = tasks.first;
        userTask.task = task;
        if (userTask.complete == 1) {
          if (task.interval == null) {
            userTaskList.remove(userTask);
            createNewUserTask(task, userTaskList);
          } else {
            DateTime startTime;
            if (task.interval == 1) {
              startTime = _getBeginingOfDay(DateTime.now());
            } else if (task.interval == 2) {
              startTime = _getBeginingOfWeek(DateTime.now());
            } else if (task.interval == 3) {
              startTime = _getBeginingOfMonth(DateTime.now());
            }
            if (userTask.lastUpdate.compareTo(startTime) < 0) {
              userTaskList.remove(userTask);
              createNewUserTask(task, userTaskList);
            }
          }
        } else {
          if (userTask.nextdeadline.compareTo(DateTime.now()) < 0) {
            userTaskList.remove(userTask);
            createNewUserTask(task, userTaskList);
          }
        }
      } else {
        createNewUserTask(task, userTaskList);
      }
    });
    userTaskList.sort((a, b) => a.task.name.compareTo(b.task.name));
    _currentTasks.add(userTaskList);
    return userTaskList;
  }

  void createNewUserTask(Task task, List<UserTask> userTaskList) {
    DateTime nextActive;
    DateTime nextDeadline;
    if (task.interval == 1) {
      nextActive = _getBeginingOfDay(DateTime.now());
      nextDeadline = _getEndOfDay(DateTime.now());
    } else if (task.interval == 2) {
      nextActive = _getBeginingOfWeek(DateTime.now());
      nextDeadline = _getEndOfWeek(DateTime.now());
    } else if (task.interval == 3) {
      nextActive = _getBeginingOfMonth(DateTime.now());
      nextDeadline = _getEndOfMonth(DateTime.now());
    } else {}
    userTaskList.add(
      UserTask(
        taskId: task.id,
        userId: AuthenticationService.verifiedUser.id,
        count: 0,
        point: task.point,
        complete: 0,
        nextActive: nextActive,
        nextdeadline: nextDeadline,
        task: task,
      ),
    );
  }

  bool canUpdate(UserTask userTask) {
    if (userTask.complete == 1) {
      return false;
    } else {
      if (userTask.nextActive != null &&
          userTask.nextActive.compareTo(DateTime.now()) > 0) {
        return false;
      }
      if (userTask.nextdeadline != null &&
          userTask.nextdeadline.compareTo(DateTime.now()) < 0) {
        return false;
      }
    }
    return true;
  }

  Future<UserTask> updateUserTask(UserTask task) async {
    if (canUpdate(task)) {
      task.count = task.count + 1;
      if (task.count == task.task.count) {
        task.complete = 1;
        task.point = task.task.point;
      }
      task.lastUpdate = DateTime.now();
      if (task.task.renewableTime != null) {
        int days = task.task.renewableTime.toInt();
        int hours = 0;
        int minutes = 0;
        if (task.task.renewableTime > days) {
          double totalHours =
              (24 * (task.task.renewableTime - days)).toDouble();
          hours = totalHours.toInt();
          if (totalHours > hours) {
            double totalMins = 60 * (totalHours - hours);
            minutes = totalMins.toInt();
          }
        }
        DateTime next = calculateNextDate(minutes, hours, days, DateTime.now());
        DateTime nextDeadline = calculateNextDate(minutes, hours, days, next);
        task.nextActive = next;
        task.nextdeadline = nextDeadline;
      }
      return await _updateUserTaskData(task);
    } else {
      return task;
    }
  }

  Future<UserTask> _updateUserTaskData(UserTask task) async {
    Response post;
    if (task.id != null) {
      post = await RestApi.instance.dio
          .post('/usertask/updateUserTask', data: task.toJson());
      print(post.statusCode);
    } else {
      task.id = Uuid().v4();
      post = await RestApi.instance.dio
          .post('/usertask/insertUserTask', data: task.toJson());
    }
    if (post != null && post.data != null && post.statusCode == 200) {
      if (task.complete == 1) {
        await updateLeaderboardPoint(task.point);
      }
    }
    await updateUserInfo();
    return task;
  }

  Future updateLeaderboardPoint(int point) async {
    await RestApi.instance.dio.get(
      '/leaderboard/updatePoint/${AuthenticationService.verifiedUser.id}/$point',
    );
  }

  DateTime calculateNextDate(int minutes, int hours, int days, DateTime start) {
    if (minutes > 0 || hours > 0) {
      DateTime nextTime = start;
      if (days > 0) {
        nextTime = nextTime.add(new Duration(days: days));
      }
      if (hours > 0) {
        nextTime = nextTime.add(new Duration(hours: hours));
      }
      if (minutes > 0) {
        nextTime = nextTime.add(new Duration(minutes: minutes));
      }
      return nextTime;
    } else {
      DateTime nextTime = _getBeginingOfDay(start);
      nextTime = nextTime.add(new Duration(days: days));
      return nextTime;
    }
  }

  DateTime _getBeginingOfDay(DateTime date) {
    return new DateTime(date.year, date.month, date.day);
  }

  DateTime _getEndOfDay(DateTime date) {
    return _getBeginingOfDay(date)
        .add(new Duration(days: 1))
        .subtract(new Duration(milliseconds: 1));
  }

  DateTime _getBeginingOfWeek(DateTime date) {
    date = _getBeginingOfDay(date);
    return date.subtract(new Duration(days: date.weekday));
  }

  DateTime _getEndOfWeek(DateTime date) {
    date = _getBeginingOfDay(date);
    return date
        .add(new Duration(days: 7 - date.weekday))
        .subtract(new Duration(milliseconds: 1));
  }

  DateTime _getBeginingOfMonth(DateTime date) {
    return new DateTime(date.year, date.month, 1);
  }

  DateTime _getEndOfMonth(DateTime date) {
    int year = date.year;
    int month = date.month;
    if (month == 12) {
      month = 1;
      year++;
    } else {
      month++;
    }
    return new DateTime(year, month, 1).subtract(new Duration(milliseconds: 1));
  }

  Future updateUserInfo() async {
    var response = await RestApi.instance.dio.get(
      '/leaderboard/byId/${AuthenticationService.verifiedUser.id}',
    );
    if (response.statusCode == 200) {
      AuthenticationService.verifiedUser.point = response.data['point'];
    }
    List<UserTask> tasks = await TaskRepository.instance.getUserTasks();
    int count = 0;
    for (UserTask t in tasks) {
      if (!TaskRepository.instance.canUpdate(t)) count++;
    }
    AuthenticationService.verifiedUser.percentage =
        (count / tasks.length * 100).round();
    AuthenticationService.verifiedUser.taskCount = tasks.length - count;
  }
}
