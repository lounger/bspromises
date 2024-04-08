'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 BSKYB
'//
'///////////////////////////////////////////////////////////////
function Promise() as Object
  this = {
    typeof: "Promise"
'----------------------------------------
' Properties
'----------------------------------------
    
    _successPayload  : Invalid
    _errorPayload    : Invalid
    _disposed        : false
    _wasSuccess      : false
    _wasError        : false
    _successHandlers : []
    _errorHandlers   : []

'----------------------------------------
' Public API
'----------------------------------------

    onSuccess: function(destination as Object, handler as String,  args = Invalid as Object) as Object
      if m._disposed = true
        if m._wasSuccess = true
          promiseHandlerInstance = PromiseHandler(destination, handler, args)
          promiseHandlerInstance.dispatch(m._successPayload)
        end if 
      else 
        promiseHandlerInstance = PromiseHandler(destination, handler, args)
        m._successHandlers.push(promiseHandlerInstance)
      end if
      return m
    end function

    onFail: function(destination as Object, handler as String, args = Invalid as Object) as Object
      if m._disposed = true
        if m._wasError = true
          promiseHandlerInstance = PromiseHandler(destination, handler, args)
          promiseHandlerInstance.dispatch(m._errorPayload)
        end if
      else
        promiseHandlerInstance = PromiseHandler(destination, handler, args)
        m._errorHandlers.push(promiseHandlerInstance)
      end if
      return m
    end function

    resolve: function(payload = Invalid as Object) as Object
      if m._disposed = true then return m

      m._successPayload = payload
      m._wasSuccess = true
      m.dispatch(m._successHandlers, payload)
      m.dispose()
      return m
    end function

    reject: function(payload = Invalid as Object) as Object
      if m._disposed = true then return m
      
      m._errorPayload = payload
      m._wasError = true
      m.dispatch(m._errorHandlers, payload)
      m.dispose()
      return m
    end function

    then: function(destination as Object, successHandler as Object, errorHandler = Invalid as Object, errorDestination = Invalid as Object) as Object
      promiseInstance = Promise()
      if errorDestination = Invalid
        errorDestination = destination
      end if 
      deferredInstance = Deferred(promiseInstance, destination, errorDestination, successHandler, errorHandler)
      m.onSuccess(deferredInstance, "triggerSuccess")
      m.onFail(deferredInstance, "triggerReject")
      return promiseInstance
    end function

    dispose: function() as Void
      m._disposed = true
      m._successHandlers = Invalid
      m._errorHandlers = Invalid
    end function

    dispatch: function(handlers as Object, payload = Invalid as Object) as Void
      for each handler in handlers
        if payload = Invalid
          handler.dispatch()
        else
          handler.dispatch(payload)
        end if
      end for
    end function
    
  }
  return this
end function
