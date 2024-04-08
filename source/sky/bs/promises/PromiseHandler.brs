'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 zurquhart@googlemail.com
'//
'///////////////////////////////////////////////////////////////
function PromiseHandler(destination as object, handler as string, args = invalid as object) as object
  this = {
    typeof: "PromiseHandler"

    '----------------------------------------
    ' Properties
    '----------------------------------------

    _destination: destination
    _handler: handler
    _args: args

    '----------------------------------------
    ' Public API
    '----------------------------------------

    dispatch: function(payload = invalid as object) as void
      if m._args <> invalid
        bundledPayload = {}
        bundledPayload.append(m._args)
        if payload <> invalid
          bundledPayload.append(payload)
        end if
        payload = bundledPayload
      end if

      if payload <> invalid
        m._destination[m._handler](payload)
      else
        m._destination[m._handler]()
      end if
    end function

    init: function() as object
    end function


  }

  this.init()
  return this
end function