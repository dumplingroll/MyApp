//
//  NetInterface.h
//  食趣
//
//  Created by 汤汤 on 15/10/18.
//  Copyright © 2015年 汤汤. All rights reserved.
//

#ifndef NetInterface_h
#define NetInterface_h

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
//食谱分类页面
#define MENU_URL @"http://www.tngou.net/api/cook/classify"

//食谱列表
#define MENU_LIST_URL @"http://www.tngou.net/api/cook/list?id=%@&page=%ld"
#define MENU_LIST_ALL_URL @"http://www.tngou.net/api/cook/list?page=%ld"


//男生
#define BOY_LIST_URL @"http://www.tngou.net/api/food/list?id=78&rows=10&page=%ld"
//女生
#define GIRL_LIST_URL @"http://www.tngou.net/api/food/list?id=79&rows=10&page=%ld"
//男生女生详情
#define FOOD_DETAIL_URL @"http://www.tngou.net/api/food/show?id=%@"

//养生保健
#define FIT_LIST_URL @"http://www.tngou.net/api/food/list?id=1&rows=10&page=%ld"
//呼吸道
#define BREATH_LIST_URL @"http://www.tngou.net/api/food/list?id=85&rows=10&page=%ld"
//美容减肥
#define BEAUTY_LIST_URL @"http://www.tngou.net/api/food/list?id=148&rows=10&page=%ld"
//肝胆器官
#define ORGAN_LIST_URL @"http://www.tngou.net/api/food/list?id=208&rows=10&page=%ld"
#define SEARCH_URL @"http://www.tngou.net/api/food/name?name=%@"

#endif /* NetInterface_h */
