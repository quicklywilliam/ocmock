//---------------------------------------------------------------------------------------
//  $Id: OCMockRecorderTests.m 50 2009-07-16 06:48:19Z erik $
//  Copyright (c) 2004-2009 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <OCMock/OCMockRecorderTests.h>
#import <OCMock/OCMockRecorder.h>
#import <OCMock/OCMReturnValueProvider.h>
#import <OCMock/OCMExceptionReturnValueProvider.h>


@implementation OCMockRecorderTests

- (void)setUp
{
	NSMethodSignature *signature;
 
	signature = [NSString instanceMethodSignatureForSelector:@selector(initWithString:)];
	testInvocation = [NSInvocation invocationWithMethodSignature:signature];
	[testInvocation setSelector:@selector(initWithString:)];
}


- (void)testStoresAndMatchesInvocation
{
	OCMockRecorder *recorder;
	NSString	   *arg;
	
	arg = @"I love mocks.";
	[testInvocation setArgument:&arg atIndex:2];
	
	recorder = [[[OCMockRecorder alloc] initWithSignatureResolver:[NSString string]] autorelease];
	[(id)recorder initWithString:arg];

	STAssertTrue([recorder matchesInvocation:testInvocation], @"Should match.");
}


- (void)testOnlyMatchesInvocationWithRightArguments
{
	OCMockRecorder *recorder;
	NSString	   *arg;
	
	arg = @"I love mocks.";
	[testInvocation setArgument:&arg atIndex:2];
	
	recorder = [[[OCMockRecorder alloc] initWithSignatureResolver:[NSString string]] autorelease];
	[(id)recorder initWithString:@"whatever"];
	
	STAssertFalse([recorder matchesInvocation:testInvocation], @"Should not match.");
}


- (void)testAddsReturnValueProvider
{
	OCMockRecorder *recorder;
	NSArray		   *handlerList;

	recorder = [[[OCMockRecorder alloc] initWithSignatureResolver:[NSString string]] autorelease];
	[recorder andReturn:@"foo"];
	handlerList = [recorder invocationHandlers];
	
	STAssertEquals(1u, [handlerList count], @"Should have added one handler.");
	STAssertEqualObjects([OCMReturnValueProvider class], [[handlerList objectAtIndex:0] class], @"Should have added correct handler.");
}

- (void)testAddsExceptionReturnValueProvider
{
	OCMockRecorder	*recorder;
	NSArray			*handlerList;
	
	recorder = [[[OCMockRecorder alloc] initWithSignatureResolver:[NSString string]] autorelease];
	[recorder andThrow:[NSException exceptionWithName:@"TestException" reason:@"A reason" userInfo:nil]];
	handlerList = [recorder invocationHandlers];

	STAssertEquals(1u, [handlerList count], @"Should have added one handler.");
	STAssertEqualObjects([OCMExceptionReturnValueProvider class], [[handlerList objectAtIndex:0] class], @"Should have added correct handler.");
	
}

@end
