# TaskTimeCalendar-app-swift
This project is a work in progress and still in the planning phase.  The most complete part is showing the different kinds of items(task, calendar event, note, default time for timer) in the task view.  The buttons are mainly drivers and the calendar view
has a line drawn in it.  The current state machine implementation is a precurser to the contextual state chart I've been working on for some time over in https://github.com/dtauraso/Contexual-State-Chart-Language.

This program is designed to link 3 concepts together: Tasks, Calendars, and Timers.  It will use a Contexual State Chart.  That is a state chart where each state has options for what behavior it executes over time.  The Contexual State Chart will be used to store data as well as behavior.

The contexual state chart will be ready soon.  The api, from the swift version mentioned in the link above, works quite well, but the language is still buggy.  Once the contextual state chart language is completed, app developement will continue.


It works on Xcode 10 with Swift version 4 and ios simulator XR.

The app works although there is a bug on the calender view to go back to the parent tasks.

screenshots
iphone 8 ios 12.2
![image]
(https://github.com/dtauraso/TaskTimeCalendar-app-swift/blob/master/iphone%208%20using%20ios%208/Screen%20Shot%202019-06-12%20at%201.33.52%20PM.png)

iphone XR 12.2

for each of these versions the table view had to be adjusted
