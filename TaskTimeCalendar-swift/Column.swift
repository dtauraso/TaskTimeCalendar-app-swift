//
//  Column.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 5/13/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

// must subclass Hashable
class label_id: Hashable
{

    // try to make the hash value be of type Int
    var label : String
    var id : Int

    // comforms to protocol hashable
    var hashValue: Int
    {
        return self.id
    }

    init(id: Int, label: String)
    {
        self.label = label
        self.id = id
    }
}

// conforms to protocol equality
func ==(lhs: label_id, rhs: label_id) -> Bool
{
    return lhs.id == rhs.id
}

/*
class User: Hashable {
  var uid: Int
  var name: String
  var hashValue: Int {
      return self.uid
  }

  init(uid: Int, name: String) {
    self.uid = uid
    self.name = name
  }
}

func ==(lhs: User, rhs: User) -> Bool {
  return lhs.uid == rhs.uid
}
*/

class column
{

    // bool is for if a child or not
    // title_id to prevent collision with label_id
    var label_id = [String: Int]()

    // array holding each label_id at its id in array
    var id_label = [Int: String]()

    var parent_child = [Int: Int]()

    
    //var id_tags = [Int: tags]()
    // tags are a collection of strings
    var id_notes = [Int: String]()

    /*
    save file for labels, ids, and is_child
    parent child(id)  labels
    12      11        ""
    11      0 	      lists
    0       1 	      prints
    1       2 	      5           title
    2       10        start of new column in 5
    0       8         canceled    tag
    8       9         tag 2       tag
    0       3 	      printss
    3       4 		  55
    0       5 		  printsss title
    5       6 		  x title
    6       7 		  y title

    root is first row and is first row in table
    lists is clicked on
    
     "" (11)
        lists (0)
            prints (1)
            5 (2)
                start of new column (10)
            canceled (8)
            tag 2 (9)
            printss (3)
            55 (4)
            printss (5)
            x
            y
     
     0 -> 1  (prints)
     0 -> 8 (canceled)
     0 -> 3 (printss)
     0 -> 5 (printss)
     all are children because keys are the same
     
     1) get all children ids
     2) get all subschildren ids
     keep doing 1 and 2 untill no more descendents of 0 are found
     put all descendents into data structures for next viewController on stack
     
    map chain # = depth
    0 is a map chain of 0
    0 -> 1 is a map chain of 1

     0 -> 1 (prints)
     1 -> 2 (5)
     2 -> 10 (start of new column)

    
    [parent_id, child_id = parent_id + 1]
    [parent_id + 1, child_id = parent_id + 2] = parent_id, parent_id + 1, parent_id + 2
    ends when child_id is not a parent
    is_child says if sequence starting at child is inside catagory at id parent
    is_child = 1 is the start of a new sequence
    when the sequence ends and there were no subsequences then the data in the sequence was the rest of the task attributes
    sequence starts at pos 8 
        there are no subsequences
    tag
    1  tag 1, tag 2, tag 3
    0
    
    notes
    1  notes on 1 line
    0
    
    
    if there are no task attributes then task titles are assumed to be task attributes
    
    only works if there are task attributes, but requires rows of task attribute place holders for the items with less or no task attributes
    too many things in 1 database file


make separate files for tags, dates, titles(catagories), notes

lists
	prints
	5
	printss
	55
	printsss
	x
	y
    */
    // data structure for a single node
    // nsmutabledictionay
    // map 1 [label_object id]
    //var label_object_id = [label_id: Int]()
    
    
    
}








// (label, id)
// label = (label_text, id_of_start_of_child_array) class w NSString, NSNumber

// is the progressive line of id's part of the column or part of the project/task attributes?
// label = (label_text, is_child)

// map 2 [id sub_id]





// rules w map 2
// columns = [id id + 1]
//           [id + 1 id + 2]