// Copyright 2011 The Little Joy Software Company. All rights reserved.
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


#import <Foundation/Foundation.h>

extern NSString *LjsDateHelperAM;
extern NSString *LjsDateHelperPM;

extern NSString *LjsDateHelper12HoursStringKey;
extern NSString *LjsDateHelper24HoursStringKey;
extern NSString *LjsDateHelperMinutesStringKey;
extern NSString *LjsDateHelperAmPmKey;

extern NSString *LjsDateHelper12HoursNumberKey;
extern NSString *LjsDateHelper24HoursNumberKey;
extern NSString *LjsDateHelperMinutesNumberKey;


@interface LjsDateHelper : NSObject {
    
}


+ (NSTimeInterval) intervalBetweenPast:(NSDate *) past future:(NSDate *) future;

+ (NSTimeInterval) timeIntervalWithHmsString:(NSString *) timeString;

/*
 The receiver and anotherDate are exactly equal to each other, NSOrderedSame
 The receiver is later in time than anotherDate, NSOrderedDescending
 The receiver is earlier in time than anotherDate, NSOrderedAscending.
 */
+ (BOOL) dateIsFuture:(NSDate *) date;
+ (BOOL) dateIsPast:(NSDate *) date;

+ (NSDateFormatter *) hoursMinutesAmPmFormatter;


+ (BOOL) minutesStringValid:(NSString *) minutesStr;
+ (BOOL) hourStringValid:(NSString *) hoursStr using24HourClock:(BOOL) use24HourClock; 
+ (BOOL) amPmStringValid:(NSString *) amOrPm;
+ (BOOL) timeStringHasCorrectLength:(NSString *) timeString using24HourClock:(BOOL) a24Clock;

+ (BOOL) amPmStringHasCorrectComponents:(NSString *) timeString;
+ (BOOL) twentyFourHourTimeStringHasCorrectComponents:(NSString *) timeString;
+ (BOOL) timeStringHasCorrectComponents:(NSString *) timeString using24HourClock:(BOOL) use24HourClock;

+ (BOOL) isValidAmPmTime:(NSString *) amPmTime;
+ (BOOL) isValid24HourTime:(NSString *) twentyFourHourTime;

+ (NSDictionary *) componentsWithTimeString:(NSString *) timeString;
+ (NSDictionary *) componentsWith24HourTimeString:(NSString *) twentyFourHourTime;
+ (NSDictionary *) componentsWithAmPmTimeString:(NSString *) amPmTime;


+ (NSString *) convert24hourTimeToAmPmTime:(NSString *) twentyFourHourTime;
+ (NSString *) amPmTimeWithTimeString:(NSString *) amPmTime;
+ (NSString *) amPmTimeWithDate:(NSDate *) date;




#pragma mark DEAD SEA

//+ (BOOL) shouldUse24HourClock;
//
//+ (NSString *) hourMinutesWithDate:(NSDate *) date;
//
//+ (NSDate *) dateWithHourMinutesString:(NSString *) hoursMinutes;



@end