//
//  other_functions.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 11/8/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

func recognize<T>(signifier: String, functionToCollectTheDataFromObject: () -> T) -> T?
{
    // returns T because we are collecting characters where the function f will return some object containing the characters
    // returns T? because of the return nil
    let first_character = getHeadOfStream()
    if(first_character == signifier)
    {
        self.stream = first_character + self.stream
        let contents_of = functionToCollectTheDataFromObject()
        _ = getHeadOfStream()
        return contents_of
    }
    self.stream = first_character + self.stream
    return nil
        
}

// make the parent_id -> [child ids]
// use hash table with linked list for collisions
// array of (key, value)'s
// value = (first value, head_of_collision_list)
// hash function = id % current size
// give hash table a size beforehand so hash function creates less collisions as size increases
// when capasity = 2/3 double the hash table size

class hash_table
{
    var hierarchy_root_index : Int
    // manually manage the view hierarchy
    var child_parent : [Int: Int]
    var values : [Value]
        // collisions don't discriminate between different keys and same keys with different values
    
    // if new parent already exists, try to add child to children
    // if new parent has same index as a different parent
        // add it to [value]()
    // indexes are the parents % current size
    
    var size : Float

    // for indicating when to resize self.values
    var current_population : Float
    
    // just in case automatic getters and setters don't do this
    init(size: Int)
    {
        // size must start at 4 for 2^power size calculations
        self.size = (size < 4) ? Float(4) : Float(size)
        self.current_population = 0
        self.values = [Value](repeating: Value(), count: size)
        self.hierarchy_root_index = 0
        self.child_parent = [Int: Int]()
    }
    init(){
        self.size = 4
        self.current_population = 0
        self.values = [Value](repeating: Value(), count: 4)
        self.hierarchy_root_index = 0
        self.child_parent = [Int: Int]()
    }

    func add(_ item: Value)
    {

        let i = item.parent % Int(self.size)

        // the mod will force all keys into [0, self.size - 1]
        // cannot assume sequential distribution in hash array
        // need to prove new item will go over limit
        if (self.values[i].parent == -1)
        {
            // add item to values[i]
            self.values[i] = Value(item: item)
            self.current_population += 1
            // when new value is added, add value : parent object to child_parent
            let is_boundary_population = self.current_population/self.size

            if(is_boundary_population >= 2/3)
            {

                // collect entire contents of values
                var old_values = getValues(self.values)
                old_values = old_values.map({Value(parent: $0.parent, child: $0.children[0])})
                self.size = self.size * 2
                self.current_population = 0
                let new_array = [Value](repeating: Value(), count: Int(self.size))
                self.values = new_array

                // can use add function because the 2/3 caluclation will never be hit
                for value in old_values
                {
                    // only adds to self.values
                    self.add(value)
                }
                
            }

        }
        
        // asuming item holds another child to add to values[i].children
        // or item has a different parent that has same i as a parent already in values array


        // if parents have same mod result and they are the same
            // add children
        else if (self.values[i].parent == item.parent)
        {
            // make new children array doubled from prev children array
            //var new_array = [value]()
            // copy all item

            // each child has a unique id
            self.values[i].addChild(item.children[0])

        }

        // if parents have same mode result and they are different
            // add parent to collision array
        else
        {
            // resize collision_values array
            self.values[i].addCollisionValue(item)
        }

    }
    
    func first(_ values: [Value]) -> Value
    {
        return values[0]
    
    }

