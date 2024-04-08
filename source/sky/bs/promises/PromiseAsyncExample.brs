'///////////////////////////////////////////////////////////////
'//
'//  $copyright: Copyright (C) 2013 zurquhart@googlemail.com
'//
'///////////////////////////////////////////////////////////////

function PromiseAsyncExample() as object
  this = {
    typeof: "PromiseAsyncExample"

    '----------------------------------------
    ' Properties
    '----------------------------------------

    _dataService: PromisesExampleDataService()
    _parsingService: PromisesExampleParsingService()

    '----------------------------------------
    ' Public API
    '----------------------------------------


    '----------------------------------------
    ' Constructors
    '----------------------------------------

    init: function() as void

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

    dataSuccess: function(data as object) as void
      print "SUCCESSFULLY FETCHED DATA"
      print "Movie:", data.movieName
      print "Rating:", data.rating
      print "isParsed:", data.isParsed
    end function

    dataError: function(data as object) as void
      print "ERROR IN GETTING DATA"
      print "errorMessage:", data.errorMessage
      print "errorCode:", data.errorCode
    end function

    parsingError: function(data as object) as void
      print "ERROR PARSING DATA"
      print "errorMessage:", data.errorMessage
      print "errorCode:", data.errorCode
    end function

    generalSuccess: function(data as object) as void
      print "SUCCESSFULLY FETCHED AND PARSED DATA"
      print "Movie:", data.movieName
      print "Rating:", data.rating
      print "isParsed:", data.isParsed
    end function

    generalError: function(data as object) as void
      print "ERROR IN CHAIN"
      print "errorMessage:", data.errorMessage
      print "errorCode:", data.errorCode
    end function

    parse: function(data as object) as object
      return m._parsingService.parse(data)
    end function


  }

  this.init()
  return this
end function



