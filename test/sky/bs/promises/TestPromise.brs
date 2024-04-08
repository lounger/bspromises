function createHelloWorldPromiseForTest() as Object
  SUT = Promise()
  return SUT
end function

function MockDestination() as Object
  return {
    actionOneCalled: false
    actionTwoCalled: false
    actionThreeCalled: false
    actionFourCalled: false
    actionThreePayload: Invalid
    actionFourPayload: Invalid

    thenableActionXPayload: Invalid
    thenableActionYPayload: Invalid

    promiseInstance: Promise()
    promiseInstance2: Promise()

    actionOne: function() as Void
      m.actionOneCalled = true
    end function

    actionTwo: function() as Void
      m.actionTwoCalled = true
    end function

    actionThree: function(payload as Object) as Void
      m.actionThreeCalled = true
      m.actionThreePayload = payload
    end function

    actionFour: function(payload as Object) as Void
      m.actionFourCalled = true
      m.actionFourPayload = payload
    end function

    thenableActionX: function(payload as Object) as Object
      m.thenableActionXPayload = payload
      return m.promiseInstance
    end function

    thenableActionY: function(payload as Object) as Object
      m.thenableActionYPayload = payload
      return m.promiseInstance2
    end function    

    actionPrerequisite: function() as Object
      return m.promiseInstance
    end function

    actionSecondPrerequisite: function() as Object
      return m.promiseInstance2
    end function
  }
end function

sub testBundlingOfPayload(t as Object)
    dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "thenableActionX").then(dest, "thenableActionY")
    
    SUT.resolve({firstId:"first"})
    dest.promiseInstance.resolve({secondId:"second"})

    t.assertEqual("first", dest.thenableActionXPayload.firstId)
    
    t.assertEqual("first", dest.thenableActionYPayload.firstId)
    t.assertEqual("second", dest.thenableActionYPayload.secondId)
end sub

sub testBundlingOfPayloadLastMethodOverwritesFirst(t as Object)
    dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "thenableActionX").then(dest, "thenableActionY")
    
    SUT.resolve({firstId:"1"})
    dest.promiseInstance.resolve({firstId:"2",secondId:"2"})
    t.assertEqual("1", dest.thenableActionXPayload.firstId)
    
    t.assertEqual("2", dest.thenableActionYPayload.firstId)
    t.assertEqual("2", dest.thenableActionYPayload.secondId)
end sub

sub testPassingCustomParameters(t as Object)
    dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "thenableActionX").then(dest, "thenableActionY").onSuccess(dest, "actionThree", {youMayNeedThis:"towel"})
    
    SUT.resolve({})
    dest.promiseInstance.resolve({firstThing:"toothbrush",secondThing:"shampoo"})
    dest.promiseInstance2.resolve({})
    t.assertEqual("toothbrush", dest.actionThreePayload.firstThing)
    t.assertEqual("shampoo", dest.actionThreePayload.secondThing)
    t.assertEqual("towel", dest.actionThreePayload.youMayNeedThis)
end sub

sub testSequence(t as Object)
  dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "actionPrerequisite", "action2").then(dest, "actionOne")
    SUT.resolve()
    dest.promiseInstance.resolve()

    t.assertTrue(dest.actionOneCalled)
end sub

sub testSequenceFailNotCalled(t as Object)
  dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "actionPrerequisite", "actionTwo").then(dest, "actionOne")
    SUT.resolve()
    dest.promiseInstance.resolve()

    t.assertFalse(dest.actionTwoCalled)
end sub

sub testFailedSequenceFailCalled(t as Object)
  dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "actionPrerequisite", "actionTwo").then(dest, "actionOne")
    SUT.reject()
    dest.promiseInstance.resolve()

    t.assertTrue(dest.actionTwoCalled)
end sub

sub testFailedSequenceSecondFailCalled(t as Object)
  dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "actionPrerequisite", "actionTwo").then(dest, "actionOne", "actionFour")
    SUT.resolve()
    dest.promiseInstance.reject({payload: "testKPayload"})

    t.assertTrue(dest.actionFourCalled)
end sub

sub testLongerSequence(t as Object)
  dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "actionPrerequisite", "actionTwo").then(dest, "actionSecondPrerequisite", "actionFour").then(dest, "actionOne")
    SUT.resolve()
    dest.promiseInstance.resolve()
    dest.promiseInstance2.resolve()

    t.assertTrue(dest.actionOneCalled)
end sub

sub testLongerSequenceFailWithPayload(t as Object)
  dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "actionPrerequisite", "actionOne").then(dest, "actionSecondPrerequisite", "actionTwo").then(dest, "actionThree", "actionFour")
    SUT.resolve()
    dest.promiseInstance.resolve()
    dest.promiseInstance2.reject({payload:"PAYLOAD|testLongerSequenceFailWithPayload"})

    t.assertEqual(dest.actionFourPayload.payload, "PAYLOAD|testLongerSequenceFailWithPayload")
