'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 BSKYB
'//
'///////////////////////////////////////////////////////////////
function PromisesExampleParsingService() as Object
  this = {
    typeof: "PromisesExampleParsingService"

'----------------------------------------
' Properties
'----------------------------------------
    
    willSucceed : true
    
    _promise : Invalid
    _data : Invalid

'----------------------------------------
' Public API
'----------------------------------------

    parse: function(data as Object, willSucceed = true as Boolean) as Object
      m._data = data
    	m._willSucceed = willSucceed
    	m._timer.start()
      return m._promise
    end function

    parsingError: function(data as Object) as Void
      Print "[PromisesExampleParsingService] ERROR PARSING DATA"
      Print "errorMessage:", data.errorMessage
      Print "errorCode:", data.errorCode
    end function

'----------------------------------------
' Private API
'----------------------------------------

    _onTimerHandler: function(eventObj as Object)
      m._timer.stop()
      m._timer.removeEventListener(m, "onTimer", "onTimerHandler")
      m._timer = Invalid
      if m.willSucceed = true
      	m._data.isParsed = true
      	m._promise.resolve(m._data)
      else
      	data = {errorMessage:"Parsing Error", errorCode:102}
      	m._promise.reject(data)
      end if

      m.willSucceed = true
    end function
    
'----------------------------------------
' Constructors
'----------------------------------------
	
		init: function() as Void
    	m._promise = Promise()
    	m._timer = Timer("dataTimer", 10)
    	m._timer.addEventListener(m, "onTimer", "_onTimerHandler")
    end function


  }

  this.init()
  return this
end function