    func rest(_ values: [Value]) -> [Value]
    {
        if(values.count == 0)
        {
            return []
        }
        var new_values = [Value]()
        for i in (1..<values.count)
        {
            new_values.append(values[i])
        }
        return new_values
    }
    func traverse(_ values: [Value], indents: String)
    {
        if(values.count > 0)
        {

            if(first(values).parent != -1)
            {
                print(indents + "parent:")
                print(indents + String(first(values).parent))
                print(indents + "children:")
                first(values).children.map({print(indents + String($0))})
                print()
            }
            if(first(values).collision_values.count > 0)
            {
                print(indents + "collision values:")
            }
            
            traverse(first(values).collision_values, indents: indents + "    ")

        
            traverse(rest(values), indents: indents)

        }
        
    }
    func getArray() -> [Value]
    {
        return self.values
    }
    func getValues(_ values: [Value]) -> [Value]
    {

        // each child inside value can have n numbers
        if(values.count == 0)
        {
            return []
        }
        
        // make a list of all pairs in value
        // need list of key, value pairs
        var old_values = [Value]()

        if(first(values).children_size > 0)
        {
            let old_value = first(values)
            // children can have empty values
            old_values = old_value.children.filter({$0 != -1}).map({Value(parent: old_value.parent, child: $0)})
        }
        // add all colision values to list
        // collision values may have empty values
        return old_values + getValues(first(values).collision_values) + getValues(rest(values))
        
    }
    
    func getValues2(parent: Int) -> [Int]
    {
        let i = parent % Int(self.size)
        
        return values[i].children
    }

    

}

// fails because type t != []

func cons<t>(_ first: t, rest: [t]) -> [t]
{
    var new_array = [t]()
    new_array.append(first)
    for item in rest
    {
        new_array.append(item)
    }
    return new_array
}

class Value
{
    var parent : Int
    var children : [Int]
    var children_size : Int
    // each value will have 1 child in it
    var collision_values : [Value]
    var collision_size : Int
    init()
    {
        // so empty parent doesn't conflice with filled parent
        self.parent = -1
        self.children = []
        self.children_size = 0
        self.collision_values = []
        self.collision_size = 0
        
    }
    init(item: Value)
    {
        // assumes item.children has only 1 item
        self.parent = item.parent
        self.children = [item.children[0]]
        self.children_size = 1
        self.collision_values = []
        self.collision_size = 0
    }
    init(parent: Int, child: Int)
    {
        self.parent = parent
        self.children = [child]
        self.children_size = 1
        self.collision_values = []
        self.collision_size = 0
    }
    func addChild(_ item: Int)
    {
        // self.children has only 1 child in it
        // don't add if child is already in children
        for child in children
        {
            if (item == child)
            {
                return
            }
        }
        // fill up all slots(not using insert)
        
        if (children.filter({$0 != -1}).count > 0)
        {
            var i = 0
            while ((i < children.count) && (children[i] != -1))
            {
                i = i + 1
                
            }
            if(i < children.count)
            {
                children[i] = item
                return
            }
        }
        // if it cannot be added
            // resize
        
        // add
        let new_size = self.children_size * 2
        var children_2 = [Int](repeating: -1, count: new_size)
        for i in (0..<self.children_size)
        {
        
            children_2[i] = self.children[i]
        }
        children_2[self.children_size] = item

        self.children = children_2
        self.children_size = new_size
    }
    func addCollisionValue(_ item: Value)
    {
        // self.collision_values has only 0 values in it
        if (self.collision_size == 0)
        {
            self.collision_values = [item]
            self.collision_size = 1
        }
        
        // self.collision_values has n values in it(as a result of this function)
        else
        {
            
            if(self.collision_values.filter({$0.parent != -1}).count > 0)
            {
                var i = 0
                while (i < self.collision_values.count)
                {
                    if(self.collision_values[i].parent > 0){i = i + 1}
                }
                if(i < self.collision_values.count)
                {
                    self.collision_values[i] = item
                    return
                }
            }
            let new_size = self.collision_size * 2
            var collision_values_2 = [Value](repeating: Value(), count: new_size)
            
            for i in (0..<self.collision_size)
            {
                collision_values_2[i] = self.collision_values[i]
            }
            collision_values_2[self.collision_size] = item
            // doubled 
            // values copied from original position
            // add to last item
            self.collision_size = new_size
            self.collision_values = collision_values_2
        }
    }
}

