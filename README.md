# LoudAccessors - JavaScript event emitting attribute accessors

`LoudAccessors` is a super tiny JavaScript constructor (CoffeeScript class)
implementing event emitting getter and setter. It is intended to be used as a
micromodule or as a base class to build upon.

It mixes in the [eventspitter](https://github.com/lucaong/eventspitter) event micromodule and provides two additional instance methods:

  * `get( attr_name )` gets the value of an attribute and emits the `read:attr_name` event (where attr_name is the name of the attribute that was read)
  * `set( attr_name, attr_value )` sets the value of an attribute, and triggers the `change:attr_name` event

Additionally, it provides a class method:

  * `attrAccessor( attr_name, [attr2_name], [...] )` on environment supporting `Object.defineProperty` it defines getter and setter for the attribute(s), so that accessing it directly triggers the events.

## Example (CoffeeScript)

```coffeescript
class Person extends LoudAccessors
  constructor: ( name ) ->
    @set "name", name

john = new Person "John"

john.get "name"                      # => returns "John" and triggers "read:name"
john.set "name", "Johnny"            # => sets name to "Johnny" and triggers "change:name"
john.set "name", "Joe", silent: true # => sets name to "Joe" without triggering events

# Or, where Object.defineProperty is supported:

class Person extends LoudAccessors
  @attrAccessor "name"

john.name            # => returns "John" and triggers "read:name"
john.name = "Johnny" # => sets name to "Johnny" and triggers "change:name"
```
