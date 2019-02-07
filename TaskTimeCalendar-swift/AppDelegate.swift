//
//  AppDelegate.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 4/21/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit
//import "ViewController"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


// [{"state" : ["next_state", "next_state"], "level" : 1, "parent_classes": [level_number : inner_var1, level_number : inner_var2], "accepting_state" : false, "print_state_names_of_descendents" : true},
//]
        var items : [Item] = [Item]()

        // dummy state is the first previous state
        var previous_state : String = "start1"
        var task_nest : Int = 0
        var current_class : String = "no class"
        var level : Int = -1
        var entry_class_states_completed = false
        var nest_flag : Bool = Bool()
        //var prev_state = "start1"
        var level_number_max_state_name_string_count : [Int: Int] = [Int: Int]()
        var number_of_processes : Int = -1



        // record changes in state class

        /*
            class as state
            more attributes for each state

        */
        //   : ["children" : [],"allowedtoPrintChildrenStateNames" : ]
        var print_child_state_rules : [String: [String: Any]] = [
            "entry_class"   : ["children" :
                                ["start", "transfer_to_entry_class", "push_to_stack", "view_did_load_regular"],
                                "allowedtoPrintChildrenStateNames" : true ],
            "task_fst"      : ["children" :
                                ["delete_nested_item_in_task_view", "task", "add_item_to_item_stack", "cal"],
                                "allowedtoPrintChildrenStateNames" : true],
            "calendarFST"   : ["children" :
                                ["transfer_to_calendar_fst", "view_did_load_regular_2", "load_up_calendar", "tasks"],
                                "allowedtoPrintChildrenStateNames" : true]
        ]

        // use a [state: [label, next state]]


        /*

        [current: [next_states]]

        [current: ["start_of_sequnce" : true]]

        [current: ["level" : 1]]

        [current: ["accepting_state" : true]]

        [current: ["parent_classes" : [parent_class : level_number]]]

        */
        //func addStartOfSubGraph(state_graph) -> [String: [String: Any]]
        //{

        //}
        var hierarchial_state_machine : [String: [String: Any]] =


            // classes not added as states
            // classes names like classes the windows are attached to are mirror classs for the class attached to the window
            // each state can only be associated with 1 class
            // initialize is a dummy class
            // ["next_states" : [], "level" : , "parent_classes": ["" : ], "accepting_state" : , "action_state" : , "conditional_state" : , "user_interaction_state" : ]
            // only put state and its kind here
                            //"level" : 1,
                //"parent_class": "entry_class", "parent_class_level" : 0,
                // delete "action_state" : true, "conditional_state" : false, "user_interaction_state" : false
                // put the above in the classes
                // make in to smaller state machines
            [
                // class dicts have a flag(is_class) and their variables are in their class def while the control graph is here
                // everything else is a dict(non ui structures are dicts)
                // same debug system as in the python one
                // https://stackoverflow.com/questions/24418951/array-of-functions-in-swift

                /*
        	('date_time',
					[
						('state_graph',
							(
								('#',
									[
										[(('#', 0), ('/'    ,0), (':', 0))],
										[lambda graph, state_trackers, current_state_machine, current_state, case_, stack: collect(graph, state_trackers, current_state_machine, current_state, case_, stack)],
										[sub_machine]
									]
								),

							)
						),
				[
					('input_tape',  ''),

					('indent_level', 3),
					('isDigit', lambda i: isDigit(i)),
					('parent_states', ['start_shift', 'end_shift'])
				]
				]
	)
        */
        /*
        	('task_fst',
					[
						('state_graph',
							(
								('view_did_load_regular',
									[
										[(('task_window', 0))],
										[lambda graph, state_trackers, current_state_machine, current_state, case_, stack: viewDidLoadRegular(graph, state_trackers, current_state_machine, current_state, case_, stack)],
										[]
									]
								),
                                ('last_view_gone',
                                    [
                                        [(('task_window', 0))],
                                        [lambda graph, state_trackers, current_state_machine, current_state, case_, stack: lastViewGone(graph, state_trackers, current_state_machine, current_state, case_, stack)],
                                        []
                                    ]

                                ),
                                ('task_window',
                                    [
                                        [(('delete_nested_item_in_task_view', 0), ('task', 0), ('check_mark', 0), ('cal', 0))],
                                         [lambda graph, state_trackers, current_state_machine, current_state, case_, stack: taskWindow(graph, state_trackers, current_state_machine, current_state, case_, stack)],
                                         []
                                    ]
                                ),
                                ('delete_nested_item_in_task_view',
                                    [
                                        [(('last_view_gone', 0))],
                                        [lambda graph, state_trackers, current_state_machine, current_state, case_, stack: deleteNestedItemInTaskView(graph, state_trackers, current_state_machine, current_state, case_, stack)],
                                        []

                                    ]

                                ),
                                ('task',
                                    [
                                        [(('view_did_load_regular', 0))],
                                        [lambda graph, state_trackers, current_state_machine, current_state, case_, stack:
                                          task(graph, state_trackers, current_state_machine, current_state, case_, stack)],
                                        []

                                    ]

                                ),
                                ('cal',
                                    [
                                        [(('view_did_load_regular_2', 0))],
                                        [lambda graph, state_trackers, current_state_machine, current_state, case_, stack:
                                          cal(graph, state_trackers, current_state_machine, current_state, case_, stack)],
                                        []

                                    ]

                                )

							)
						),
				[
					('input_tape',  ''),

					('indent_level', 3),
					('isDigit', lambda i: isDigit(i)),
					('parent_states', ['start_shift', 'end_shift'])
				]
				]
	)



        */
                "entry_class" : [
                            "start1" : ["next_states" : ["start1"]],

                ],
            /*
               [ state_name, [
                                [ [[next_state, next_case], [next_state, next_case]]
                                ],
                                lambdas are in the class to be passed in when the action function is called
                                [ sub_machine_dict_already_defined
                                ]
                            ]
                ]
            */
            // add another property that holds the name of the api function that checks for the state
            // and print it out with the state
                // entry_class

                // both (start) and (end) terms in state diagram map to "barrier_operation_sequence" : true
                // a subgraph is a set of states that run when the user does 1 interaction with the interface
                // starts on start1 because there needs to be a previous state to allow the traversal function to get to the current state
                // the api functions and the previous state have next states
                "start1"                            : ["start_of_sub_graph" : true,  "next_states" : ["start"]],

                "start"                             : ["start_of_sub_graph" : true,  "next_states" : ["view_did_load_regular"]],


                // task_fst

                "view_did_load_regular"             : ["start_of_sub_graph" : false,  "next_states" : ["task_window"]],


                "last_view_gone"                    : ["start_of_sub_graph" : false,  "next_states" : ["task_window"]],


                "task_window"                       : ["start_of_sub_graph" : false,  "next_states" : ["delete_nested_item_in_task_view", "task", "check_mark", "cal"]],




                // cell
                "check_mark"                        : ["start_of_sub_graph" : true,  "next_states" : ["end"]],

                "timer"                             : ["start_of_sub_graph" : true,  "next_states" : ["timer_has_been_recorded", "record_time"]],
                "timer_has_been_recorded"           : ["start_of_sub_graph" : false, "next_states" : ["stop_timer"]],
                "stop_timer"                        : ["start_of_sub_graph" : false, "next_states" : ["end"]],
                "record_time"                       : ["start_of_sub_graph" : false, "next_states" : ["end"]],

                "info"                              : ["start_of_sub_graph" : true,  "next_states" : ["clicked_back"]],



                //


                "delete_nested_item_in_task_view"   : ["start_of_sub_graph"  : true, "next_states" : ["last_view_gone"]],


                "task"                              : ["start_of_sub_graph"  : true, "next_states" : ["view_did_load_regular"]],


                "cal"                               : ["start_of_sub_graph"  : true, "next_states" : ["view_did_load_regular_2"]],
                //


                // calendarFST
                "view_did_load_regular_2"           : ["start_of_sub_graph"  : false, "next_states" : ["tasks"]],


                "tasks"                             : ["start_of_sub_graph"  : true, "next_states" : ["task"]],
                //


                // entry_class
                "transfer_to_entry_class"           : ["start_of_sub_graph" : false, "next_states" : ["view_did_load_for_nested"]],


                "view_did_load_for_nested"          : ["start_of_sub_graph" : false, "next_states" : ["view_did_load_nested"]],

                "view_did_load_nested"              : ["start_of_sub_graph" : false, "next_states" : ["task_window"]],


                //
            ]


            // don't do any of this
            // cell state machine doesn't rely on a window to load, so it can act as a data structure(dict)
            // make a debug function that adds start_of_sub_graph: true to the nodes being used for debugging
            // if the state machines are on the same level, make a sequence of them
            // store only the state graph as a dict(don't put any variables into it)


        // use htm network for the tasks, and the button id's in the dict

        func allowedtoPrintChildrenStateNames(previous_state: String) -> Bool
        {
            // prove what class tracers's class is being used right know
            //let the_parent : String = getParent(previous_state: previous_state)
            let parents : String = (hierarchial_state_machine[previous_state]!)["parent_class"] as! String

            let x : Bool = (print_child_state_rules[parents]!)["allowedtoPrintChildrenStateNames"] as! Bool
            return x

        }
        func delimiters(level: Int, delimiter: String) -> String
        {
            if(level < 0)
            {
                print("level", level)
                exit(0)
            }
            var string = ""
            for _ in (0..<level)
            {
                string = string + delimiter
            }
            return string

        }


        func printBreakInSequence(previous_state: String)
        {

            let x : Bool = (hierarchial_state_machine[previous_state]!)["start_of_sub_graph"] as! Bool
            if x
            {
                number_of_processes = number_of_processes + 1
                print(  "\n\n-------------------------------------------------------------\n" +
                        String(number_of_processes) + "\n")
            }
        }

        func debug(action: String, state: String, indent_level: Int, found_in_api_call: String) -> String
        {
            //printBreakInSequence(previous_state: state)
            return  delimiters(level: indent_level, delimiter: "     ") +
                    action +
                    " " +
                    state +
                    delimiters(level: indent_level + 5, delimiter: "-") +
                    "  " +
                    found_in_api_call +
                    previous_state


        }
        func test( previous_state: inout String, action: ((String, String) -> Bool), found_in_api_call: String, options: [String])
        {
            // assume that either the options or the next states has only 1 item in it or intersection fails to find only 1 state
            // assume prev's neighbors intersect with options to produce a set of states
            // try all of them untill one runs that is true
            let next_states = ((hierarchial_state_machine[previous_state]?["next_states"]) as? [String])!

            //print("next states", next_states)
            //print("fst")
            _ = [String]()
            _ = [String]()
            var intersection = [String]()
            print(next_states, options)
            // sort both
            for i in next_states
            {
                for j in options
                {
                    if i == j
                    {
                        intersection.append(i)
                    }
                }
            }
            print(intersection)
            for k in intersection
            {
                // run it
                // if it passed
                if action(k, found_in_api_call)
                {
                    previous_state = k
                    break
                }
                    // prev = k
                    // break
            }
            // run n^2 algorithm
            /*
            for each i in A
                for each j in B
                    if j == i
                        collect

            collect.map({action($0)})
            run all states untill hit a state that returns true

            */
            // find current state from an intersectio of the last state's neighbors and the options offered in the apple api call this function is called in
            // get the states from teh intersection and try them from first to last untill I hit a true
            // use longest common sequence with chart to solve this
            // test with 2 sequences first
            // don't look at the internet
            /*if options.count == 1
            {
                small_item = options
                large_item = next_states
                //print("next states", large_item, small_item[0])


            }
            else if next_states.count == 1
            {
                small_item = next_states
                large_item = options
                //print(large_item, "next state", small_item[0])


            }
            // if intersection is multiple nodes long, run all of them
                // set the previous state to the first one that returns true
            large_item.sorted()
            for item in large_item
                {
                    //print(item , "--------", small_item[0])
                    if item == small_item[0]
                    {
                        //print(item , "passed")
                        if action(small_item[0], found_in_api_call)
                        {
                            //prev_state = prev_state

                            previous_state = small_item[0]
                            //print(previous_state)
                            //previous_state = prev_state
                            break
                        }
                    }
                }*/
            print()
            print()

        }



        // entry point to storyboard
        // applicationWillFinishLaunching happens after storyboard entrypoint is loaded
        func logFunctionName(string: String = #function){
            self.function_name = string
        }
        func myFunction() {
        logFunctionName() // Prints "myFunction()".
        }
    
        func testing2(current_state_name: [String], parser: inout Parser, stack: ChildParent) -> Bool
        {
            // if parsing the input then call this only
            // make into a macro
            logFunctionName()
            return true
        }
        func returnTrue2(current_state_name: [String]) -> Bool
        {
            return true
        }
        func returnFalse2(current_state_name: [String]) -> Bool
        {
            return false
        }
        var function_name: String = String()
        /*
            func sum(a: Int, b: Int) -> Bool {
            return (a + b) == 0
        }*/
        func debugLog(functionName: String = #function) {
            print("\(functionName)\n")
        }
        func readFile(file: String) -> String
        {
        
            //let file = "input" //this is the file. we will write to and read from it

            //let text = "some text" //just a text
            var text2: String = String()
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                let fileURL = dir.appendingPathComponent(file)

                //writing
               // do {
               //     try text.write(to: fileURL, atomically: false, encoding: .utf8)
               // }
                //catch {/* error handling here */}

                //reading
                do {
                    text2 = try String(contentsOf: fileURL, encoding: .utf8)
                }
                catch {
                print("can't read file")
                /* error handling here */
                
                }
            }
            return text2
        }
        func readjson(fileName: String) -> NSData
        {

            let path = Bundle.main.path(forResource: fileName, ofType: "json")
            let jsonData = NSData(contentsOf: URL(fileURLWithPath: path!))//NSData(contentsOfMappedFile: path!)

            return jsonData!
        }
        let function_name_to_function: [String: ([String], inout Parser, ChildParent) -> Bool] = [
            "returnTrue"                    : returnTrue,
            "returnFalse"                   : returnFalse,
            "advanceInit"                   : advanceInit,
            "collectName"                   : collectName,
            "advanceLoop"                   : advanceLoop,
            "endOfInput"                    : endOfInput,
            "isData"                        : isData,
            "printData"                     : printData,
            "tlo"                           : tlo,
            "isDeadState"                   : isDeadState,
            "isChildren"                    : isChildren,
            "isNext"                        : isNext,
            "isCurrentWordFunction"         : isCurrentWordFunction,
            "saveState"                     : saveState,
            "saveNewState"                  : saveNewState,
            "advanceLevel"                  : advanceLevel,
            "saveNextStateLink"             : saveNextStateLink,
            "initJ"                         : initJ,
            "initI"                         : initI,
            "charNotBackSlashNotWhiteSpace" : charNotBackSlashNotWhiteSpace,
            "backSlash"                     : backSlash,
            "whiteSpace0"                   : whiteSpace0,
            "collectLastSpace"              : collectLastSpace,
            "forwardSlash0"                 : forwardSlash0,
            "inputHasBeenReadIn0"           : inputHasBeenReadIn0,
            "forwardSlash"                  : forwardSlash,
            "whiteSpace1"                   : whiteSpace1,
            "inputHasBeenReadIn2"           : inputHasBeenReadIn2,
            "addLinkToState"                : addLinkToState,
            "isCurrentWordASiblingOfPrevWord" : isCurrentWordASiblingOfPrevWord,
            "initK"                         : initK,
            "isFirstCharS"                  : isFirstCharS,
            "letter"                        : letter,
            "letterUnderscoreNumber"        : letterUnderscoreNumber,
            "leftParens"                    : leftParens,
            "colon"                         : colon,
            "rightParens"                   : rightParens,
            "collectLetter"                 : collectLetter,
            "collectLetterUnderscoreNumber" : collectLetterUnderscoreNumber,
            "inputEmpty"                    : inputEmpty,
            "runs"                          : runs,
            "saveFunctionName"              : saveFunctionName,
            "isCurrentWordADifferentParentOfPrevWord" : isCurrentWordADifferentParentOfPrevWord,
            "windBackStateNameFromEnd"      : windBackStateNameFromEnd,
            "isAStateName"                  : isAStateName,
            "isCurrentIndentSameAsIndentForLevel" : isCurrentIndentSameAsIndentForLevel,
            "deleteCurrentStateName"        : deleteCurrentStateName,
            "isCurrentIndentGreaterThanAsIndentForLevel" : isCurrentIndentGreaterThanAsIndentForLevel,
            "deleteTheLastContext"          : deleteTheLastContext,
            "incrementTheStateId"           : incrementTheStateId,
            "decreaseMaxStackIndex"         : decreaseMaxStackIndex,
        ]
        func makeDataObject(value: [String: String]) -> Data
        {
            var data_item : Data = Data.init(new_data: [:])
            //print(value)

            if(value["nothing"] != nil)
            {
                if(value["nothing"] == "null")
                {
                    data_item.data = [:]
                }
            }
            else if (value["Int"] != nil)
            {
                data_item.data = ["Int": Int()]
                if(value["Int"] == "nil")
                {
                    data_item.data["Int"] = 0
                }
                else
                {
                    data_item.data["Int"] = Int(value["Int"]!)

                }
                
            }
            else if(value["String"] != nil)
            {
                data_item.data = ["String" : String()]

                data_item.data["String"] = value["String"]
            }
            else if(value["[Point: ContextState]"] != nil)
            {
                data_item.data = ["[Point: ContextState]": [Point: ContextState]()]
            }
            else if(value["[[String]: Point]"] != nil)
            {
                data_item.data = ["[[String]: Point]" : [[String]: Point]()]
            }
            else if(value["[String]"] != nil)
            {
                data_item.data = ["[String]" : [String]()]
            }
            return data_item
        }
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            //
            // make non-ui classes here
            //x = ["test"]
            //print("blablabla")
            nest_flag = false
            let new_context: ContextState = ContextState.init(name: ["ss"],
                                                              nexts: [["ss"]],
                                                              start_children: [["ss"]],
                                                              function: testing2,
                                                              function_name: "test",
                                                              data: Data.init(new_data: [:]),
                                                              parents: [["ss"]])
            var parser: Parser = Parser.init()

            print(new_context.getName(),
                  new_context.getStartChildren(),
                  new_context.getParents(),
                  new_context.getNexts(),
                  new_context.getFunctionName())
            //debugLog(functionName: #testing)
            //testing2(current_state_name: [], parser: &parser, stack: )
            print(self.function_name.count)
        

            /*
            ContextState.init(name: <#T##[String]#>,
                                                               start_children: <#T##[[String]]#>,
                                                               parents: <#T##[[String]]#>,
                                                               children: <#T##[[String]]#>,
                                                               nexts: <#T##[[String]]#>,
                                                               function: <#T##([Point : ContextState], [String]) -> Bool#>,
                                                               function_name: <#T##String#>,
                                                               data: <#T##[String : Any]#>)

                */
            //let parser: Parser = Parser.init()
            /*parser.testing(levels: parser.levels,
                           state_point_table: parser.state_point_table,
                           current_state_name: ["input"])
            */
            var name_state_table = [[String]: ContextState]()
            var data: String = readFile(file: "parsing_tree.json")
            /*
            let json_parser = JSONParser.init()
            var stream: [Character] = [Character]()
            for item in data
            {
                stream.append(item)
            }*/
            /*
            let result = json_parser.jsonObject(json_string: &stream)
            //print(result)
            
            for i in result
            {
                print(i.key)
            }*/
            var my_struct: [x] = [x]()
            do
            {
                my_struct = try JSONDecoder().decode([x].self, from: data.data(using: .utf8)!) // decoding our data
            }
            catch
            {
                print(error)
            }
            for item in my_struct
            {
                //print(item.name, item.data)
                //print()
                /*
                name:                  [String],
             nexts:                 [[String]],
             start_children:        [[String]],
             children
             function_name:         String,
             data:                  Data,
             parents:
                */
                name_state_table[item.name] = ContextState.init()
                name_state_table[item.name]?.name = item.name
                name_state_table[item.name]?.nexts = item.nexts
                name_state_table[item.name]?.start_children = item.start_children
                name_state_table[item.name]?.children = item.children
                name_state_table[item.name]?.function_name = item.function_name
                name_state_table[item.name]?.data = makeDataObject(value: item.data)
                name_state_table[item.name]?.parents = item.parents
                //name_state_table[item.name]?.Print(indent_level: 0)
                //print()
            }
            name_state_table[["input"]]?.getData().setString(value: readFile(file: "data_and_dead_state_parsing_only_input.txt") )
            //print((name_state_table[["input"]]?.getData().getString())!)
            let visitor_class: Visit = Visit.init(next_states: [["states", "state"]],
                                              current_state_name:    ["states", "state"],
                                              bottom:                ChildParent.init(child: ["root", "0"],
                                                                                      parent: nil),
                                              dummy_node:            ContextState.init(name:["root", "0"],
                                                                                       nexts: [],
                                                                                       start_children: [],
                                                                                       function: returnTrue(current_state_name:parser:stack:),
                                                                                       function_name: "returnTrue",
                                                                                       data: Data.init(new_data: [:]),
                                                                                       parents: []),
                                              name_state_table:     name_state_table)
            // need to get the states into name_state_table
            //parser.runParser()
            // read in the json file
            // make the ContextState objects and store them into parser
            
            
            var parsing_object = Parser.init()
            parsing_object.name_state_table = name_state_table
            visitor_class.visitStates(start_state: name_state_table[["states", "state"]]!, parser: &parsing_object, function_name_to_function: function_name_to_function)
            //var json_data = data.data(using: .utf8)!
            //print(json_data)
            //let jsonDecoder = JSONDecoder()
            //let person = try? jsonDecoder.decode(ContextState.self, from: json_data)
            //dump(person)

            //visitor_class.visitStates(start_state: name_state_table[["states", "state"]]!, parser: &parser)

            
                //print(new_context.callFunction(a: 1, b: 2))
                //hierarchial_state_machine = inita()
                //previous_state = "start"
                // find all level values

                //var x = od()
                //x.test()
                //x.setdefault(key: "histogram", value: Value(value: od()))
                //x.dict["x"] = od(["a", "b", "c"])
                // try this: https://stackoverflow.com/questions/35232922/how-do-you-find-a-maximum-value-in-a-swift-dictionary
                //level_number_max_state_name_string_count = findMaxLevelWordCount(list: hierarchial_state_machine.map({ [$0.value["level"] as! Int , $0.key.characters.count] }))


                                // go through tree and find the max state name size for each level
                // for all levels in the tree
                    // array[level]["states"].append(state_name)
                    // array[level]["difference"] = difference
                // when about the print the state name find the difference between it and the max size
                // for all in
                    // dict[level] = {state_name : difference}
                // add the difference to the printout in the form of spaces
                // dict[level][previous_state]

                /*
                sync rules
                    assume each task and its history from last sync is visible for algorithm
                    make state machine

                    keep last change
                    exceptions
                        check mark vs no check mark(anything that undoes the previos thing)
                            in this case the non destructive changes win
                        edit notes
                            are saved and all fragments are concatenated together with a delimiter
                    // if all items have the sync status
                        // return to state that was send to sync
                */
                return true
        }

        func applicationWillResignActive(_ application: UIApplication) {
                // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
                // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        }

        func applicationDidEnterBackground(_ application: UIApplication) {
                // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
                // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }

        func applicationWillEnterForeground(_ application: UIApplication) {
                // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        }

        func applicationDidBecomeActive(_ application: UIApplication) {
                // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        }

        func applicationWillTerminate(_ application: UIApplication) {
                // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }




}
