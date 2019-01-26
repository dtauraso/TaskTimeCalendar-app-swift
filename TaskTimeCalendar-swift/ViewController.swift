//
//  ViewController.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 4/21/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

// for auto unwrapping values in comparisons
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Timer
{
    var hours : Int = Int()
    var minutes : Int = Int()
    init(){}
}
class Item
{
    var id : Int = Int()
    var title : String = String()
    var note : String = String()
    var tags : [String] = [String]()
    var timer : Timer = Timer()
    var is_task : Bool = Bool()
    var is_note : Bool = Bool()
    var is_event : Bool = Bool()
    init(){}
    
    func Print()
    {
        print(id)
        print(title)
        print(note)
        print(tags)
        print(timer)
        print(is_task)
        print(is_note)
        print(is_event)
        
    }
    /*
        task, and cal object
        
        id
        title
        note
        tags
        reminder dates
        
        location
        all day
        starts
        ends
        repeats (just set it to on)
        travel time
 
        project (parent to this task)
        invitees ---
        show as (busy, avaliable)---
        url
        notes
        
        is_task
        is_event
        make stests only for each attribute
        
        store the attributes of the date from the schedule state machine(after it is made)
        take the time after epoch and get the units corresponding to the attributes
        if the unit's values match with the attributes's values and an instance of the item does not currently exist
            make a new instance of the item
        
        note
        id
        [some text, task object, some text, event object, note object, some text]
        make some tasks, events and one note with a full definition
        
        */
}




// class delegate for my objects(my objects are the parts of my program that I want to be persistent within my architecture)
/* persistent features:
    put non-ui parts here
    1 navigation controller
    1 view controller
    n view controllers
 
    1 task window
        nav bar
            back button
            title
            cal button
 
        task cells
        toolbar
            + button
     1 calendar window
        event rectangles
        

    algorithm
    ask michael for help
    
    I don't know where to look
    
    make a class for the navigation controller for the collection of task view controllers?
    make a class for the 2 types of controllers: controller for the tasks and controller for the calendar?
    push task controller(done)
    
    user presses a task
        push task view controller(done)
 
    
    user presses cal
        make cal view controller
        transition to cal view controller with no animation(How do I do this?)
 
    user presses task in cal view controller
        transition to task view controller stack with no animation(How do I do this?)
 
 
    user presses back button in task view controller(Does this need implementing?)
        pop task view controller
    
    merge task and cal view controllers?
 
    I have no idea when view_did_load_regular() is called
    
 
*/

// /Users/David 1/Documents/github/htm/htm.py

class Value
{
    //var type_name: String = String()
    var string: String = String()
    var int: Int = Int()
    var string_string: [String: String] = [String: String]()
    var string_int: [String: Int] = [String: Int]()
    var string_value: [String: Value] = [String: Value]()
    init()
    {}
    init(value: String)
    {
    
        string = value
    }
    init(value: Int)
    {
    
        int = value
    }
    init(value: [String: String])
    {
        string_string = value
    }
    init(value: [String: Value])
    {
    
        string_value = value
    }
    func getInt() -> Int
    {
    
        if int != Int()
        {
        
            return int
        }
        else
        {
        
            return -1
        }
    }
    
}
// ordered dict class from Python
// from http://www.timekl.com/blog/2014/06/02/learning-swift-ordered-dictionaries/
struct OrderedDictionary<Tk: Hashable, Tv>
{
    /* ... vars and init ... */
    var keys: Array<Tk> = []
    var values: Dictionary<Tk,Tv> = [:]

    init() {}
    
    subscript(key: Tk) -> Tv?
    {
        get
        {
            return self.values[key]
        }
        set(newValue)
        {
            if newValue == nil
            {
                self.values.removeValue(forKey: key)
                self.keys.filter {$0 != key}
                return
            }
            
            let oldValue = self.values.updateValue(newValue!, forKey: key)
            if oldValue == nil
            {
                self.keys.append(key)
            }
        }
    }
    var description: String
    {
    var result = "{\n"
    for i in (0...(self.keys.count - 1)) {
        let key = self.keys[i]
        result += "[\(i)]: \(key) => \(String(describing: self[key]))\n"
    }
    result += "}"
    return result
}
}


// UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
// https://developer.apple.com/documentation/uikit/uitableviewdatasource
class TasksFST: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    // initializes a task view
    var table : UITableView = UITableView()
    var bar_button_items = [UIBarButtonItem]()
    var cell: UITableViewCell = UITableViewCell()
    var index_path: IndexPath = IndexPath()
    let char_pixel_length : [Character: CGFloat] =
    [
    
        "a" : 9.5, "b" : 10.5, "c" : 9.5, "d" : 10.5, "e" : 9.5, "f" : 5.5, "g" : 10.0, "h" : 10.0, "i" : 4.0 , "j" : 4.0, "k" : 9.0 ,
        "l" : 4.0, "m" : 15.0, "n" : 10.0, "o" : 10.0, "p" : 10.5, "q" : 10.5, "r" : 6.0, "s" : 9.0, "t" : 5.5, "u" : 10.0, "v" : 9.0 ,
        "w" : 13.0, "x" : 9.0, "y" : 9.0, "z" : 8.5 ,
        "A" : 11.5, "B" : 12.0, "C" : 12.5, "D" : 12.5, "E" : 10.5, "F" : 10.0, "G" : 13.0, "H" : 12.5, "I" : 4.5, "J" : 9.0, "K" : 11.5 ,
        "L" : 10.0, "M" : 15.0, "N" : 12.5, "O" : 13.0, "P" : 11.5, "Q" : 13.0, "R" : 12.0, "S" : 11.5, "T" : 10.0, "U" : 12.5,
        "V" : 10.5, "W" : 16.0, "X" : 10.5, "Y" : 11.5, "Z" : 10.5 ,
        "0" : 10.0, "1" : 10.0, "2" : 10.0, "3" : 10.0, "4" : 10.0, "5" : 10.0, "6" : 10.0, "7" : 10.0, "8" : 10.0, "9" : 10.0 ,
        "`" : 4.0, "~" : 10.5, "!" : 4.5, "@" : 14.0, "#" : 10.0, "$" : 10.0, "%" : 17.5, "^" : 10.5, "&" : 11.0, "*" : 6.5, "(" : 4.5 ,
        ")" : 4.5, "-" : 7.0, "_" : 9.0, "+" : 10.5, "=" : 10.5, "{" : 6.0, "[" : 4.5, "}" : 6.0, "]" : 4.5, "\\" : 6.0,
        "|" : 4.0, ";" : 5.0, ":" : 5.0, "\"" : 7.5, "'" : 5.0, "," : 5.0, "<" : 10.5, "." : 5.0, ">" : 10.5, "/" : 6.0,
        "?" : 10.0, " " : 5.0
    ]
    
    func intToString(number: Int) -> String
    {
        let new_string: String = String(describing: number)
        var actual_string : String = String()
        for a in new_string
        {
            if (a >= "0" && a <= "9")
            {
                actual_string = actual_string + String(a)
            }

        }
        return actual_string
    }
    func addZeroIfNeeded(unit_of_time: String) -> String
    {
        var new_unit_of_time : String = unit_of_time
        if new_unit_of_time.count == 1
        {
            new_unit_of_time = "0" + new_unit_of_time
        }
        return new_unit_of_time
    }
    func shortenText(offset: CGFloat, cell: inout UITableViewCell, timer: inout UILabel)
    {

        let string : String = (cell.textLabel?.text)!
        var text : [Character] = [Character]()
        for char in string.characters
        {
            text.append(char)
        }
        
        text.append(contentsOf: [".", ".", "."])
        
        cell.textLabel?.text = (cell.textLabel?.text)! + "..."
        
        var text_offset_length : CGFloat = offset + (cell.textLabel?.intrinsicContentSize.width)!
        // if title is too long
            // make it shorter

        // timer.frame.minX appears to not describe the max x value completely
        while text_offset_length > (timer.frame.minX - 4)
        {
            let i : Int = text.count - 4
            text_offset_length = text_offset_length - char_pixel_length[text[i]]!
            text.remove(at: i)
        }
        
        var new_cell_label : String = String()
        for char in text
        {
            new_cell_label = new_cell_label + String(char)
        }
            cell.textLabel?.text = new_cell_label

    }
    func calAction(previous_state: String) -> Bool
    {
        if previous_state == "cal"
        {

        }
        return true
    }
    
    @objc func edit(gestureRecognizer: UIGestureRecognizer){}
    @objc func add(gestureRecognizer: UIGestureRecognizer){}


    // previous_state = current_action_state
    func TasksFSTActions(previous_state: String, found_in_api_call: String) -> Bool
    {
        var truth_var : Bool = false

        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            my_delegate.printBreakInSequence(previous_state: previous_state)
            if previous_state == "view_did_load_regular"
            {
                //print("load up interface")
                // can't move the code loading the view from TasksFST's view_did_load_regular to here
                table.frame = CGRect(x:0, y:0, width:320, height:560)
                table.delegate = self
                table.dataSource = self
                table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                self.view.addSubview(table)
                
                // top of screen
                self.title = "Parent"
                
                let cal = UIBarButtonItem(title: "Cal", style: .plain, target: self, action: #selector(TasksFST.cal(gestureRecognizer:)))


                let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(TasksFST.edit(gestureRecognizer:)))
                
                // displayes from right to left
                self.navigationItem.rightBarButtonItems = [edit, cal]


                // bottom of screen
                self.navigationController?.setToolbarItems(bar_button_items, animated: false)
                self.navigationController?.setToolbarHidden(false, animated: false)

                let add = UIBarButtonItem(title: "  +", style: .plain, target: self, action: #selector(TasksFST.add(gestureRecognizer:)))

                self.toolbarItems = [add]
                //print("number of items in new")
                //print(self.navigationController?.viewControllers.count)
                truth_var = true
            }
            else if previous_state == "load_up_tasks"
            {
                // index path is empty
                // is trying to run before the table view cell function is run
                truth_var = true
            }
            
            
            else if previous_state == "view_did_load_for_nested"
            {
                table.frame = CGRect(x:0, y:0, width:320, height:560)
                table.delegate = self
                table.dataSource = self
                table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                self.view.addSubview(table)
                
                // top of screen
                self.title = "Parent"
                
                let cal = UIBarButtonItem(title: "Cal", style: .plain, target: self, action: #selector(TasksFST.cal(gestureRecognizer:)))


                let edit = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(TasksFST.edit(gestureRecognizer:)))
                
                // displayes from right to left
                self.navigationItem.rightBarButtonItems = [edit, cal]


                // bottom of screen
                self.navigationController?.setToolbarItems(bar_button_items, animated: false)
                self.navigationController?.setToolbarHidden(false, animated: false)

                let add = UIBarButtonItem(title: "  +", style: .plain, target: self, action: #selector(TasksFST.add(gestureRecognizer:)))

                self.toolbarItems = [add]
                truth_var = true
            }
            else if previous_state == "view_did_load_nested"
            {
                print("adding nested tasks", my_delegate.task_nest)

                // when taskfst's viewDidLoad() is called the state has not changed to view_did_load_nested yet
            	//print(my_delegate.previous_state)
                //print(my_delegate.task_nest)
                // made a taskFST object
                    // put the taskFST nested items inside it
                for _ in (0..<my_delegate.task_nest)
                {
                    // viewWillAppear() came from the last new added to stack?
                    // viewDidLoad() is run right after this line
                    my_delegate.previous_state = "view_did_load_regular"
                    // not even reaching view_did_load_regular
                    let new : TasksFST = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "0") as! TasksFST
                
                    //print("was altered", i, my_delegate.task_nest)
                    self.navigationController?.pushViewController(new, animated: false)
                
                    new.TasksFSTActions(previous_state: my_delegate.previous_state, found_in_api_call: "")
                    my_delegate.previous_state = "view_did_load_nested"
                
                    
                }

                truth_var = true
                //print("done with adding items", my_delegate.previous_state)
                // view_did_load_regular is called on the last item added by default so need to call it here
                // only 1 view did load is called after this is done, but why are the rest not called and not used?
                //print("after all prev views are loaded up " + my_delegate.previous_state)
            }
            else if previous_state == "last_view_gone"
            {
                // can't move the code from TasksFST's viewWillAppear to here

                let x = self.table.indexPathForSelectedRow
                if x != nil
                {
                    
                    self.table.deselectRow(at: x!, animated: true)
                    
                }
            
                truth_var = true
            }
            
            // detect prev
            if (previous_state == "delete_nested_item_in_task_view")
            {
                
                my_delegate.task_nest = my_delegate.task_nest - 1
                truth_var = true
            
            }
            else if previous_state == "task_window"
            {
                truth_var = true
            }
            // if at these states
            else if previous_state == "task"
            {
                
                print("adding task")
                // print element at tasks[task_mirror.i]
                //print(task_mirror.i)

                let new : TasksFST = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "0") as! TasksFST
                // self.navigationController? is holding TasksFST objects, but they aren't embeded
                self.navigationController?.pushViewController(new, animated: true)
                //print(self.navigationController?.viewControllers.count)
                my_delegate.task_nest = my_delegate.task_nest + 1
                //print(my_delegate.task_nest)
                //return true //task_mirror.task_was_tapped
                
                truth_var = true
            }
            else if previous_state == "add_item_to_item_stack"
            {
                // view controller has been added to the viewcontroller in TasksFST
                //task_mirror.stack_number = task_mirror.stack_number + 1
                //task_mirror.stack_item_added = true
                
                truth_var = true
                
            }
            else if previous_state == "end_of_items_and_nested_items"
            {
                //print("cal was tapped")

                truth_var = true//task_mirror.cal_was_tapped
            }
            else if previous_state == "cal"
            {
                print("calender")
                let new : CalendarFST = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "1") as! CalendarFST
                self.navigationController?.pushViewController(new, animated: true)
                //self.performSegue(withIdentifier: "to_cal", sender: self)
                truth_var = true

            }
            //if truth_var
            //{
              //  print(my_delegate.debug(action: "TasksFST", state: previous_state, indent_level: 1, found_in_api_call: found_in_api_call))
            //}
        }
        return truth_var
    }
    
    override func viewDidLoad()
    {
        // after entry classes "transfer to" state has been run, the next state is view_did_load_for_nested when taskfst viewDidLoad() is called
        let function_name = "TasksFST viewDidLoad()"
        super.viewDidLoad()
        
        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            let options = ["view_did_load_regular", "view_did_load_for_nested"]
            my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)

            //print("here", my_delegate.previous_state, "view_did_load_regular")
            /*if my_delegate.previous_state == "view_did_load_regular"
            {
                
                my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)
                
                // run task_window
                //my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)

            }
            
            else if my_delegate.previous_state == "view_did_load_for_nested"
            {
                my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)
                
                
                

            }*/
            
            /*
            (root_subtask, 0)
            // add task
            (name, 0) (name2, 0)
            for name 0:
            (notes, 0) (due_dates, 0) (subtask, 0)
                                        (name2, 0) (name4, 0)
             
            name children -> notes
            
            task attributes parent -> name
            
            task attributes map to each other for attribute completion
            */
            
            
            
        }
        
    }
        
    // now I can add all of the view controllers from nav_stack before the new one from the storyboard is loaded
    override func viewWillAppear(_ animated: Bool)
    {
        let function_name = "TasksFST viewWillAppear(_ animated: Bool)"
        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            print(function_name, my_delegate.previous_state)
            
            // edges that api call has
            let options = ["last_view_gone", "task_window", "view_did_load_nested"]
            // check for previous state
            if (my_delegate.previous_state == "delete_nested_item_in_task_view" || my_delegate.previous_state == "view_did_load_for_nested")
            {
                my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)
                
                // run task_window
                my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)


            }
            else if my_delegate.previous_state == "view_did_load_regular"
            {
                my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)

            }
            /*else if my_delegate.previous_state == "view_did_load_for_nested"
            {
                my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)
                my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)


            }*/
            //my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)

            /*if (my_delegate.previous_state == "last_view_gone" || my_delegate.previous_state == "view_did_load_regular")
            {
                my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)
                
                // run task_window
                my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)


            }*/
            
            
            /*else if my_delegate.previous_state == "view_did_load_nested"
            {
                // run task_window
                my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)
                //print("error", my_delegate.previous_state)
                // why is viewWillAppear(_ animated: Bool) being called after last item is loaded up?
            }*/
            /*else if my_delegate.previous_state == "load_up_tasks"
            {
             //my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)
            }*/
            
        }
        
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
     func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        _ = "TasksFST tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell"
    
        /*var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = "test"
        // display the cell
        return cell*/
        // problem
        /*
            assumes all variables to be used are already stored in the class,
            there is no need to get data from the api ever, and
            there is no need to send data to the api ever
            need some way to do api interfacing
            is it okay if it violates the state code blocks in state machine diagram idea?
            as long as you make some syntax surrounding the special api input and or output lines
        */
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);

        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            //print(my_delegate.items.count, )
            if my_delegate.items.count > indexPath.row
            {
                
                cell.textLabel?.text = my_delegate.items[indexPath.row].title
                cell.textLabel?.font! = UIFont(name: "Arial", size: 18.0)!
                //cell.textLabel?.addGestureRecognizer(gestureRecognizer1)
                // all items have a title

                // each item must have a note flag, event flag, and a task flag

                // only tasks have times
                // if item is a task

                // assume time only exists on tasks
                if my_delegate.items[indexPath.row].is_task
                {
                    var timer : UILabel = UILabel()

                    let item_timer : Timer = my_delegate.items[indexPath.row].timer
                    timer.frame = CGRect(x: 60, y: 60, width: 45, height: 24)
                    let cellHeight : CGFloat = 44.0
                    timer.center = CGPoint(x: view.bounds.width / 1.3, y: cellHeight / 2.0)
                    timer.backgroundColor = UIColor.blue
                    var hours: String = intToString(number: item_timer.hours)
                    var minutes: String = intToString(number: item_timer.minutes)

                    hours = addZeroIfNeeded(unit_of_time: hours)
                    minutes = addZeroIfNeeded(unit_of_time: minutes)

                    timer.text = hours + " " + minutes;
                    timer.textColor = UIColor.white

                    // offset is distance from left edge of portait mode to the leftmost edge of the cell.textLabel?.text
                    
                    let offset : CGFloat = CGFloat(14.6539)

                    if (offset + (cell.textLabel?.intrinsicContentSize.width)!) > timer.frame.minX
                    {
                        shortenText(offset: offset, cell: &cell, timer: &timer)
                    }
                    

                    
                    cell.contentView.addSubview(timer)
                    //cell.addSubview(timer)
                    
                }

                
                // makes sure the check mark is drawn over the title
                // all items have a check mark
                
                let check_mark = UIView()
                check_mark.frame = CGRect(x: 12, y: 12, width: 20, height: 20)
                check_mark.backgroundColor = UIColor.gray
                let check_mark_tap = UITapGestureRecognizer(target: self, action: #selector(TasksFST.checkMark(gestureRecognizer:)))
                check_mark_tap.delegate = self
                check_mark.addGestureRecognizer(check_mark_tap)
                
                
                cell.contentView.addSubview(check_mark)
                
                // for style
                let small_check_mark = UIView()
                small_check_mark.frame = CGRect(x: 13, y: 13, width: 18, height: 18)
                small_check_mark.backgroundColor = UIColor.white

         
                
                let small_check_mark_tap = UITapGestureRecognizer(target: self, action: #selector(TasksFST.checkMark(gestureRecognizer:)))
                small_check_mark_tap.delegate = self

                small_check_mark.addGestureRecognizer(small_check_mark_tap)
                cell.contentView.addSubview(small_check_mark)

                //print(check_mark.gestureRecognizers?[0])
                // click detector is in the view object
                // the table cell function is being clicked on
                // the click detector is being ignored
                //cell.addGestureRecognizer(gestureRecognizer)

                // all items have a more info button
                cell.accessoryType = UITableViewCell.AccessoryType.detailButton
                
                if my_delegate.items[indexPath.row].is_note
                {
                    cell.backgroundColor = UIColor.yellow
                }
                else if my_delegate.items[indexPath.row].is_event
                {
                    cell.backgroundColor = UIColor.cyan
                }
                else
                {
                    let timer_clicked = UITapGestureRecognizer(target: self, action: #selector(TasksFST.timerClicked(gestureRecognizer:)))
                    //timerClicked.delegate = self
                    let timer_ = UIView()
                    timer_.frame = CGRect(x: 223, y: 10, width: 47, height: 24)
                    timer_.backgroundColor = UIColor.clear
                    timer_.addGestureRecognizer(timer_clicked)

                    
                    cell.addSubview(timer_)
                }
            }

            }
            // runs through this until a sigstop
        
        // this is called in a loop so can't change the state here
        
        // keep swift compiler happy
        return cell
    }
    

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.00
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        print("get info")
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
        
        let function_name = "TasksFST tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)"
        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            print(function_name)
            print(my_delegate.previous_state)
            print(my_delegate.previous_state, " != task")
            //my_delegate.previous_state  = "task"
            let options = ["task"]
            //print("got here")
            my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)

           // my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)
            
            
            // task is printed out in the view_did_load_regular part
        }
       

        
        
    }
    @objc func timerClicked(gestureRecognizer: UIGestureRecognizer)
    {
        print("timer")
    }
    // check mark
    @objc func checkMark(gestureRecognizer: UIGestureRecognizer)
    {
        print("completed")
    }
    // timer
    func timer(gestureRecognizer: UIGestureRecognizer)
    {
    }
    // info
    
    func cell(gestureRecognizer: UIGestureRecognizer)
    {
    
        print("cell")
        // go to case where a cell object is made and modified
        // only 1 lower view will be on navigation controller stack at any time
        //if(self.navigationController?.viewControllers.count > 0)
        //{
          //  self.navigationController!.popViewController(animated: false)
        //}
        //print(gestureRecognizer)
        // the item tapped on must have a gesture regognizer object stored in it
        // if the item tapped has no gesture recognizer, the gesture recognizer is not set to catch anything from UIBarButtonItem and so it cannot have any locations it did not catch from?
        //print(gestureRecognizer)
        //print(gestureRecognizer.location(ofTouch: 0, in: myTable))
        //myTable.visibleCells
        //print("item tapped")
        // make a new cell
        // set a certain cell to the new cell(there doensn't seem to be any support for this)
        //tableView(myTable, didSelectRowAt: indexPath)
        //print("click me")
        //self.table
        let cell = self.table.cellForRow(at: IndexPath(item: 0, section: 0))
        cell?.textLabel?.text = "     changed"
     
    }
    
    // make sure the nav_stack pops when self.navigationController pops
    // when user taps the back button
    override func viewWillDisappear(_ animated: Bool)
    {
        let function_name = "TasksFST viewWillDisappear(_ animated: Bool)"
        super.viewWillDisappear(animated)
        
        

        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
        
            
            if self.isMovingFromParent
            {
                let options = ["delete_nested_item_in_task_view"]
                my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)
            }
            
        }
        
    }
    
    @objc func cal(gestureRecognizer: UIGestureRecognizer)
    {

        let function_name = "TasksFST cal(gestureRecognizer: UIGestureRecognizer)"
        // add_item_to_item_stack -> end_of_items_and_nested_items
        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            let options = ["cal"]
            //var cal_state = "cal"
            //my_delegate.previous_state = "cal"
            //my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name)
            my_delegate.test(previous_state: &my_delegate.previous_state, action: TasksFSTActions, found_in_api_call: function_name, options: options)
            //my_delegate.actionTap(previous_state: &cal_state, action: calAction, found_in_api_call: function_name)
            
        }
    }
    
}

