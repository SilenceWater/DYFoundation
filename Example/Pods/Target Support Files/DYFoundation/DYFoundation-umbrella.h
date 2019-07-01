#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DYDate.h"
#import "DYFoundation.h"
#import "NSString+DYFoundation.h"

FOUNDATION_EXPORT double DYFoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char DYFoundationVersionString[];

