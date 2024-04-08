'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 zurquhart@googlemail.com
'//
'///////////////////////////////////////////////////////////////
function Deferred(promiseInstance as object, destination as object, errorDestination as object, successHandler as object, errorHandler as object) as object
  this = {
    typeof: "Deferred"

    '----------------------------------------
    ' Properties
    '----------------------------------------

    _promiseInstance: promiseInstance
    _destination: destination
    _errorDestination: errorDestination
    _successHandler: successHandler
    _errorHandler: errorHandler

    '----------------------------------------
    ' Public API
    '----------------------------------------

    triggerSuccess: function(payload = invalid as object) as void
      m._bind(m._successHandler, m._destination, payload)
    end function

    triggerReject: function(payload = invalid as object) as void
      if m._errorHandler <> invalid
        m._bind(m._errorHandler, m._errorDestination, payload)
      else
        if payload = invalid
          m._promiseInstance.reject()
        else
          m._promiseInstance.reject(payload)
        end if
      end if
    end function

    _bind: function(handler as object, destination as object, payload = invalid as object) as void
      response = m._executeHandler(handler, destination, payload)
      if response <> invalid
        response.onSuccess(m._promiseInstance, "resolve", payload)
        response.onFail(m._promiseInstance, "reject", payload)
      end if
    end function

    _executeHandler: function(handler as string, destination as object, payload = invalid as object) as object
      if payload <> invalid
        return destination[handler](payload)
      end if
      return destination[handler]()
    end function
  }

  return this
end function
