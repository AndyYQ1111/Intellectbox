//
//  KWCarouselView.m
//  KWViwepager
//
//  Created by WEISON on 17/1/13.
//  Copyright © 2017年 siso. All rights reserved.
//

#import "KWCarouselView.h"
#import "UIView+FrameChange.h"
#import "UIImageView+WebCache.h"

@interface KWCarouselView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
/** 当前图片索引*/
@property (nonatomic,assign) NSInteger currentIndex;
//@property (nonatomic,strong) NSTimer *timer;
/** 回调block*/
@property (nonatomic,copy) void (^block)(void);
@property (nonatomic,strong) UIImage *placeholderImg;
@property (nonatomic,assign) float oldContentOffsetX;
@property (nonatomic,assign) NSInteger imgCount;

@end
@implementation KWCarouselView
- (instancetype)initWithFrame:(CGRect)frame placeholderImg:(UIImage *)img {
    if (self = [super init]) {
        self.frame = frame;
        if (img) {
            self.placeholderImg = img;
        }
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark -- 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    BOOL isRight = self.oldContentOffsetX < point.x;
    self.oldContentOffsetX = point.x;
    // 开始显示最后一张图片的时候切换到第二个图
    if (point.x > self.width * (self.imgCount - 2) + self.width * 0.5 && !self.timer) {
        self.pageControl.currentPage = 0;
        
    }else if (point.x > self.width * (self.imgCount - 2) && self.timer && isRight){
        self.pageControl.currentPage = 0;
        
    }else{
        self.pageControl.currentPage = (point.x + self.width * 0.5) / self.width;
        
    }
    // 开始显示第一张图片的时候切换到倒数第二个图
    if (point.x >= self.width * (self.imgCount - 1)) {
        [_scrollView setContentOffset:CGPointMake(self.width + point.x - self.width * self.imgCount, 0) animated:NO];
        
    }else if (point.x < 0) {
        [scrollView setContentOffset:CGPointMake(point.x + self.width * (self.imgCount - 1), 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

#pragma mark -- 定时器
- (void)startTimer {
    if (!self.timeInterval) {
        self.timeInterval = 3;
    }
    [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextPage {
    
    NSInteger jiGe = self.pageControl.numberOfPages;
    if (jiGe == 1) {
        //如果是一张图视图就不会动了，不然就会跑   当然也可以  看你自己需求
    }else{
        [self.scrollView setContentOffset:CGPointMake((self.pageControl.currentPage + 1) * self.width, 0) animated:YES];
    }
    

}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -初始化
- (void)setTimeInterval:(NSInteger)timeInterval {
    _timeInterval = timeInterval;
}

- (void)setImgArray:(NSArray *)imgArray {
    [(NSMutableArray *)imgArray addObject:imgArray[0]];
    _imgArray = imgArray;
    self.imgCount = imgArray.count;
    for (int i = 0; i < imgArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:imgArray[i]];
        imgView.frame = CGRectMake(i * self.width, 0, self.width, self.height);
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(self.width * imgArray.count, 0);
    self.pageControl.numberOfPages = imgArray.count - 1;
    [self addImgClick];
    [self startTimer];
}

- (void)setImgUrlArray:(NSArray *)imgUrlArray {
    if (imgUrlArray.count <= 0) {
        return;
    }else if (imgUrlArray.count == 1) {
        self.pageControl.hidden = YES;
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:imgUrlArray];
    [tempArray addObject:imgUrlArray[0]];
    _imgUrlArray = (NSArray *)tempArray;
    self.imgCount = tempArray.count;
    
    for (int i = 0; i < tempArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        NSURL *imgUrl = [NSURL URLWithString:tempArray[i]];
//        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView sd_setImageWithURL:imgUrl placeholderImage:self.placeholderImg];
        imgView.frame = CGRectMake(i * self.width, 0, self.width, self.height);
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(self.width * tempArray.count, 0);
    self.pageControl.numberOfPages = tempArray.count - 1;
    [self addImgClick];
    [self startTimer];
}

- (void)setPageTintColor:(UIColor *)pageTintColor {
    self.pageControl.pageIndicatorTintColor = pageTintColor;
}
- (void)setCurrentPageTintColor:(UIColor *)currentPageTintColor {
    self.pageControl.currentPageIndicatorTintColor = currentPageTintColor;
}

#pragma mark -- 点击图片
-(void)didSelectAtIndexBlock:(void (^)(NSInteger))block {
    __weak typeof(self) weakSelf = self;
    self.block = ^(){
        if (block) {
            block((weakSelf.pageControl.currentPage));
        }
    };
}

- (void)addImgClick {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
    [self.scrollView addGestureRecognizer:tap];
}

- (void)imgClick {
    if (self.block) {
        self.block();
    }
}

#pragma mark -- 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        self.currentIndex = 1;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 13, self.width, 4)];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor blueColor];
    }
    return _pageControl;
}

@end
