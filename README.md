# TaskTimeCalendar-app-swift

This program is designed to link 3 concepts together: Tasks, Calendars, and Timers.  It will use a Contextual State Chart.  That is a state chart where each state has options for what behavior it executes over time.  The Contextual State Chart will be used to store data as well as behavior.  Usually there are 3 or 2 separate apps for task, calendar, and time management.  I designed this with the goal of bringing productivity into a single app.

This project is a work in progress and still in the planning phase.  The most complete part is showing the different kinds of items(task, calendar event, note, default time for timer) in the task view.  The buttons are mainly drivers and the calendar view has a line drawn in it.  

The current state machine implementation is a precurser to the contextual state chart I've been working on for some time over in https://github.com/dtauraso/Contextual-State-Chart-Language.  The contextual state chart will be ready soon.  The api, from the swift version mentioned in the link above works quite well, but the language needs more work.  I'm currently making a more completely version of the language in C over in https://github.com/dtauraso/Contextual-State-Chart-Language-C.  It's platform independent and will output the state chart data as JSON and evaluator code in the language you use for easy integration. 


It works on Xcode 10 with Swift version 4 and ios simulator XR.

The app works although there is a bug on the calender view to go back to the parent tasks.

screenshots
iphone 8 ios 12.2

<img src="https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%208%20using%20ios%208/Screen%20Shot%202019-06-12%20at%201.33.52%20PM.png">

<img src="https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%208%20using%20ios%208/Screen%20Shot%202019-06-12%20at%201.33.55%20PM.png">
<img src="https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%208%20using%20ios%208/Screen%20Shot%202019-06-12%20at%201.33.58%20PM.png">

<img src="https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%208%20using%20ios%208/Screen%20Shot%202019-06-12%20at%201.34.06%20PM.png">


iphone XR 12.2
<img src="https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%20XR%20using%20ios%2012/Screen%20Shot%202019-06-12%20at%201.42.31%20PM.png">

<img src="https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%20XR%20using%20ios%2012/Screen%20Shot%202019-06-12%20at%201.42.34%20PM.png">
<img src="https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%20XR%20using%20ios%2012/Screen%20Shot%202019-06-12%20at%201.42.39%20PM.png">
<img src="https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%20XR%20using%20ios%2012/Screen%20Shot%202019-06-12%20at%201.44.05%20PM.png">

For each of these versions the table view had to be adjusted.
