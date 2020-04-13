
In AppDelegate in function didFinishLaunchingWithOptions call:

// Init DB
ConfigureDatabaseManager.shared().configureDatabaseManager()

// Init Notification 
BlueTraceLocalNotifications.shared.initialConfiguration()

// Init BLE
BluetraceManager.shared.turnOn()
