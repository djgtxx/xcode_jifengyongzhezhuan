/**
 *============================================================
 *  @file      byteswap.hpp
 *  @brief     ���ڽ����ֽ���ת�������ԭ������������ת�ɱ��������ԭ���Ǳ�������ת��������\n
 *             �÷���val = bswap(val);�����Զ������С���������ͽ����ֽ���ת����
 * 
 *  compiler   gcc4.1.2
 *  platform   Linux
 *
 *  copyright:  TaoMee, Inc. ShangHai CN. All rights reserved.
 *
 *============================================================
 */

#ifndef LIBTAOMEEPP_BYTESWAP_HPP_
#define LIBTAOMEEPP_BYTESWAP_HPP_

extern "C" {
#include <stdint.h>   // C99

}

#include "byteswap.h" // Linux


namespace taomee {

inline int8_t bswap(int8_t x)
{
	return x;
}

inline uint8_t bswap(uint8_t x)
{
	return x;
}

inline int16_t bswap(int16_t x)
{
	return __bswap_16(x);
}

inline uint16_t bswap(uint16_t x)
{
	return __bswap_16(x);
}

inline int32_t bswap(int32_t x)
{
	return __bswap_32(x);
}

inline uint32_t bswap(uint32_t x)
{
	return __bswap_32(x);
}

inline int64_t bswap(int64_t x)
{
	union { unsigned long long int __ll;                   \
		unsigned int __l[2]; } __w, __r;                             \
	{                                                                  \
	__w.__ll = (x);                                                  \
	__r.__l[0] = __bswap_32 (__w.__l[1]);                            \
	__r.__l[1] = __bswap_32 (__w.__l[0]);                            \
	}                                                                  \
	(x) = __r.__ll;
	return x;
}

inline uint64_t bswap(uint64_t x)
{
	union { unsigned long long int __ll;                   \
		unsigned int __l[2]; } __w, __r;                             \
	{                                                                  \
	__w.__ll = (x);                                                  \
	__r.__l[0] = __bswap_32 (__w.__l[1]);                            \
	__r.__l[1] = __bswap_32 (__w.__l[0]);                            \
	}                                                                  \
	(x) = __r.__ll;
	return x;
}

#if __WORDSIZE == 32
inline long bswap(long x)
{
	return __bswap_32(x);
}

inline unsigned long bswap(unsigned long x)
{
	return __bswap_32(x);
}
#endif

} // namespace taomee

#endif // LIBTAOMEEPP_BYTESWAP_HPP_