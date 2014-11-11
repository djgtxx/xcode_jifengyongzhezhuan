//
//  MathUtil.h
//  SeerDemo
//
//  Created by wuwei on 11/21/11.
//  Copyright 2011 Taomee.Inc. All rights reserved.
//
// This file defines some common geometry-releated data structures and algorithms used in Seer mobile edition.
// ����ļ��ж�����һЩ������ص����ݽṹ���㷨�������������ƶ���

#ifndef _MATH_UTIL_H_
#define _MATH_UTIL_H_

#include "cocos2d.h"

// line segment
// �߶�
struct Segment
{
    cocos2d::CCPoint start;
    cocos2d::CCPoint end;
    
    Segment(){};
    Segment(cocos2d::CCPoint s, cocos2d::CCPoint e)
    :start(s),end(e){}
};

// polygon
// �����
typedef std::vector<cocos2d::CCPoint> PointArray;
struct Polygon
{
    PointArray points;
    Polygon(){};
    Polygon(const cocos2d::CCRect& rect)
    {
        points.push_back(rect.origin);
        points.push_back(ccp(rect.origin.x, rect.origin.y + rect.size.height));
        points.push_back(ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
        points.push_back(ccp(rect.origin.x + rect.size.width, rect.origin.y));
    }
    cocos2d::CCPoint getPoint(int index) const  { return points[index]; }
    void addPoint(cocos2d::CCPoint p) { points.push_back(p); }
    void clear() { points.clear(); }
    size_t size() { return points.size(); }
};

// circle
// Բ
struct Circle
{
    cocos2d::CCPoint center;
    float radius;
    
    Circle(cocos2d::CCPoint c, float r)
    :center(c),radius(r){}
};

// calculate the cross product of two vectors
// �����������
inline cocos2d::CCPoint vectorCross(const cocos2d::CCPoint& v1, const cocos2d::CCPoint& v2)
{
    return ccp(v1.y - v2.y, v2.x - v1.x);
}

// calculate the shortest distance from a point to a line segment
// ����㵽�߶ε���̾���
float minDist(const cocos2d::CCPoint& p, const Segment& s);

// calculate the intersection of two segments, assuming they intersect
// ���������߶ν��㣬���������ཻ
cocos2d::CCPoint intersection(const Segment& s1, const Segment& s2);

// determine if two line segments intersect with each other
// �ж������߶��Ƿ��ཻ
bool isTwoSegmentsIntersect(const Segment& s1, const Segment& s2);
bool isTwoSegmentsIntersect(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4);

// determine if a line segment intersects with a polygon
// �ж�һ���߶κ�һ��������Ƿ��ཻ
bool isSegmentIntersectWithPolygon(const Segment& s, const struct Polygon& p);

// determin if a line segment intersects with a rectangle
// �ж�һ���߶κ�һ�������Ƿ��ཻ
bool isSegmentIntersectWithRect(const Segment& s, const cocos2d::CCRect& rect);

// determine if a line segment intersects with a circle
// �ж�һ���߶κ�һ��Բ�Ƿ��ཻ
bool isSegmentIntersectWithCircle(const Segment& s, const Circle& c);

// determine if a rect overlaps a circle
// �ж�һ�������Ƿ��һ��Բ���ص�
bool isRectOverlapCircle(const cocos2d::CCRect& rect, const Circle& c);

// determine if a rect overlaps a polygon
// �ж�һ�������Ƿ��һ����������ص�
bool isRectOverlapPolygon(const cocos2d::CCRect& rect, const struct Polygon& p);

// determine if a point is inside a rectangle, including on the border
// �ж�һ�����Ƿ��ھ����ڣ������ڱ߽��ϣ�
bool isPointInRect(const cocos2d::CCPoint& p, const cocos2d::CCRect& rect);

// determine if a point is inside a circle, including on the border
// �ж�һ�����Ƿ���Բ�ڣ������ڱ߽��ϣ�
bool isPointInCircle(const cocos2d::CCPoint& p, const Circle& c);

// determine if a point is inside a polygon, including on the border
// �ж�һ�����Ƿ��ڶ�����ڣ������ڱ߽��ϣ�
bool isPointInPolygon(const cocos2d::CCPoint& point, const struct Polygon& polygon);

// generate a polygon to simulate a fan
// ����һ�������������һ������
// ������1.c ����Բ��
//      2.r ���ΰ뾶
//      2.angle  ���μн�
//      3.rotation �������������x���������ת��
//      4.outPolygon �洢��������ݵ�����
void genFanPolygon(const cocos2d::CCPoint& c, float r, float angle, float rotation, struct Polygon& outPolygon);

// rotate a rect
// ��ת����
void rotateRect(const cocos2d::CCRect& rect, float angle, const cocos2d::CCPoint& pivot, struct Polygon& outPolygon);


inline int ranged_random(int a, int b)
{
	int max = a>b?a:b;
	int min = a<=b?a:b;
	// generates ranged random number
	return (rand() % (max - min + 1)) + min;
}

#endif