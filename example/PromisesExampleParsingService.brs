'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2015 zurquhart@googlemail.com
'//
'///////////////////////////////////////////////////////////////
function PromisesExampleParsingService() as object
  this = {
    typeof: "PromisesExampleParsingService"

    '----------------------------------------
    ' Properties
    '----------------------------------------

    willSucceed: true

    _promise: invalid
    _data: invalid

    '----------------------------------------
    ' Public API
    '----------------------------------------

    parse: function(data as object, willSucceed = true as boolean) as object
      m._data = data
      m._willSucceed = willSucceed
      m._timer.start()
      return m._promise
    end function

    parsingError: function(data as object) as void
      print "[PromisesExampleParsingService] ERROR PARSING DATA"
      print "errorMessage:", data.errorMessage
      print "errorCode:", data.errorCode
    end function

    '----------------------------------------
    ' Private API
    '----------------------------------------

    _onTimerHandler: function(eventObj as object)
      m._timer.stop()
      m._timer.removeEventListener(m, "onTimer", "onTimerHandler")
      m._timer = invalid
      if m.willSucceed = true
        m._data.isParsed = true
        m._promise.resolve(m._data)
      else
        data = { errorMessage: "Parsing Error", errorCode: 102 }
        m._promise.reject(data)
      end if

      m.willSucceed = true
    end function

    '----------------------------------------
    ' Constructors
    '----------------------------------------

    init: function() as void
      m._promise = Promise()
      m._timer = Timer("dataTimer", 10)
      m._timer.addEventListener(m, "onTimer", "_onTimerHandler")
    end function


  }

  this.init()
  return this
end function



