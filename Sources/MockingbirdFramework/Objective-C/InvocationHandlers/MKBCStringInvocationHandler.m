//
//  MKBCStringInvocationHandler.m
//  MockingbirdFramework
//
//  Created by typealias on 7/19/21.
//

#import "MKBCStringInvocationHandler.h"
#import "MKBComparator.h"
#import <Mockingbird/Mockingbird-Swift.h>

@implementation MKBCStringInvocationHandler

- (instancetype)initWithNext:(MKBInvocationHandler *)next
{
  return (self = [super initWithObjCType:@encode(char *)
                                    next:next
                                selector:@selector(stringValue)]);
}

- (MKBArgumentMatcher *)serializeArgumentAtIndex:(NSUInteger)index
                                   forInvocation:(NSInvocation *)invocation
{
  char *value;
  [invocation getArgument:&value atIndex:index];
  NSString *description = [NSString stringWithUTF8String:value];
  return [[MKBArgumentMatcher alloc] init:description
                              description:description
                               comparator:MKBEquatableComparator];
}

- (void)deserializeReturnValue:(id)returnValue forInvocation:(NSInvocation *)invocation
{
  char *value = (char *)[[returnValue stringValue] UTF8String];
  [invocation setReturnValue:&value];
}

@end
