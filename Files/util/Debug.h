//
//  Debug.h
//  emdm
//
//  Created by kdsooi on 13. 7. 23..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#define DEBUG 1
#define INFO 0
#define ERRORS 1

#define LOG(level, format, ...) \
{ \
    if (DEBUG) \
    { \
        if (level == INFO) \
            fprintf(stderr, "[INFO] "); \
        else \
            fprintf(stderr, "[Error] "); \
        fprintf(stderr, "[%s] [%s] [line:%d] ", __FILE__, __PRETTY_FUNCTION__, __LINE__); \
        fprintf(stderr, format, ##__VA_ARGS__); \
        fprintf(stderr, "\n"); \
    } \
}