class Cell
{
    // have a copy of all cell data
    // alter it here
    // send it back to tasksFST
}

//UINavigationController
// task_stack
class EntryClass: UINavigationController//, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    
    var table : UITableView = UITableView()
    var bar_button_items = [UIBarButtonItem]()
    var n : TasksFST = TasksFST()
    var items_from_file : [Any] = []
    
    func createItem(task: Any) -> Item
    {
        // can't mutate things that have to be typecasted so they have to be copied to an object that can be mutated
        // copy data out using double typecasting

        let item: Item = Item()
        item.id = (task as! [String: Any?])["id"] as! Int
        item.title = (task as! [String: Any?])["title"] as! String
        item.note = (task as! [String: Any?])["note"] as! String
        item.tags = (task as! [String: Any?])["tags"] as! [String]
        item.timer.hours = (((task as! [String: Any?])["timer"] as! [String: Int])["hours"] )!
        item.timer.minutes = (((task as! [String: Any?])["timer"] as! [String: Int])["minutes"] )!
        item.is_task = (task as! [String: Any?])["is_task"] as! Bool
        item.is_note = (task as! [String: Any?])["is_note"] as! Bool
        item.is_event = (task as! [String: Any?])["is_event"] as! Bool

        return item
    }
    

    
    func EntryClassActions(previous_state: String, found_in_api_call: String) -> Bool
    {
        var truth_var = false
        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            //print(previous_state)
            if previous_state == "start"
            {
                _ = ["\" ref id\"", "", "\"\"", "\"\\\\\"", "\"jhtres\"", "\"uytrewytre345678\"", "\"876543\"", "2", "3", "5432", "0"/*, "gfhd", "g"*/, "", "true", "false", "null", "{ \"ref id\" : 0}", "{ \"ref id\" : 0,  \"title\": \"0\"}", "{ \"ref id\" : 0 ,  \"title\" : \"0\" }",  "{\"ref id\":0,\"title\":\"0\"}", "{\"ref id\":0,\"ref id\":1}", "{\"ref id\":true,\"title\":false}", "{ \"ref id\" : 0 ,  \"title\" : 087654 }", "{\"ref id\":true,\"title\":null}", "[]", "[{}]", "[{\"ref id\":true,\"title\":false}]",
                "{\"ref id\" : 1 , \"title\" : \"prints\"  ,\"note\": \"this is a note,.\",\"tags\":[ \"right? tag\", \"different tag\", \"tag with\",\"quote\" ,\"\"],\"cycles\" : {\"is_cycle\": \"true\", \"cycle_length\": 2, \"cycle_day_of_week\" : \"tuesday\", \"cycle_month\" : \"october\",\"cycle_month_day\" : 5}, \"super tasks\": [0], \"sub tasks\": [2], \"distance to global bottom\" : 2}",
                
                    "{\"ref id\" :2, \"title\": \"5\", \"note\": null, \"tags\": null, \"cycles\":null, \"super tasks\": [1], \"sub tasks\": null, \"distance to global bottom\" : 1}"
                ]
                let t_c_n_collection = ["[{\"id\" : 0 ,\"title\" : \"     test\", \"note\" : \"this is a note\", \"tags\" : [\"tag one\", \"tag two\"], \"timer\" : {\"hours\" : 23, \"minutes\" : 09}, \"is_task\" : true, \"is_note\": false, \"is_event\" : false}, {\"id\" : 1 ,\"title\" : \"     Talk to Chris or tim about\", \"note\" : \"this is another note\", \"tags\" : [\"tag three\", \"tag four\"],\"timer\" : {\"hours\" : 03, \"minutes\" : 50}, \"is_task\" : true, \"is_note\" : false, \"is_event\" : false}, {\"id\" : 2, \"title\" : \"     title3dfghjkjhgfdfghjkfdfghjkkfdfghklgfghjklkgfghjkjhgfgh\", \"note\": \"\", \"tags\" : [], \"timer\" : {\"hours\" : 0, \"minutes\" : 0}, \"is_note\" : true, \"is_task\" : false, \"is_event\" : false}, {\"id\" : 3, \"title\" : \"     title5\", \"note\": \"\", \"tags\" : [], \"timer\" : {\"hours\" : 0, \"minutes\" : 0}, \"is_task\" : false, \"is_note\" : false,\"is_event\" : true}]"]

                // timer_hours_string
                // timer_minutes_string
                // what am I doing to do with the timer?
                // after a minutes has gone by
                // seubtract 1 minute from all timers that are active
                for element in t_c_n_collection
                {
                    var array_of_chars = [Character]()
                    
                    for char in element.characters
                    {
                        array_of_chars.append(char)
                    }
                    //print(array_of_chars)
                    let json_parser : JSONParser = JSONParser()
                    items_from_file = json_parser.jsonArray(json_string: &array_of_chars) as [Any]
                    
                    
                    my_delegate.items = items_from_file.map({createItem(task: $0)})

                    my_delegate.items.map({$0.Print()})
                    //setTask(task: tasks[0])
                    
                }

                // change to if unfold is false then no sub_states and no sub_classes are allowed to print

                /*if getPrintChildrenStateNamesFromParent(previous_state: previous_state)
                {
                    printStateNames(previous_state: previous_state)
                }*/
                //print("got here")
                self.navigationController?.pushViewController(n, animated: true)

                truth_var = true

            }
            else if previous_state == "transfer_to_entry_class"
            {
                // use this stack for adding tasks to the stack
                //n.navigationController?.pushViewController(n, animated: true)
                let new : TasksFST = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "0") as! TasksFST
                // will call the viewDidLoad(), viewWillAppear() sequence after this function is done
                //print("after view_did_load_nested")
                self.navigationController?.pushViewController(new, animated: false)
                
                truth_var = true
            }
            else if previous_state == "view_did_load_nested"
            {
            
                // after action was run then next action was set to previous_state
                // the action after view_did_load_regular is task_window, but view_did_load_regular was never run
                //my_delegate.previous_state = "view_did_load_regular"

                let new : TasksFST = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "0") as! TasksFST
                // state is still at view_did_load_nested

                self.n.navigationController?.pushViewController(new, animated: false)
                
                
                truth_var = true
            }
            

            else if previous_state == "do_nothing"
            {
                truth_var = true
            }
            else if previous_state == "run_code_to_setup_TaskFST"
            {
                truth_var = true
            }
            //if truth_var
            //{
                //print(my_delegate.debug(action: "EntryClass", state: previous_state, indent_level: 0, found_in_api_call: found_in_api_call))
            //}
        }

        return truth_var

    }
    
    // before view is loaded up need to add record of tree level to navigation controller
        // is happening first
    override func viewWillAppear(_ animated: Bool)
    {
        _ = "EntryClass viewWillAppear"
    // went from transfer_entry_class to do_nothing after view_did_load_regular ended and before viewWillAppear started
        print("got here")
        /*if var my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            //navigationController?.pushViewController(n, animated: true)
            //my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state)
            //print("state should be run_code_to_setup_TaskFST :: " + my_delegate.previous_state)



        }*/
    }
    override func viewDidLoad()
    {
        // add to main state machine at certain position
        let function_name = "EntryClass viewDidLoad()"
        
        super.viewDidLoad()
        
        
        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            print("nested", my_delegate.previous_state)
            let options = ["start", "transfer_to_entry_class"]
            /*if my_delegate.previous_state == "tasks"
            {
                my_delegate.test(previous_state: &my_delegate.previous_state, action: EntryClassActions, found_in_api_call: function_name, options: options)

            }
            else
            {*/
            // call stateMachineIntersection(states here)
            // call stateMacineAction(actionFunctionInClass)
            // actionFunctionInClass = [state_name : [(lambda maybe) actionFunction(same as in EntryClassActions)]]
            // dict is stored in the class
                // supposte to compare tasks nexts with the options
                my_delegate.test(previous_state: &my_delegate.previous_state, action: EntryClassActions, found_in_api_call: function_name, options: options)
            
            /*}*/

            //print(my_delegate.previous_state)
            /*if my_delegate.previous_state == "start1"
            {
            
                my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: EntryClassActions, found_in_api_call: function_name)
            }
            else if my_delegate.previous_state == "transfer_to_entry_class"
            {
                my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: EntryClassActions, found_in_api_call: function_name)
                

            }*/
            
            
            
        }
        
        
    }

    

    
    func test()
    {
        print("works")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    /*func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        //var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = "test"
        // display the cell
        return cell

    }*/
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // preconditions: the current view controller is not in nav_stack

    }

}

