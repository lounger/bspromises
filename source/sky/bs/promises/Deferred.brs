'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 BSKYB
'//
'///////////////////////////////////////////////////////////////
function Deferred(promiseInstance as Object, destination as Object, errorDestination as Object, successHandler as Object, errorHandler as Object) as Object
  this = {
    typeof: "Deferred"

'----------------------------------------
' Properties
'----------------------------------------
    
    _promiseInstance  : promiseInstance
    _destination      : destination
    _errorDestination : errorDestination
    _successHandler   : successHandler
    _errorHandler     : errorHandler

'----------------------------------------
' Public API
'----------------------------------------

    triggerSuccess: function(payload = Invalid as Object) as Void
    	m._bind(m._successHandler, m._destination, payload)
    end function

    triggerReject: function(payload = Invalid as Object) as Void
      if m._errorHandler <> Invalid
        m._bind(m._errorHandler, m._errorDestination, payload)
      else
        if payload = Invalid 
          m._promiseInstance.reject()
        else
          m._promiseInstance.reject(payload)
        end if
      end if
    end function

    _bind: function(handler as Object, destination as Object, payload = Invalid as Object) as void
      response = m._executeHandler(handler, destination, payload)
      if response <> Invalid
        response.onSuccess(m._promiseInstance, "resolve", payload)
        response.onFail(m._promiseInstance, "reject", payload)
      end if 
    end function

    _executeHandler: function(handler as String, destination as Object, payload = Invalid as Object) as Object
      if payload <> Invalid
    		return destination[handler](payload)
    	end if
      return destination[handler]()
    end function
  }

  return this
end function
