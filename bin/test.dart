import 'utils.dart';

enum TestResultEnum {
  success,
  failure
}

class Test {

  dynamic desiredResult, obtainedResult;
  String label;
  Function callback;

  Test({this.label, this.callback, this.desiredResult});

  void performTest() {
    obtainedResult = callback();
  }

  TestResultEnum get result => desiredResult == obtainedResult ? TestResultEnum.success : TestResultEnum.failure;

  @override
  String toString() => 'Test \"$label\":  ' + (result == TestResultEnum.success ? 'Success.  ' : 'Failure.  ') + '\nExpected \"$desiredResult\", obtained \"$obtainedResult\".';

}

class TestList {

  List<Test> tests;

  TestList(this.tests);

  void performTests() => tests.forEach((test) => test.performTest());

  int get numSuccesses => countInList(tests, TestResultEnum.success, (test) => test.result);

  List<Test> _getTestsWithResult(TestResultEnum result) {
    var filteredTests = <Test>[];
    tests.forEach((test) {
      if (test.result == result) {
        filteredTests.add(test);
      }
    });
    return filteredTests;
  }

  List<Test> get successfulTests => _getTestsWithResult(TestResultEnum.success);  
  List<Test> get failedTests => _getTestsWithResult(TestResultEnum.failure);  

  String get log {
    var output = '';
    if (successfulTests.isNotEmpty) {
      output += 'Successful tests (${successfulTests.length}/${tests.length}):\n';
      successfulTests.forEach((test) => output += test.toString() + '\n');
    }
    if (failedTests.isNotEmpty) {
      output += '\nFailed tests (${failedTests.length}/${tests.length}):\n';
      failedTests.forEach((test) => output += test.toString() + '\n');
    }
    output += failedTests.isEmpty ? '\nAll tests passed.' : '\n${failedTests.length} failed tests.';
    return output;
  }

}

void main() {
  var testList = TestList(
    [
      Test(
        label: '1+3',
        callback: () => 1+3,
        desiredResult: 4
      ),
      Test(
        label: '3*4',
        callback: () => 3*4,
        desiredResult: 12,
      )
    ]
  );

  testList.performTests();
  print(testList.log);
}