// Copyright 2011 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// a1 is always the RECEIVED value
// a2 is always the EXPECTED value
// GHAssertNoErr(a1, description, ...)
// GHAssertErr(a1, a2, description, ...)
// GHAssertNotNULL(a1, description, ...)
// GHAssertNULL(a1, description, ...)
// GHAssertNotEquals(a1, a2, description, ...)
// GHAssertNotEqualObjects(a1, a2, desc, ...)
// GHAssertOperation(a1, a2, op, description, ...)
// GHAssertGreaterThan(a1, a2, description, ...)
// GHAssertGreaterThanOrEqual(a1, a2, description, ...)
// GHAssertLessThan(a1, a2, description, ...)
// GHAssertLessThanOrEqual(a1, a2, description, ...)
// GHAssertEqualStrings(a1, a2, description, ...)
// GHAssertNotEqualStrings(a1, a2, description, ...)
// GHAssertEqualCStrings(a1, a2, description, ...)
// GHAssertNotEqualCStrings(a1, a2, description, ...)
// GHAssertEqualObjects(a1, a2, description, ...)
// GHAssertEquals(a1, a2, description, ...)
// GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))
// GHAssertEqualsWithAccuracy(a1, a2, accuracy, description, ...)
// GHFail(description, ...)
// GHAssertNil(a1, description, ...)
// GHAssertNotNil(a1, description, ...)
// GHAssertTrue(expr, description, ...)
// GHAssertTrueNoThrow(expr, description, ...)
// GHAssertFalse(expr, description, ...)
// GHAssertFalseNoThrow(expr, description, ...)
// GHAssertThrows(expr, description, ...)
// GHAssertThrowsSpecific(expr, specificException, description, ...)
// GHAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
// GHAssertNoThrow(expr, description, ...)
// GHAssertNoThrowSpecific(expr, specificException, description, ...)
// GHAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)

#import "LjsTestCase.h"
#import "LjsGestalt.h"

@interface LjsGestaltTests : LjsTestCase 

@property (nonatomic, strong) LjsGestalt *gestalt;
@end


@implementation LjsGestaltTests
@synthesize gestalt;

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
  [super setUpClass];
  // Run at start of all tests in the class
  self.gestalt = [[LjsGestalt alloc] init];
  GHTestLog(@"gestalt = %@", self.gestalt);
  GHAssertNotNil(self.gestalt, nil);
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  self.gestalt = nil;
  [super tearDownClass];
}

- (void) setUp {
  [super setUp];
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
  [super tearDown];
}  

- (void) test_isDebugBuild {
#if DEBUG_BUILD
  GHAssertTrue([self.gestalt isDebugBuild], nil);
#else
  GHAssertFalse([self.gestalt isDebugBuild], nil);
#endif
}

- (void) test_isAdHocBuild {
#if ADHOC_BUILD
  GHAssertTrue([self.gestalt isAdHocBuild], nil);
#else
  GHAssertFalse([self.gestalt isAdHocBuild], nil);
#endif
}

- (void) test_isAppStoreBuild {
#if APPSTORE_BUILD
  GHAssertTrue([self.gestalt isAppStoreBuild], nil);
#else
  GHAssertFalse([self.gestalt isAppStoreBuild], nil);
#endif
}

- (void) test_buildConfiguration {
  NSString *actual, *act;
  NSString *expected, *exp;
  
#if DEBUG_BUILD
  expected = @"debug";
  exp = @"de";
  actual = [self.gestalt buildConfiguration:NO];
  act = [self.gestalt buildConfiguration:YES];
  GHAssertEqualStrings(actual, expected, nil);
  GHAssertEqualStrings(act, exp, nil);
#elif ADHOC_BUILD
  expected = @"adhoc";
  exp = @"ah";
  actual = [self.gestalt buildConfiguration:NO];
  act = [self.gestalt buildConfiguration:YES];
  GHAssertEqualStrings(actual, expected, nil);
  GHAssertEqualStrings(act, exp, nil);
#elif APPSTORE_BUILD
  expected = @"appstore";
  exp = @"as";
  actual = [self.gestalt buildConfiguration:NO];
  act = [self.gestalt buildConfiguration:YES];
  GHAssertEqualStrings(actual, expected, nil);
  GHAssertEqualStrings(act, exp, nil);
#else
  expected = nil;
  exp = nil;
  actual = [self.gestalt buildConfiguration:NO];
  GHAssertNil(actual, nil);
  act = [self.gestalt buildConfiguration:YES];
  GHAssertNil(act, nil);
#endif

}

- (void) test_currentLanguageCodeNotNil {
  NSString *actual = [self.gestalt currentLanguageCode];
  GHAssertNotNil(actual, nil);
}

- (void) test_currentLangCodeIsWithNil {
  GHAssertFalse([self.gestalt currentLangCodeIsEqualToCode:nil], 
                @"result should be false with code argument is nil");
}

- (void) test_currentLangCodeIsCorrect {
  NSString *code = [[NSLocale preferredLanguages] first];
  GHAssertTrue([self.gestalt currentLangCodeIsEqualToCode:code],
               @"< %@ > should be equal to the current language code: < %@ >",
               code, [self.gestalt currentLanguageCode]);
}

- (void) test_isCurrentLanguageEnglishTrue {
  LjsGestalt *g = [[LjsGestalt alloc] init];
  id mock = [OCMockObject partialMockForObject:g];
  [[[mock expect] andReturn:@"en"] currentLanguageCode];
  GHAssertTrue([g isCurrentLanguageEnglish], nil);
}

- (void) test_isCurrentLanguageEnglishFalse {
  LjsGestalt *g = [[LjsGestalt alloc] init];
  id mock = [OCMockObject partialMockForObject:g];
  [[[mock expect] andReturn:@"de"] currentLanguageCode];
  GHAssertFalse([g isCurrentLanguageEnglish], nil);
}

- (void) test_isGhUnitCommandLineBuild {
  GHTestLog(@"WARN:  no good way to test this yet");
}

@end