// persistent segmented control
// http://stackoverflow.com/questions/21104274/in-ios-7-mobile-safaris-bookmarks-how-did-apple-make-the-segmented-control-per
// move buttons by touching them
// http://stackoverflow.com/questions/4707858/basic-drag-and-drop-in-ios

    // button only appears on first view controller in stack
    // should go away with persistent segmented control
    /*
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        if (self.ui_segmented_button.selectedSegmentIndex == 1)
        {
            print("in calendar")
            // printing a button on tope of previous table view
            //let new_style = UITableViewCellStyle.Default
            //let new_task = Task(values: new_style, key_values: "test_cell")
            //new_task
            //new_task.title = "title"
            // can't add button to prototype cell
            // must create it programmably
            // must set up new view controller programably(for multiple views in view controller stack)
                // not sure how to do this
            //new_task.button.setTitleColor(UIColor.blueColor(), forState: .Normal)
            self.viewDidLoad()
        }
        else
        {
            print("in task")
        }
    }*/

func trimFullLeft(_ string: String, delimiter: Character) -> String
    {
    
        for i in string.characters.indices
        {
            if (string[i] != delimiter)
            {
                return string[i..<string.endIndex]

            }
        }
        
        // string has no dellimiters in front of it
        return string
    }
    
    
    func trimPartialRight(_ string: String, delimiter: String) -> String
    {
    
        var new_max = string.characters.count - 1
        print(string[string.characters.index(string.startIndex, offsetBy: new_max)], "|", delimiter[delimiter.startIndex], "|")
        while (string[string.characters.index(string.startIndex, offsetBy: new_max)] == delimiter[delimiter.startIndex])
        {
            new_max -= 1
        }
        // the string ends in 1 delimiter
        //print(string[string.startIndex..<string.startIndex.advancedBy(new_max + 1)])
        // the string view uses [lower_bound, upper_bound)
        return string[string.startIndex..<string.characters.index(string.startIndex, offsetBy: new_max + 1)] + delimiter
        
    }
    
    
    
    func trimAndSplit(_ string: String, delimiter: String) -> [String] {
    
        //print("before splitting")
        let a = trimPartialRight(trimFullLeft(string, delimiter: delimiter[delimiter.startIndex]), delimiter: delimiter)
        
        return split(a, delimiter:  delimiter)

        //return split(trimPartialRight(trimFullLeft(string, delimiter: delimiter[delimiter.startIndex]), delimiter: delimiter), delimiter: delimiter)
    }
    
    
    func split(_ string: String, delimiter: String) -> [String]
    {
        // delimiter = " " for examples
        // pattern = {string,[1, n] delimiters}
        print("string")
        print(string)
        print("quit")
        // find location of delimiter
        let location_of_delimiter = string.characters.index(of: delimiter[delimiter.startIndex])
        
        let i = string.characters.distance(from: string.startIndex, to: location_of_delimiter!)

        // delimiter starts the string off
        // " ghgfdertg"
        // usual pattern starts with a delimiter in front of the string
        
        //if (i == 0)
        //{
            // go 1 byond the delimiter
          //  return split(string[string.startIndex.advancedBy(i + 1)..<string.endIndex], delimiter: delimiter)
        //}
        //print("-", string[location_of_delimiter!], "-")
        //print(string)
        // traverse string untill first non-delimier is reached(dont use index of on split version because index will be different)
        // save the 2 locations as delimiter ranges [lower, upper]
        // ranges: range 1: [0, lower - 1], range 2: [lower + 1, string.characters.count - 1]
        // copy characters in string at range 1 = substring 1

        var substring_1 = String();
        //print("delimiter")
        //print(string[string.startIndex.advancedBy(i-1)])
 
        substring_1 = string[string.startIndex..<string.characters.index(string.startIndex, offsetBy: i)]
        print("substring_1")
        print(substring_1, "\n")
        // make a string that starts at the first occurence of the delimiter and goes to the end
        var substring_temp = String();
        substring_temp = string[string.characters.index(string.startIndex, offsetBy: i)..<string.endIndex]
        
        // make sure stop is of type String.CharacterView.Index
        //var stop = location_of_delimiter
        //print("before loop")
        //print("stop = ", stop!)
        
        //print(substring_temp[stop!])

        //print(substring_temp)
        //print("substring")
        //print(substring_temp, "\n")
        //print(substring_temp.characters.indices)
        //print("|", delimiter,"|")
        //print("now")
        // delimiter is a collection of delimiters with length >= 1
        // loop untill end of string or delimiter
        var substring_2 = substring_temp
        // should loop through all characters
        for i in substring_temp.characters.indices
        {
            // goes untill end of substring_temp.characters.indices
            //print("|",  substring_temp[i], "|" , delimiter[delimiter.startIndex] )
            //
            // should match the last element
            if(i == substring_temp.characters.index(substring_temp.startIndex, offsetBy: substring_temp.characters.count - 1))
            {
                // return substring 1
                return [substring_1]
            }

            // first character of next substring
            if (substring_temp[i] != delimiter[delimiter.startIndex])
            {
                substring_2 = substring_temp[i..<substring_temp.endIndex]
                // can't only return from here
                break
            }

            
            // if the last character is a delimiter then string[stop] = delimiter
        }
        //print(substring_1)
        //print(substring_2)
        //print("\n")
        // second string ends at delimiter means second string is made of delimiters
        // upper bound ends in delmiter
        // string.advancedBy(stop) = first non-delimiter after delimiter
        // if the first non delimiter after delimiter = last index
        //if(string.startIndex.distanceTo(stop!) == string.characters.count - 1)
        //{

          //  print("should be last substring")
           // print(string ,string.characters.count - 1, string.startIndex.distanceTo(stop!))
            //print("|", string[stop!], "|" )
            //return [substring_1]
        //}
        //let a = string.characters.count - 1
        //let upper_bound = substring_temp.startIndex.distanceTo(stop!)
        //print("upper_bound")
        //print(substring_temp[stop!])
        //let substring_2 = substring_temp[substring_temp.startIndex.advancedBy(upper_bound)..<substring_temp.endIndex]
        //print("substring_2")
        //print(substring_2)
        //print(substring_temp)
        //print(upper_bound)
        // cut second string at y + 1 then trim off the left delimiters
        // substring_1 = string[0.. <lower - 1].
        // copy characters in string at range 2 = substring 2
        // if second_string == nil
            // return empty string
        // return an array composed of each substring
        //print(cons())
        // return [first_string(if first_string != nil), split(second_string, delimiter)]
        //return cons(substring_1, rest: split(substring_2, delimiter: delimiter))
        return cons(substring_1, rest: split(substring_2, delimiter: delimiter))

    }
    
    
    
    /*
    https://codedump.io/share/aFBow03WGJWq/1/list-comprehension-in-swift

    f(char_list, " ")
    if first char = "" return nil list
    if else
        expand for all calls to see what happens to the strings
        take char_list and split it into 2 strings before and after the first " "

        return cons(first element ,f(second string, " "))
     
    
    */
    
    /*
    cons(first element, list of remaining elements)
        list = []
        list.append(first element)
        for remaining elements
            list.append(next element)
        return list
    
    */
    
    func cons(_ first: String, rest: [String]) -> [String]
    {
    
        //var list = [first] + rest

        //list.append(first)

        // should work if rest is empty
        //list = [first] + rest
        
        return [first] + rest
    }

    /*
    f(loop)(char_list, " ")
    list = []
    while char_list is not empty
        if first char = "" then return list
        else
            take char_list and split it into 2 strings before and after the first " "
            list.append(first string)
            char_list = second string
    return list
    */
    
    
    /*
    g(string) -> list(first string, second string)
    find location of delimiter
    find location of last delimiter in sequence of delimiters   erases all possible empty strings from forming
    
    first string = cut [0, delimiter_location_0 - 1]
    cpp : substr (0, delimiter_location_0 - 1)
    cpp : end = length(text) - 1
    second string =  cut [delimiter_location_n + 1, end]

    cpp : substr(delimiter_location_n + 1, end - delimiter_location_n + 1 )

    "dfgsas   " yelds an empty second string
    return list(first string, second string)
    
    
    */
    
    

    /*
    efficiency for cut
    cut(lower bound, end of string_o)
        change starting index of string_o to lower bound
        return string 
    cut(0, lower bound)
        change starting index of string_o to lower bound
        return string_o[0, lower bound]
    
    std::vector<std::string> split(const std::string &text, char sep) {
    std::vector<std::string> tokens;
    std::size_t start = 0, end = 0;
    while ((end = text.find(sep, start)) != std::string::npos) {
        std::string temp = text.substr(start, end - start);
        if (temp != "") tokens.push_back(temp);
        start = end + 1;
    }
    std::string temp = text.substr(start);
    if (temp != "") tokens.push_back(temp);
    return tokens;


// class viewcontroller

class viewController: UITableViewController {

        //@IBOutlet var test: UITapGestureRecognizer!

    var tableData = [String]()
    
    //@IBOutlet weak var ui_segmented_button: UISegmentedControl!
    //    var label_id = [[String: Int]]()
    //var id_is_child = [[Int: Bool]]()
    // array holding each label_id at its id in array
    //var id_label = [Int: String]()

    //var parent_child = [[Int: Int]]()

    //var parent_children = [Int: [Int]]()
   // for labels and ids

    
    //var tasks = [Int: task]()
    // have a local variable by same name
    //var id_maps = hash_table()
    //var task_prototype = Task(values: UITableViewCellStyle.Default, key_values: "test_cell")


    //var stream = String()
    // easier to change if back_to_stream is member variable
    //var back_to_stream = String()
 


 

    //var  x = TaskData(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
    
    //var object =
    //var tableData = []
    //var new_view = UITableView()
    //var new_view_controller = UITableViewController()

    /*override init()
    { super.init(style: UITableViewStyle.Plain)
    }*/

    

    // turns off Must call a designated initializer of the superclass 'UITableViewController' error
    // http://stackoverflow.com/questions/30316021/how-to-resolve-designated-initialization-error-for-uitableviewcontroller
    //super.init(nibName: nil, bundle: nil)
            // compiles but is ignoring embeded navigation controller and selection
    //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
            
     
            //let new_style = UITableViewCellStyle.default
            //let btn = UIButton(type: UIButtonType.system) as UIButton

