'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2013 BSKYB
'//
'///////////////////////////////////////////////////////////////

function PromiseAsyncExample() as Object
  this = {
    typeof: "PromiseAsyncExample"

'----------------------------------------
' Properties
'----------------------------------------
    
    _dataService : PromisesExampleDataService()
    _parsingService : PromisesExampleParsingService()

'----------------------------------------
' Public API
'----------------------------------------

    
'----------------------------------------
' Constructors
'----------------------------------------

    init: function() as Void

      'GET DATA'
      m._dataService.getData().onFail(m, "dataError").onSuccess(m, "dataSuccess")

      'GET DATA (FAILS)'
      'm._dataService.getData(false).onFail(m, "dataError").onSuccess(m, "printResults")

      'SUCCESSFULL CHAINED CALL'
      'm._dataService.getData().then(m._parsingService, "parse").then(m, "generalSuccess", "generalError")

      'FAILED CHAINED CALL'
      'm._dataService.getData(false).then(m._parsingService, "parse").then(m, "generalSuccess", "generalError")

      'FAILED CHAINED CALL (PARSING FAILS)'    
      'm._parsingService.willSucceed = false
      'm._dataService.getData().then(m._parsingService, "parse").then(m, "generalSuccess", "generalError")

      'CATCH PARSING ERROR'
      'm._parsingService.willSucceed = false
      'm._dataService.getData().then(m._parsingService, "parse").onFail(m, "parsingError").onSuccess(m, "generalSuccess")
   
      'CATCH ERROR ON DIFFERENT OBJECT'
      'm._dataService.getData(false).then(m._parsingService, "parse", "parsingError").then(m, "generalSuccess", "generalError")

      'USE DIFFERENT CONTEXTS FOR ERROR AND SUCCESS'
      'm._dataService.getData().then(m, "parse", "parsingError", m._parsingService).then(m, "generalSuccess", "generalError")
    end function

    dataSuccess: function(data as Object) as Void
      Print "SUCCESSFULLY FETCHED DATA"
      Print "Movie:", data.movieName
      Print "Rating:", data.rating
      Print "isParsed:", data.isParsed
    end function

    dataError: function(data as Object) as Void
      Print "ERROR IN GETTING DATA"
      Print "errorMessage:", data.errorMessage
      Print "errorCode:", data.errorCode
    end function

    parsingError: function(data as Object) as Void
      Print "ERROR PARSING DATA"
      Print "errorMessage:", data.errorMessage
      Print "errorCode:", data.errorCode
    end function

    generalSuccess: function(data as Object) as Void
      Print "SUCCESSFULLY FETCHED AND PARSED DATA"
      Print "Movie:", data.movieName
      Print "Rating:", data.rating
      Print "isParsed:", data.isParsed
    end function

    generalError: function(data as Object) as Void
      Print "ERROR IN CHAIN"
      Print "errorMessage:", data.errorMessage
      Print "errorCode:", data.errorCode
    end function

    parse: function(data as Object) as Object
      return m._parsingService.parse(data)
    end function


  }

  this.init()
  return this
end function



