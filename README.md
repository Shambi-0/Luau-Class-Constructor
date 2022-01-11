# Class Constructer

A Open-Source Module which makes it easier to create object-oriented programs.

## Installation

In ROBLOX Studio, you may load it in as a module script named `ClassConstructer`, as the following :

```lua
local ClassConstructer : (

  Name : string, 
  Structure : {[string] : any?},
  Methods : {[string] : (... any?) -> ... any?},
  Initializer : ((... any?) -> ... any?)?

) -> {[string] : any?} = require(script.ClassConstructer);
```
or if you are using the Luau Binary Files :
```lua
local ClassConstructer : (

  Name : string,
  Structure : {[string] : any?},
  Methods : {[string] : (... any?) -> ... any?},
  Initalizer : ((... any?) -> ... any?)?

) -> {[string] : any?} = require("./ClassConstructer");
```
## Usage

Creating a class :
```lua
local ExampleClass : {[string] : any?} = ClassConstructer(
  -- Name of the class
  "ExampleClass",

  -- Structure of the class
  {
    ["ExampleProperty"] = {
      ["ExampleSubProperty"] = "SubValue"
    }
  },

  -- Methods of the class
  {
    ["ExampleMethod"] = function(self, Classes, ...)
      return (self.ExampleProperty.ExampleSubProperty);
    end;
  },

  -- [OPTIONAL] Class initalizer
  function(self, Classes, Parameters)
    print("A new \"ExampleClass\" was created, yay!");

    return (nil);
  end
);
```
Using a class :
```lua
local Example1 : {[string] : any?} = ExampleClass.new(); -- "A new "ExampleClass" was created, yay!"
local Example2 : {[string] : any?} = ExampleClass.new({
  ["ExampleProperty"] = {
    ["ExampleSubProperty"] = "DifferentSubValue"
  }
}); -- "A new "ExampleClass" was created, yay!"

print(Example1:ExampleMethod()); -- "SubValue"
print(Example2:ExampleMethod()); -- "DifferentSubValue"
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