class CalendarNavigator: UINavigationController
{
    var my_view: CalendarFST = CalendarFST()
    
    // should be called when view is presented to the user
    override func viewWillAppear(_ animated: Bool)
    {
    }
}
class CalendarFST: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    
    var bar_button_items = [UIBarButtonItem]()

   
    
    var table : UITableView = UITableView()
    @objc func edit(gestureRecognizer: UIGestureRecognizer){}
    @objc func add(gestureRecognizer: UIGestureRecognizer){}


    func CalendarFST_(previous_state: String, found_in_api_call: String) -> Bool
    {
        var truth_var = false
        //print("debug", previous_state)

        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            my_delegate.printBreakInSequence(previous_state: previous_state)

            
            if previous_state == "view_did_load_regular_2"
            {
                table.frame = CGRect(x:0, y:0, width:320, height:560)
                table.delegate = self
                table.dataSource = self
                table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                self.view.addSubview(table)
                
                
                // top of screen
                let tasks = UIBarButtonItem(title: "Tasks", style: .plain, target: self, action: #selector(CalendarFST.tasks(gestureRecognizer:)))
                
                // so "Tasks" is in same position as in the task manager window
                let blank = UIBarButtonItem(title: "  ", style: .plain, target: self, action: #selector(CalendarFST.edit(gestureRecognizer:)))
                
                // displayes from right to left
                self.navigationItem.rightBarButtonItems = [blank, tasks]
                
                
                // bottom of screen
                self.navigationController?.setToolbarItems(bar_button_items, animated: false)
                self.navigationController?.setToolbarHidden(false, animated: false)
                
                let add = UIBarButtonItem(title: "  +", style: .plain, target: self, action: #selector(CalendarFST.add(gestureRecognizer:)))

                self.toolbarItems = [add]
                
                let scrollView = UIScrollView(frame: view.bounds)
                scrollView.backgroundColor = UIColor.black
                // 3
                // need a total size
                scrollView.contentSize = /*self.view.bounds.size*/  CGSize(width: 500, height: 1000)
                
                let line = UIView(frame: CGRect(x: 50, y: 200, width: 200, height: 1))
                line.backgroundColor = UIColor.green
                scrollView.addSubview(line)
                
                let timer : UILabel = UILabel()

                timer.frame = CGRect(x: 60, y: 60, width: 45, height: 10)
                let cellHeight : CGFloat = 44.0
                timer.center = CGPoint(x: view.bounds.width / 1.3, y: cellHeight / 2.0)
                timer.text = "works"
                timer.font = UIFont(name: "Arial", size: 10.0)!
                timer.textColor = UIColor.red
                scrollView.addSubview(timer)
           
           
                // need a view for the scroll view to show
                let check_mark = UIView()
                check_mark.frame = CGRect(x: 100, y: 600, width: 20, height: 20)
                check_mark.backgroundColor = UIColor.gray
                scrollView.addSubview(check_mark)
                // 4      
                //scrollView.addSubview(imageView)
                view.addSubview(scrollView)
                truth_var = true
            }
            else if previous_state == "tasks"
            {
                
                self.navigationController?.popViewController(animated: true)
                print("did this")

                truth_var = true
                

            }
            //if truth_var
            //{
              //  print(my_delegate.debug(action: "CalendarFST", state: previous_state, indent_level: 0, found_in_api_call: found_in_api_call))
            //}
        }
        
        return truth_var
    }
    override func viewDidLoad()
    {
        let function_name = "CalendarFST viewDidLoad()"
        super.viewDidLoad()


        // entire stack of saved view controllers is erased
        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {

            print(my_delegate.previous_state)
            // unless I pass a reference, the chilren view controllers are only for recording the view controllers visited
            //print("in calendar", my_delegate.addItems().viewControllers.count)
            //print("current state in cal " + my_delegate.previous_state)
            //print("current state in cal should be " + "transfer_to_calendar_fst")
            //print(my_delegate.previous_state)
            // doesn't catch view_did_load_regular_2
            
            let options = ["view_did_load_regular_2"]
            if my_delegate.previous_state == "cal"
            {
                my_delegate.test(previous_state: &my_delegate.previous_state, action: CalendarFST_, found_in_api_call: function_name, options: options)
                //my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: CalendarFST_, found_in_api_call: function_name)
                

                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = "passes"
        
        return cell

    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    
    }
    @objc func tasks(gestureRecognizer: UIGestureRecognizer)
    {

        let function_name = " CalendarFST tasks(gestureRecognizer: UIGestureRecognizer)"
        //print("passes again")
        if let my_delegate = UIApplication.shared.delegate as? AppDelegate
        {
            
            //print("tasks", my_delegate.previous_state)
            //my_delegate.previous_state = "view_did_load_regular_2"
            let options = ["tasks"]
            // not transferring classes so must print out new line to distinquish the user interactions
            //print()
            // print out that the task was touched
            // print out barriers around the state machine calls
            //my_delegate.actionTap(previous_state: &task_state, action: CalendarFST_, found_in_api_call: function_name)
            //print("load_up_calendar " + my_delegate.previous_state)
            
            my_delegate.test(previous_state: &my_delegate.previous_state, action: CalendarFST_, found_in_api_call: function_name, options: options)
            //my_delegate.visitorForHierarchialStateMachine(previous_state: &my_delegate.previous_state, action: CalendarFST_, found_in_api_call: function_name)
            //print("task state " + my_delegate.previous_state)
            // have to be here because they would force the action function to return false
            //let m : EntryClass = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "2") as! EntryClass
            // mistake was assuming we had to go back to "tasks"(associated with EntryClass)
            // really poped off stack, and the viewWillAppear was called
            /*
                we want to go to tasks
                then click on a task
            */
            print("after entry class is made")
            
            //self.performSegue(withIdentifier: "to_task", sender: self)
            // would pop off navigation controller but no way to do this
            // maybe put the stack inside the app delegate
            // how to change control flow from this object to a different object
            //self.navigationController?.popToViewController(viewController, animated: true);
            // https://stackoverflow.com/questions/6872852/popping-and-pushing-view-controllers-in-same-action
            /*
            let navigationVC = self.navigationController
            navigationVC?.popViewController(animated: false)
            navigationVC?.pushViewController(myNewVC, animated: false)
            */
            // leaves right here, doesn't wait for any other command but makes function return false
            //my_delegate.nest_flag = true
            //let task_manager : EntryClass = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "2") as! EntryClass
                    }
        
    }
}
    func saveString(_ file_string: String, file_name: String)
    {

        // Save data to file
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)



        let file_url = DocumentDirURL.appendingPathComponent(file_name).appendingPathExtension("txt")
        //print("FilePath: \(file_url.path)")

        do
        {
            // Write to the file
            try file_string.write(to: file_url, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError
        {
            print("Failed writing to URL: \(file_url), Error: " + error.localizedDescription)
        }


    }
    



    func loadString(_ file_name: String) -> String
    {
        
            let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let file_url = DocumentDirURL.appendingPathComponent(file_name).appendingPathExtension("txt")

            // Reading
            var in_string = ""
            do
            {
                in_string = try String(contentsOf: file_url)
            }
            catch let error as NSError
            {
                print("Failed reading from URL: \(file_url), Error: " + error.localizedDescription)
            }

            //print("In: \(in_string)")
            return in_string
    }
    

        //http://stackoverflow.com/questions/18729523/how-to-detect-tap-on-uitextfield
        // https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/TableViewCells/TableViewCells.html
        // http://candycode.io/how-to-properly-do-buttons-in-table-view-cells/
        //http://stackoverflow.com/questions/18729523/how-to-detect-tap-on-uitextfield
        // https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/TableViewCells/TableViewCells.html
        // http://candycode.io/how-to-properly-do-buttons-in-table-view-cells/
    
