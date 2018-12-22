//
//  Task.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 11/7/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation
class Cycle
{
    var is_cycle = Bool()
    var cycle_length = Int()
    /*init(elements: [KeyValuePair])
    {
    
    }*/
    init(){}
}
// parse into json object graph
// collect all tasks without setting the sub and super tasks
// traverse theorugh each task and assign the sub and super tasks to them
// traverse again from reverse end to get the items that are on the bottom of hierarchy
// prove by printing tree top to bottom and then from bottom to top(rest of children must check if they all share same parent during bottom up traversal)
// traverse top down an donly print sucess if each task has subtasks that connect to it and if its super tasks connect to it

// no shortcut lists now
// draw graph to find out what the bottom level is for the initial data
// use distance to global bottom to find out if added task is at bottom level in graph in constant time
class task{
    // assuming the json object is treated like an ordered set
    var id = Int() // only for making the graph
    // attributes(might be a generic object)
    var title = String()
    var note = String()
    // super_tasks
    var super_tasks = [task]()
    // subtasks
    var sub_tasks = [task]()
    // tag list
    var tags = [String()]
    // cycle object
    var cycle = Cycle()
    
    var distance_to_global_bottom = Int()
    // title, super_tasks, sub_tasks fit tag data structure
    /*func valueIsNotNull(element: KeyValuePair) -> Bool
    {
        return !element.value_.null
    }*/
    init(id: Int)
    {
        self.id = id
    }
    /*init(data: [KeyValuePair])
    {
        self.id = data[0].value_.number
        
        if(valueIsNotNull(element: data[1])) { self.title = data[1].value_.string }
        else                                 { self.title = ""}
        
        if(valueIsNotNull(element: data[2])) { self.note = data[2].value_.string }
        else                                 { self.note = "" }

        if(valueIsNotNull(element: data[3])) { self.tags = data[3].value_.array_.map({$0.string}) }
        else                                 { self.tags = [] }

        if(valueIsNotNull(element: data[4])) { self.cycle = Cycle(elements: data[4].value_.object_)}
        else                                 { self.cycle = Cycle() }
        
        if(valueIsNotNull(element: data[5]))
                            // make dummy tasks
                            { self.super_tasks = data[5].value_.array_.map({task(id: $0.number)})}
        else                { self.super_tasks = [] }
        
        if(valueIsNotNull(element: data[6]))
                            // make dummy tasks
                            { self.sub_tasks = data[6].value_.array_.map({task(id: $0.number)})}
        else                { self.sub_tasks = [] }
        
        self.distance_to_global_bottom = data[7].value_.number
        /*
         [0] = id (number)
         [1] = title (string or null)
         [2] = note (string or null)
         [3] = tags (list or null)
         [4] = cycles (object or null)
         [5] = super tasks (list or null)
         [6] = sub tasks (list or null) are one same level and printed as a list of subtask titles
         [8] = distance to global bottom (number)
        */
    }*/
    func getChildren(root: task) -> [task]
    {
        return root.sub_tasks
    }
    func connect(tasks: [task])
    {
        // 2 tasks are the same if their attributes and subtask attributes and subtask attributes are the same
        // will assume same tasks that have different grandparent tasks to be different tasks

        // $0.id is the id number of each dummy task in super_tasks and sub_tasks
        self.super_tasks = self.super_tasks.map({tasks[$0.id]})
        self.sub_tasks = self.sub_tasks.map({tasks[$0.id]})
        // set 1's subtask to 2
        // did not set 2's supertast to 1
    }
    static func ==(left_task: task, right_task: task) -> Bool
    {
        return left_task.id == right_task.id &&
               left_task.title == right_task.title// &&
               //left_task.super_tasks.map({$0==})
    }
    /*
    func allEqual(left_tasks: [task], right_tasks: [task]) -> Bool
    {
        
        var i = 0
        // find smaller of 2 arrays = max
        // traverse both for max distance and if a_1 != b_1 return false
        // if traversal is sucessfull return true
        //while(i < )
    }*/
    /*
    init(values: [String], key_values: [json_key_value])
    {

        // add values
        //print("values")
        //print(values)
        // assumes the numberical string ids are before the string string ids



        self.title = values[0]
        self.note = values[1]

        self.tags = (2..<values.count).map({values[$0]})



        // add key_values
        //print("extras")
        //key_values.map({print($0.key, $0.value_string)})
        //print()
        // what happens if the value is ""?
        for key_value in key_values
        {
            if (key_value.key == "is_cycle")
            {
                // can only convert NSString to bool
                self.is_cycle = NSString(string: key_value.value_string).boolValue
            }
            if(key_value.key == "cycle_length")
            {
                self.cycle_length = key_value.value_int
            }
        
        }

    }*/
}
