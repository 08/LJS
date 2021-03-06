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

#import "NSAttributedString+LjsAdditions.h"

@implementation NSAttributedString (NSAttributedString_LjsAdditions)

#if !TARGET_OS_IPHONE
+ (id) hyperlinkFromString:(NSString *) aString
                   withURL:(NSURL *) aURL
                 alignment:(NSTextAlignment) aTextAlignment {
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:aString];
  NSRange range = NSMakeRange(0, [attrString length]);
  
  [attrString beginEditing];
  [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
  
  // make the text appear in blue
  [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
  
  // next make the text appear with an underline
  [attrString addAttribute:
   NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
  
  [attrString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:13] range:range];
  
  [attrString setAlignment:aTextAlignment range:range];
  [attrString endEditing];
  
  return attrString;
}
#endif

@end

