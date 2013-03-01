factory = ( EventSpitter ) ->

  class LoudAccessors

    # Include EventSpitter
    @::[ prop ] = value for prop, value of EventSpitter::

    set: ( name, value, opts ) ->
      @_attributes ?= {}
      @_attributes[ name ] = value

      unless opts? and opts.silent
        @emit "change:#{name}", name, value

    get: ( name, opts ) ->
      @_attributes ?= {}
      value = @_attributes[ name ]

      unless opts? and opts.silent
        @emit "read:#{name}", name, value

      return value

    # Class methods

    @attrAccessor: ( args... ) ->
      if Object.defineProperty?
        for name in args
          do ( name ) =>
            Object.defineProperty @::, name,
              get: -> @get name
              set: ( value ) -> @set name, value

# Export as
# CommonJS module
if exports?
  exp = factory require "eventspitter"
  if module? and module.exports?
    exports = module.exports = exp
  exports.LoudAccessors = exp
# AMD module
else if typeof define is "function" and define.amd
  define ["eventspitter"], ( EventSpitter ) ->
    factory EventSpitter
# Browser global
@LoudAccessors = factory @EventSpitter
