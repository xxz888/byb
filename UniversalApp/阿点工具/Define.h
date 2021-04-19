
// ------------------------------------------------
//应用所用到所有宏定义
// ------------------------------------------------

// app Build
#define APP_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// app名称
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

// keyWindow
#define AppKeyWindow [[UIApplication sharedApplication] keyWindow]

//目录路径_Document
#define docPath1 [[[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent] stringByAppendingString:@"/Documents/"]

// log Rect
#define RectLog(rect) NSLog(@"x:%f, y:%f, w:%f, h:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)

// 上下左右都相等的UIEdgeInsets
#define UIEdgeInsetsEqualOffsetMake(offset) UIEdgeInsetsMake(offset, offset, offset, offset)

#define NoPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
