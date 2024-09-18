class Defaults {
  String deviceId = '';
  bool isCollecting = false;
  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  String measureName = '';
  int savedValue = 0;
  List<List<double>> receivedValues = [];
  List<Map<String, dynamic>> receivedIMUJsonValues = [];
  String url = 'https://tracker.elioslab.net/v1/'; //add /v1/ after the URL
  String tenantId = 'running-tenant';
  String deviceToken =
      'DVC eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkZXZpY2UiOnsiX2lkIjoiZWRnZS1tZXRlciIsImZlYXR1cmVzIjpbIklNVSIsIkVOViIsIk9SSSJdLCJ0aGluZ3MiOlsidXNlcjEiXSwidmlzaWJpbGl0eSI6InB1YmxpYyIsIm93bmVyIjoiNjVlMDYwNmQyZWU2ZDEwMDFmMjNiZTg5In0sInRlbmFudCI6eyJwYXNzd29yZGhhc2giOnRydWUsIl9pZCI6InJ1bm5pbmctdGVuYW50Iiwib3JnYW5pemF0aW9uIjoiTWVhc3VyaWZ5IG9yZyIsImFkZHJlc3MiOiJNZWFzdXJpZnkgU3RyZWV0LCBHZW5vdmEiLCJlbWFpbCI6ImluZm9AbWVhc3VyaWZ5Lm9yZyIsInBob25lIjoiKzM5MTAzMjE4NzkzODE3IiwiZGF0YWJhc2UiOiJydW5uaW5nLXRlbmFudCJ9LCJpYXQiOjE3MDkyMDM2NDYsImV4cCI6MzMyNjY4MDM2NDZ9.yr_YHT4R86Bv8CjiwF2YK3lzeAiyC4WHIyK-Fg_GfrQ';
  String thingName = 'user1';
  String deviceName = 'edge-meter';
  String bleServiceId = '8e7c2dae-0000-4b0d-b516-f525649c49ca';
  String imuCharacteristicId = '8e7c2dae-0002-4b0d-b516-f525649c49ca';
  String envCharacteristicId = '8e7c2dae-0003-4b0d-b516-f525649c49ca';
  String orientationCharacteristicId = '8e7c2dae-0004-4b0d-b516-f525649c49ca';
}
