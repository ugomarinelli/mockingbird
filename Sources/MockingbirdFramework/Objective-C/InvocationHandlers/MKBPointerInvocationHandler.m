//
//  MKBPointerInvocationHandler.m
//  MockingbirdFramework
//
//  Created by typealias on 7/19/21.
//

#import "MKBPointerInvocationHandler.h"
#import "MKBComparator.h"
#import "NSInvocation+MKBErrorObjectType.h"
#import <Mockingbird/Mockingbird-Swift.h>

@implementation MKBPointerInvocationHandler

- (instancetype)initWithNext:(MKBInvocationHandler *)next
{
  return (self = [super initWithObjCType:@encode(void *)
                                    next:next
                                selector:@selector(pointerValue)]);
}

- (MKBArgumentMatcher *)serializeArgumentAtIndex:(NSUInteger)index
                                   forInvocation:(NSInvocation *)invocation
{
  void *value;
  [invocation getArgument:&value atIndex:index];
  NSValue *boxedValue = [NSValue valueWithPointer:value];
  
  if ([invocation isErrorArgumentTypeAtIndex:index]) {
    NSString *description = [NSString stringWithFormat:@"%p (thrown error object)", value];
    return [[MKBArgumentMatcher alloc] init:boxedValue
                                description:description
                                 comparator:MKBAnyComparator];
  }
  
  return [[MKBArgumentMatcher alloc] init:boxedValue
                              description:[NSString stringWithFormat:@"%p", value]
                               comparator:MKBEquatableComparator];
}

- (void)deserializeReturnValue:(id)returnValue forInvocation:(NSInvocation *)invocation
{
  void *value = [returnValue pointerValue];
  [invocation setReturnValue:&value];
}

@end
