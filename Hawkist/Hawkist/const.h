//
//  const.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#ifndef Hawkist_const_h
#define Hawkist_const_h

//#define TEST_SERVER


#define kUSER_ID @"user_id"

#ifdef TEST_SERVER


//#define SERVER_URL @"http://52.18.7.196:8000/api/"

#define SERVER_URL @"http://45.55.197.87:8003/api/"  // - test
#define SERVER_API_KEY @"c7f3380a074f4736"
#define SERVER_API_PASS @"8ec1d0c900079d0a"

#else

#define SERVER_URL @"http://52.18.7.196:8000/api/"
#define SERVER_API_KEY @"c7f3380a074f4736"
#define SERVER_API_PASS @"8ec1d0c900079d0a"


#endif

#define FACEBOOK_APP_ID @"1592531330997204"
#define FACEBOOK_APP_ID @"452450878249777"
#define STRIPE_KEY @"pk_test_oury2cSVAi0FgbINEHbGbyV6"

#ifdef DEBUG

#define LeanPlum_APP_ID @"app_KDXJqv2wDVTDVFDxckARmWAiQMtEf6DNu6Nj8MffNm8"
#define LeanPlum_DevKey @"dev_pKABuSCybC918bRvGc9sjoOzbfPpikqArhOkn7ws9VE"
#else
#define LeanPlum_APP_ID @"app_KDXJqv2wDVTDVFDxckARmWAiQMtEf6DNu6Nj8MffNm8"
#define LeanPlum_DevKey @"prod_AGvlqjixqJhhZIUE9jeZeZOrbUmSAyjizTsnEUu7Kho"
#endif

#endif



