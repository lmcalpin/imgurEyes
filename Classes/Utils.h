//
//  Utils.h
//  imgur Eyes
//
//  Created by Lawrence McAlpin on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef imgur_Eyes_Utils_h
#define imgur_Eyes_Utils_h

static inline BOOL isEmpty(id thing) {
        return thing == nil ||
    ([thing respondsToSelector:@selector(length)] && [(NSData*)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)] && [(NSArray*)thing count] == 0);
    
}

#endif
