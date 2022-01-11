--[[::

Copyright (C) 2022, Luc Rodriguez (Aliases : Shambi, StyledDev).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--::]]

--// Type Definitions.
type Array<Type> = {[number] : Type};
type Dictionary<Type> = {[string] : Type};

type Class_Constructor = (... any?) -> Dictionary<any?>;
type Class_Method = (Dictionary<Class_Constructor | (... any?) -> ... any?>, any?, ... any?) -> ... any?;
type Class = Dictionary<Class_Constructor | Class_Method | any?>;

type Parameters = Dictionary<any?>?;

--// Variable Definitions.
local Classes : Dictionary<any?> = {};

--// Functions.
local function Clone(Dictionary : Dictionary<any?>) : Dictionary<any>?
    local Cloned : Dictionary<any?> = {};

    for Index : string | number, Value : any? in pairs(Dictionary) do
        if (type(Index) == "string") then
            Cloned[Index] = type(Value) == "table" and Clone(Value) or Value;
        end;
    end;

    return (Cloned);
end;

local function Unload(Reference : Dictionary<any?>, Target : Dictionary) : Dictionary<any?>
    for Index : string | number, Value : any? in pairs(Reference) do
        if (type(Index) == "string") and (Target[Index] ~= nil) then            
            if (type(Value) == "table") and (type(Target[Index]) == "table") then

                Unload(Value, Target[Index]);
            else
                Target[Index] = Value;
            end;
        end;
    end;
end;

--// Class Constructor.
return (function(
    Name : string, 
    Structure : Dictionary<any?>, 
    Methods : Dictionary<Class_Method>?, 
    Initalizer : ((... any?) -> ... any?)?
) : Class

    local Class : Class = {};

    Class.__index = {
        ["Name"] = Name
    };

    function Class.new(Parameters : Parameters) : Class
        local self = setmetatable(Clone(Structure), {["__index"] = Class});

        if (type(Parameters) == "table") then
            Unload(Parameters, self);

        elseif (Parameters) then
            error("Expected \"table\" when provided argument #1.");
        end;

        if (type(Initalizer) == "function") then
            Initalizer(self, Classes, Parameters);

        elseif (Initalizer) then
            error("Expected \"function\" when provided argument #4.")
        end;

        return (self);
    end;

    if (type(Methods) == "table") then
        for Index : string | number, Value : Class_Method? in pairs(Methods) do
            if (type(Index) == "string") and (type(Value) == "function") then

                Class[Index] = function(self : Class, ... : any?) : ... any?
                    return Value(self, Classes, ...);
                end;
            end;
        end;
    end;

    Classes[Name] = Class;

    return (Class);
end);