/*
  btn.backgroundColor = UIColor.blueColor()
  btn.setTitle("Button", forState: UIControlState.Normal)
  btn.frame = CGRectMake(100, 500, 200, 100)
  btn.addTarget(self, action: #selector(viewController.clickMe(_:)), forControlEvents: UIControlEvents.TouchUpInside)
  self.view.addSubview(btn)
  
let btn2 = UIButton(type: UIButtonType.System) as UIButton


  btn2.backgroundColor = UIColor.blueColor()
  btn2.setTitle("Button", forState: UIControlState.Normal)
  btn2.frame = CGRectMake(100, 300, 200, 100)
  btn2.addTarget(self, action: #selector(viewController.clickMe(_:)), forControlEvents: UIControlEvents.TouchUpInside)
  self.view.addSubview(btn2)*/
  
    
    
    
    
     /*
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    return tableData.count
    }
    /*override func cellForRowAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell?{}*/
	
    override func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
    //let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"cell")
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
    // sets the text for the cell
    cell.textLabel?.text = tableData[(indexPath as NSIndexPath).row]
    //cell.
    //var btnName = cell.viewWithTag(1)
    //btnName.se
//[btnName setTitle:[maTheData objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
    return cell
    }
    */
    
   // use as template
       // same function signature
    
    // take out of class
    
    

    }