end sub

sub testLongerSequenceFailEarlyWithPayload(t as Object)
  dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "actionPrerequisite", "actionOne").then(dest, "actionSecondPrerequisite", "actionFour").then(dest, "actionTwo", "actionFour")
    SUT.resolve()
    dest.promiseInstance.resolve()
    dest.promiseInstance2.reject({payload:"PAYLOAD|testLongerSequenceFailEarlyWithPayload"})

    t.assertEqual(dest.actionFourPayload.payload, "PAYLOAD|testLongerSequenceFailEarlyWithPayload")
end sub

sub testLongerSequenceSuccessWithPayload(t as Object)
  dest = MockDestination()
    SUT = createHelloWorldPromiseForTest()
    SUT.then(dest, "actionPrerequisite", "actionOne").then(dest, "actionSecondPrerequisite", "actionTwo").then(dest, "actionThree", "actionFour")
    SUT.resolve()
    dest.promiseInstance.resolve()
    dest.promiseInstance2.resolve({payload:"PAYLOAD|testLongerSequenceSuccessWithPayload"})

    t.assertEqual(dest.actionThreePayload.payload, "PAYLOAD|testLongerSequenceSuccessWithPayload")
end sub

sub testResolveAndThenCallSuccess(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.then(dest, "actionOne")
  SUT.resolve()

  t.assertTrue(dest.actionOneCalled)
end sub

sub testRejectAndThenCallsFail(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.then(dest, "actionOne", "actionTwo")
  SUT.reject()

  t.assertTrue(dest.actionTwoCalled)
end sub

sub testResolveWithPayloadAndThenCallSuccess(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.then(dest, "actionThree")
  SUT.resolve({payload: "testZPayload"})

  t.assertEqual(dest.actionThreePayload.payload, "testZPayload")
end sub

sub testRejectWithPayloadAndThenCallsFail(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.then(dest, "actionThree", "actionFour")
  SUT.reject({payload: "testSuperPayload"})

  t.assertEqual(dest.actionFourPayload.payload, "testSuperPayload")
end sub

sub testResolveAndThenDoesNotCallFail(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.then(dest, "actionThree", "actionFour")
  SUT.resolve({payload: "testSuperPayload"})

  t.assertFalse(dest.actionFourCalled)
end sub

sub testRejectAndThenDoesNotCallSuccess(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.then(dest, "actionThree", "actionFour")
  SUT.reject({payload: "testSuperPayload"})

  t.assertEqual(dest.actionFourPayload.payload, "testSuperPayload")
  t.assertFalse(dest.actionThreeCalled)
end sub

sub testSuccessCalledWhenResolved(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionOne")

  SUT.resolve()

  t.assertTrue(dest.actionOneCalled)
end sub

sub testErrorCalledWhenRejected(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onFail(dest, "actionTwo")

  SUT.reject()

  t.assertTrue(dest.actionTwoCalled)
end sub

sub testSuccessNotCalledWhenRejected(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionOne")
  SUT.onFail(dest, "actionTwo")

  SUT.reject()

  t.assertFalse(dest.actionOneCalled)
end sub

sub testFailNotCalledWhenResolved(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionOne")
  SUT.onFail(dest, "actionTwo")

  SUT.resolve()

  t.assertFalse(dest.actionTwoCalled)
end sub

sub testSuccessCalledWhenResolvedWithPayload(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionThree")
  SUT.onFail(dest, "actionFour")

  SUT.resolve({payload: "testPayload"})

  t.assertTrue(dest.actionThreeCalled)
end sub

sub testFailCalledWhenRejectedWithPayload(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionThree")
  SUT.onFail(dest, "actionFour")

  SUT.reject({payload: "testPayload"})

  t.assertTrue(dest.actionFourCalled)
end sub

sub testPayloadPassedWhenResolvedWithPayload(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionThree")
  SUT.onFail(dest, "actionFour")

  SUT.resolve({payload: "testPayload"})

  t.assertEqual(dest.actionThreePayload.payload, "testPayload")
end sub

sub testPayloadPassedWhenRejectedWithPayload(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionThree")
  SUT.onFail(dest, "actionFour")

  SUT.reject({payload: "test4Payload"})

  t.assertEqual(dest.actionFourPayload.payload, "test4Payload")
end sub

sub testFailPayloadNotPassedWhenResolvedWithPayload(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionThree")
  SUT.onFail(dest, "actionFour")
  
  SUT.resolve({payload: "testYPayload"})

  t.assertInvalid(dest.actionFourPayload)
end sub

sub testSuccessPayloadNotPassedWhenRejectedWithPayload(t as Object)
  SUT = createHelloWorldPromiseForTest()
  dest = MockDestination()
  SUT.onSuccess(dest, "actionThree")
  SUT.onFail(dest, "actionFour")
  
  SUT.reject({payload: "testXPayload"})

  t.assertInvalid(dest.actionThreePayload)
end sub



