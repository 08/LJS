// Copyright 2012 Little Joy Software. All rights reserved.
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



#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsGoogleImportTest_Super.h"
#import "LjsGooglePlacesDetailsReply.h"
#import "LjsGooglePlacesNmoDetails.h"


@interface LjsGooglePlacesDetailsReplyTests : LjsGoogleImportTest_Super
@end

@implementation LjsGooglePlacesDetailsReplyTests

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
  return NO;
}

- (void) setUpClass {
//  [super setUpClass];
  // Run at start of all tests in the class
  [super setUpClass];
}

- (void) tearDownClass {
  // Run at end of all tests in the class
  [super tearDownClass];
}

- (void) setUp {
  self.resourceName = @"google-places-details-sample";
  [super setUp];
  // Run before each test method
}

- (void) tearDown {
  // Run after each test method
  [super tearDown];
}  

- (void) test_detailsReplyInit {
  NSString *reply;
  LjsGooglePlacesDetailsReply *result;
  NSError *error;

  error = nil;
  reply = self.jsonResource;
  result = [[LjsGooglePlacesDetailsReply alloc]
            initWithReply:reply error:&error];
  GHAssertNotNil(result, nil);
  GHAssertNotNil([result details], nil);
  GHAssertTrue([result statusHasResults], nil);
  GHAssertNil(error, nil);
  
  error = nil;
  reply = @"[";
  result = [[LjsGooglePlacesDetailsReply alloc]
            initWithReply:reply error:&error];
  GHAssertNotNil(result, nil);
  GHAssertNil([result details], nil);
  GHAssertFalse([result statusHasResults], nil);
  GHAssertNotNil(error, nil);

  
  
}

@end