//http://lauraskelton.github.io/blog/2014/06/20/hacker-school-day-9/
/*
class BinaryTree {

    var data: Int?

    var left: BinaryTree?
    var right: BinaryTree?

    init() {
    }

    func insert(_ d: Int) {

        if (self.data == nil) {

        } else {

            if d < self.data {
                if let l = self.left {
                    l.insert(d)
                } else {
                    let tree = BinaryTree()
                    tree.data = d
                    self.left = tree
                }
            } else {
                if let r = self.right {
                    r.insert(d)
                } else {
                    let tree = BinaryTree()
                    tree.data = d
                    self.right = tree
                }
            }
        }
    }
}
*/

class ViewController: UIViewController {

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
   */
/*
// http://stackoverflow.com/questions/32309909/perform-segue-with-identifier-wont-work-in-swift-2
class MyCustomSegue: UIStoryboardSegue
{

    override func perform() {
    
      let  src = self.sourceViewController
      let dst = self.destinationViewController
      src.navigationController?.pushViewController(dst, animated: true)
}

}*/
/*func addToParentChildren(_ parent_children: [String])
    {
        //print(parent_children)
        let numbers = parent_children.map({Int($0)!})
        //print(numbers)
        
        let parent = numbers[numbers.startIndex.advanced(by: 0)]
        print(parent)
        
        var children = [Int]()
        for character in numbers[numbers.indices.suffix(from: numbers.startIndex.advanced(by: 1))]
        {
        
            children.append(character)
        }
        print(children)
        
        //var new_entry = [Int: [Int]]()
        //new_entry.updateValue(children, forKey: parent)
        self.parent_children.updateValue(children, forKey: parent)
    
    }*/
/*
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        
        
        //******** creating label programmatically*******//
        
