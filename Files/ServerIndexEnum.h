//
//  ServerIndexEnum.h
//  digstEdu
//
//  Created by jaewon-Mac on 2014. 8. 11..
//  Copyright (c) 2014년 vineIT. All rights reserved.
//

#ifndef DAS_ServerIndexEnum_h
#define DAS_ServerIndexEnum_h

//#define DEBUG_LOCAL
#define DEBUG_TEST_IOU
//#define DEBUG_TEST
//#define STAGING

// local
#ifdef DEBUG_LOCAL
#define SERVER_LOGIN             @"http://localhost:8080/ssu/mobilelogin.do"
#define SERVER_QueryClient       @"http://localhost:8080/ssu/queryClient.do"
#define SERVER_QueryClientBox    @"http://localhost:8080/ssu/queryClientBox.do"
#define SERVER_Query_Path        @"http://localhost:8080/ssu/"

#define SERVER_CORE              @"http://localhost:8080/ssucore/core/server/"
#endif


// test_iou
#ifdef DEBUG_TEST_IOU
#define SERVER_LOGIN             @"http://sungshin.campusbetter.com/ssu/mobilelogin.do"
#define SERVER_QueryClient       @"http://sungshin.campusbetter.com/ssu/queryClient.do"
#define SERVER_QueryClientBox    @"http://sungshin.campusbetter.com/ssu/queryClientBox.do"
#define SERVER_Query_Path        @"http://sungshin.campusbetter.com/ssu/"

#define SERVER_CORE              @"http://sungshin.campusbetter.com/ssucore/core/server/"
#endif

// test
#ifdef DEBUG_TEST
#define SERVER_LOGIN             @"http://msidd.sungshin.ac.kr/ssu/mobilelogin.do"
#define SERVER_QueryClient       @"http://msidd.sungshin.ac.kr/ssu/queryClient.do"
#define SERVER_QueryClientBox    @"http://msidd.sungshin.ac.kr/ssu/queryClientBox.do"
#define SERVER_Query_Path        @"http://msidd.sungshin.ac.kr/ssu/"

#define SERVER_CORE              @"http://msidd.sungshin.ac.kr/ssucore/core/server/"
#endif

// staging
#ifdef STAGING
#define SERVER_LOGIN             @"http://msidp.sungshin.ac.kr:82/ssu/mobilelogin.do"
#define SERVER_QueryClient       @"http://msidp.sungshin.ac.kr:82/ssu/queryClient.do"
#define SERVER_QueryClientBox    @"http://msidp.sungshin.ac.kr:82/ssu/queryClientBox.do"
#define SERVER_Query_Path        @"http://msidp.sungshin.ac.kr:82/ssu/"

#define SERVER_CORE              @"http://msidp.sungshin.ac.kr:82/ssucore/core/server/"
#endif

#define USE_INFORMATION_URL         @"http://www.google.com"
#define FIND_PASSWORD_URL           @"http://www.naver.com"
#endif
