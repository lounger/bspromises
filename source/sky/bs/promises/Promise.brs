'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 zurquhart@googlemail.com
'//
'///////////////////////////////////////////////////////////////
function Promise() as object
  this = {
    typeof: "Promise"
    '----------------------------------------
    ' Properties
    '----------------------------------------

    _successPayload: invalid
    _errorPayload: invalid
    _disposed: false
    _wasSuccess: false
    _wasError: false
    _successHandlers: []
    _errorHandlers: []

    '----------------------------------------
    ' Public API
    '----------------------------------------

    onSuccess: function(destination as object, handler as string, args = invalid as object) as object
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

    onFail: function(destination as object, handler as string, args = invalid as object) as object
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

    resolve: function(payload = invalid as object) as object
      if m._disposed = true then return m

      m._successPayload = payload
      m._wasSuccess = true
      m.dispatch(m._successHandlers, payload)
      m.dispose()
      return m
    end function

    reject: function(payload = invalid as object) as object
      if m._disposed = true then return m

      m._errorPayload = payload
      m._wasError = true
      m.dispatch(m._errorHandlers, payload)
      m.dispose()
      return m
    end function

    then: function(destination as object, successHandler as object, errorHandler = invalid as object, errorDestination = invalid as object) as object
      promiseInstance = Promise()
      if errorDestination = invalid
        errorDestination = destination
      end if
      deferredInstance = Deferred(promiseInstance, destination, errorDestination, successHandler, errorHandler)
      m.onSuccess(deferredInstance, "triggerSuccess")
      m.onFail(deferredInstance, "triggerReject")
      return promiseInstance
    end function

    dispose: function() as void
      m._disposed = true
      m._successHandlers = invalid
      m._errorHandlers = invalid
    end function

    dispatch: function(handlers as object, payload = invalid as object) as void
      for each handler in handlers
        if payload = invalid
          handler.dispatch()
        else
          handler.dispatch(payload)
        end if
      end for
    end function

  }
  return this
end function
