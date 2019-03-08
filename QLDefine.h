//
//  QLDefine.h
//  QiWi
//
//  Created by stevie on 2019/3/8.
//  Copyright © 2019 IQQL. All rights reserved.
//

#ifndef QLDefine_h
#define QLDefine_h
// singleton
#undef    DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class * __nonnull)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}


//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf            = self
#define STRONG_SELF STRONG_SELF_NIL_RETURN
#define KVO_STRONG_SELF KVO_STRONG_SELF_NIL_RETURN
#define STRONG_SELF_NIL_RETURN __strong typeof(weakSelf)self = weakSelf; if ( ! self) return ;
#define KVO_STRONG_SELF_NIL_RETURN __strong typeof(weakSelf)kvoSelf = weakSelf; if ( ! kvoSelf) return ;

#endif /* QLDefine_h */
