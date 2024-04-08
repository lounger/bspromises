'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 BSKYB
'//
'///////////////////////////////////////////////////////////////
function PromiseHandler(destination as Object, handler as String, args = Invalid as Object) as Object
  this = {
    typeof: "PromiseHandler"

'----------------------------------------
' Properties
'----------------------------------------

    _destination : destination
  	_handler : handler
    _args    : args

'----------------------------------------
' Public API
'----------------------------------------

    dispatch: function(payload = Invalid as Object) as Void
      if m._args <> Invalid
        bundledPayload = {}
        bundledPayload.append(m._args)
        if payload <> Invalid
          bundledPayload.append(payload)
        end if
        payload = bundledPayload
      end if

      if payload <> Invalid
        m._destination[m._handler](payload)
      else
        m._destination[m._handler]()
      end if 
    end function

    init: function() as Object
    end function


  }

  this.init()
  return this
end function