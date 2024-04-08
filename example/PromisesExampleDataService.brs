'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 BSKYB
'//
'///////////////////////////////////////////////////////////////
function PromisesExampleDataService() as Object
  this = {
    typeof: "PromisesExampleDataService"

'----------------------------------------
' Properties
'----------------------------------------
    
    _promise : Invalid
    _willSucceed : true

'----------------------------------------
' Public API
'----------------------------------------

    getData: function(willSucceed = true as Boolean) as Object
    	m._willSucceed = willSucceed
    	m._timer.start()
      return m._promise
    end function


'----------------------------------------
' Private API
'----------------------------------------

    _onTimerHandler: function(eventObj as Object)
      m._timer.stop()
      m._timer.removeEventListener(m, "onTimer", "onTimerHandler")
      m._timer = Invalid
      if m._willSucceed = true
      	data = {movieName:"My Big Fat Gypsy Wedding", rating:15, isParsed:false}
      	m._promise.resolve(data)
      else
      	data = {errorMessage:"No Data Available", errorCode:101}
        m._promise.reject(data)
      end if

      m._willSucceed = true
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