        let label = UILabel(frame: CGRect(x: 120, y: 80, width: 150, height: 100))  
        //label.center = CGPointMake(160, 284)  
        label.textAlignment = NSTextAlignment.center  
        label.text = " ^Click the above button to move to next view controller <<< uiview"  
        label.numberOfLines=4  
        self.view.addSubview(label)  
        
        let sliderlabel = UILabel(frame: CGRect(x: 120, y: 240, width: 150, height: 100))
        //label.center = CGPointMake(160, 284)  
        sliderlabel.textAlignment = NSTextAlignment.center  
        sliderlabel.numberOfLines=4  
        self.view.addSubview(sliderlabel)  
        
        
        //******** creating button programmatically*******//
        
        let button=UIButton(frame: CGRect(x: 20, y: 20, width: self.view.frame.width-40, height: 40))  
        button.backgroundColor=UIColor.blue  
        button.setTitle("Ravi Kumar", for: UIControlState())  
        button.setTitleColor(UIColor.yellow, for: UIControlState())  
        button.alpha=0.6  
        button.layer.borderWidth=0.3  
        button.layer.cornerRadius=2  
        //*** button action***//
        // # selector is using class name even though there is no instance of the class name
        // here
        button.addTarget(self, action: #selector(self.clickMe(_:)), for: .touchUpInside)
        button.titleLabel!.textAlignment=NSTextAlignment.center  
        self.view.addSubview(button)  
        
        
        //******** creating UIView programmatically *********//
        
        let view=UIView(frame: CGRect(x: 20, y: 80, width: 100, height: 100))  
        view.backgroundColor=UIColor.yellow  
        view.layer.borderColor=UIColor.black.cgColor  
        view.layer.cornerRadius=25  
        view.layer.borderWidth=6  
        self.view.addSubview(view)  
        
        //******** creating textfield programmatically********//
        
        let myTextField = UITextField(frame: CGRect(x: 20, y: 200, width: self.view.frame.width-40, height: 40.00))  
        myTextField.backgroundColor = UIColor.gray  
        myTextField.placeholder="  Enter here"  
        //myTextField.text = "    Enter here"  
        myTextField.borderStyle = UITextBorderStyle.line  
        myTextField.isSecureTextEntry=true  
        self.view.addSubview(myTextField)  
        
        //******** creating UIslider ***********//
        
        let slider=UISlider(frame:CGRect(x: 20, y: 260, width: self.view.frame.width-40, height: 20))  
        slider.minimumValue = 0  
        slider.maximumValue = 100  
        slider.isContinuous = false  
        slider.value = 0  
        slider.addTarget(self, action: #selector(self.clickMe(_:)), for: .valueChanged)
        self.view.addSubview(slider)  
        
        
        
        //********** creating UISwitch programmatically *******//
        
        let customSwitch=UISwitch(frame:CGRect(x: 150, y: 300, width: 50, height: 30))  
        customSwitch.setOn(true, animated: false)  
        customSwitch.addTarget(self, action: #selector(self.clickMe(_:)), for: .valueChanged)
        self.view.addSubview(customSwitch)  
        
        
        
        //********** creating UITextView programmatically *******//
        
        let textview=UITextView(frame:CGRect(x: 20, y: 330, width: self.view.frame.width-40, height: 60))  
        textview.isScrollEnabled=true  
        textview.backgroundColor=UIColor.gray  
        textview.textColor=UIColor.blue  
        textview.textAlignment=NSTextAlignment.center  
        self.view.addSubview(textview)  
        
        
        
        //********** creating UIImageView Programmatically******//
        
        let imageView = UIImageView(frame: CGRect(x: 20, y: 400, width: 100, height: 150))  
        let image = UIImage(named: "image.jpg")  
        imageView.image = image  
        self.view.addSubview(imageView)

        // Add a green line with thickness 1, width 200 at location (50, 100)
        let line = UIView(frame: CGRect(x: -50, y: 100, width: 200, height: 1))
        line.backgroundColor = UIColor.green
        self.view.addSubview(line)
        
    }
    */
/*
    func clickMe(_ sender:UIButton!)
    {
        // only 1 lower view will be on navigation controller stack at any time
        if(self.navigationController?.viewControllers.count > 0)
        {
            self.navigationController!.popViewController(animated: false)
        }
        print("button clicked")
        print(sender.frame.origin.y)

        

        
        let x = ViewController()
        self.navigationController!.pushViewController(x, animated: true)

    }*/
/*
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
    */
 /*
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
    */
func collectWhileTrue( f: ((Character) -> (Bool))!) -> [Character]
{

    
    // inout doesn't allow optionals
    //print("stream")
    //print(stream)
    
    if (self.stream.isEmpty)
    {
        return []
    }
    var array1 = [Character]()
    var head = self.stream[i]//String(stream[stream.characters.startIndex])
    // head was not removed only copied
    //print("first head")
    //print(head)
    // while the head satisfy the condition
    while(f(head))
    {
        array1.append(head)
        // pull off head
        i = i + 1
        //stream.remove(at: stream.characters.startIndex)
        if(i == self.stream.count/*self.stream.isEmpty*/)
        {
            break
        }
        // set new head
        head = self.stream[i]//String(stream[stream.characters.startIndex])
    }
    //exit(0)
    /*

    var head = stream[stream.characters.startIndex]
    stream.remove(at: stream.characters.startIndex)
    // fix?
    // http://stackoverflow.com/questions/29981505/swift-how-to-optionally-pass-function-as-parameter-and-invoke-the-function

    while (f(head))
    {
        array1.append(head)
        //print("array1")
        //print(array1)
        //print("stream")
        //print(stream)
        // only true if boundary to be found in stream is 1 position byond the stream
        if (self.stream.isEmpty)   // can't seem to test 1 position beyond the string
        {
            break
        }
        else
        {
            //print("head from get till condition")
            //print(head)
            //print("current stream")
            //print(stream)
            head = stream[stream.characters.startIndex]
            stream.remove(at: stream.characters.startIndex)

        }
    
    }
    // stream has already been put back together
    // if last head is a context pivot(non-whitespace) parser fails
    // puts last head back into stream 
    // if number last head could be " " or "}" (covered in other functions)
    // else last head could be """
    //self.stream = String(head) + self.stream
    //print("after loop")
    //print(stream)
    //print()
    */
    return array1
}

