buster.spec.expose()

describe "LoudAccessors", ->

  before ->
    @la = new LoudAccessors()

  after ->
    delete @la

  describe "set", ->

    it "sets the value of the attribute", ->
      @la.set "foo", "bar"
      expect( @la._attributes.foo ).toEqual "bar"

    it "publishes change:<attribute> event", ->
      cbk = @spy()
      @la.on "change:foo", cbk
      @la.set "foo", 123
      expect( cbk ).toHaveBeenCalledOnce()

    it "passes to change:<attribute> event handlers the name and value of the attribute", ->
      cbk = @spy()
      @la.on "change:foo", cbk
      @la.set "foo", 123
      expect( cbk ).toHaveBeenCalledWith "change:foo", "foo", 123

    it "does not publish change:<attribute> event if silent option is true", ->
      cbk = @spy()
      @la.on "change:foo", cbk
      @la.set "foo", 123, silent: true
      refute.called cbk

  describe "get", ->

    it "returns the value of attribute", ->
      @la._attributes = {}
      @la._attributes.foo = "bar"
      expect( @la.get("foo") ).toEqual "bar"

    it "publishes read:<attribute> event", ->
      cbk = @spy()
      @la.on "read:foo", cbk
      @la.get "foo"
      expect( cbk ).toHaveBeenCalledOnce()

    it "passes to read:<attribute> event handlers the name and value of the attribute", ->
      cbk = @spy()
      @la._attributes =
        foo: 123
      @la.on "read:foo", cbk
      @la.get "foo"
      expect( cbk ).toHaveBeenCalledWith "read:foo", "foo", 123

    it "does not publish generic read event if silent option is true", ->
      cbk = @spy()
      @la.on "read", cbk
      @la.get "foo", silent: true
      refute.called cbk

    it "does not publish read:<attribute> event if silent option is true", ->
      cbk = @spy()
      @la.on "read:foo", cbk
      @la.get "foo", silent: true
      refute.called cbk

  describe "del", ->

    it "deletes the value of the attribute", ->
      @la.del "foo"
      expect( @la._attributes.foo ).toEqual undefined

    it "publishes delete:<attribute> event", ->
      cbk = @spy()
      @la.on "delete:foo", cbk
      @la.del "foo"
      expect( cbk ).toHaveBeenCalledOnce()

    it "passes to delete:<attribute> event handlers the name of the attribute", ->
      cbk = @spy()
      @la.on "delete:foo", cbk
      @la.del "foo"
      expect( cbk ).toHaveBeenCalledWith "delete:foo", "foo"

    it "does not publish delete:<attribute> event if silent option is true", ->
      cbk = @spy()
      @la.on "delete:foo", cbk
      @la.del "foo", silent: true
      refute.called cbk

  describe "class methods", ->

    describe "attrAccessor", ->

      before ->
        class @Foo extends LoudAccessors
          @attrAccessor "bar"

      after ->
        delete @Foo

      it "defines a properties with loud setters", ->
        spy = @spy()
        foo = new @Foo()

        if Object.defineProperty?
          @stub foo, "set", spy
          foo.bar = 123
          expect( spy ).toHaveBeenCalledWith "bar", 123
        else
          # Dummy assertion for engines not supporting Object.defineProperty
          console.log "Object.defineProperty is not available in this environment"
          expect( true ).toBeTrue()

      it "defines properties with loud getters", ->
        spy = @spy()
        foo = new @Foo()

        if Object.defineProperty?
          @stub foo, "get", spy
          bar = foo.bar
          expect( spy ).toHaveBeenCalledWith "bar"
        else
          # Dummy assertion for engines not supporting Object.defineProperty
          console.log "Object.defineProperty is not available in this environment"
          expect( true ).toBeTrue()
