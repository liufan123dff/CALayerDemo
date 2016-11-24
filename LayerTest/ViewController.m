//
//  ViewController.m
//  LayerTest
//
//  Created by w99wen on 16/6/24.
//  Copyright © 2016年 w99wen. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SCALayer.h"
#define WIDTH 185
#define PHOTO_HEIGHT 150
@interface ViewController ()
@property(nonatomic,retain) UIButton *btn;
@property(nonatomic,retain) CALayer *layer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIImage *backgroundImage=[UIImage imageNamed:@"photo.png"];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:backgroundImage];
    
    //自定义一个图层
    _layer=[[CALayer alloc]init];
    _layer.bounds=CGRectMake(0, 0, 50, 50);
    _layer.position=CGPointMake(100, 200);
    _layer.contents=(id)[UIImage imageNamed:@"photo.png"].CGImage;
//    CALayer *maskLayer = [[CALayer alloc] init];
//    maskLayer.bounds = CGRectMake(0, 0, 50, 100);
//    maskLayer.position = CGPointMake(0, 0);
//    maskLayer.contents = (id)[UIImage imageNamed:@"photo.png"].CGImage;
//    maskLayer.cornerRadius = 10;
//    _layer.mask = maskLayer;
    [self.view.layer addSublayer:_layer];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(printStr:) object:@"string is 1234"];
    [operation1 setCompletionBlock:^{
        NSLog(@"%@",@"operation complite");
    }];
    [queue addOperation:operation1];
    [NSUserDefaults standardUserDefaults];
    [self rotationAnimation];
//    CABasicAnimation *strokeStartAnimation = nil;
//    strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
//    strokeStartAnimation.duration = 3;
//    strokeStartAnimation.fromValue = @(self.view.layer.bounds.size.width);
//    strokeStartAnimation.toValue = @(self.view.layer.bounds.size.width * 2);
//    strokeStartAnimation.autoreverses = NO;
//    strokeStartAnimation.repeatCount = 0.f;
//    [btn.layer addAnimation:strokeStartAnimation forKey:@"widthDouble"];
//    [self drawCustomLayer];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)printStr:(NSString *)str{
    NSLog(@"%s:%@",__func__,str);
}
#pragma mark 移动动画
-(void)translatonAnimation:(CGPoint)location{
    //1.创建动画并指定动画属性
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    //2.设置动画属性初始值和结束值
    //    basicAnimation.fromValue=[NSNumber numberWithInteger:50];//可以不设置，默认为图层初始状态
    basicAnimation.toValue=[NSValue valueWithCGPoint:location];
    
    //设置其他动画属性
    basicAnimation.duration=5.0;//动画时间5秒
    //basicAnimation.repeatCount=HUGE_VALF;//设置重复次数,HUGE_VALF可看做无穷大，起到循环动画的效果
    //    basicAnimation.removedOnCompletion=NO;//运行一次是否移除动画
    basicAnimation.delegate=self;
    //存储当前位置在动画结束后使用
    [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"KCBasicAnimationLocation"];
    
    //3.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Translation"];
}

#pragma mark 旋转动画
-(void)rotationAnimation{
    //1.创建动画并指定动画属性
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //2.设置动画属性初始值、结束值
    //    basicAnimation.fromValue=[NSNumber numberWithInt:M_PI_2];
    basicAnimation.toValue=[NSNumber numberWithFloat:M_PI * 2];
    
    //设置其他动画属性
    basicAnimation.duration=6.0;
    basicAnimation.autoreverses=NO;//旋转后在旋转到原来的位置
    basicAnimation.repeatCount=HUGE_VALF;//设置无限循环
    basicAnimation.removedOnCompletion=NO;
    //    basicAnimation.delegate=self;
    
    //4.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
}

#pragma mark 点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=touches.anyObject;
    CGPoint location= [touch locationInView:self.view];
    //创建并开始动画
//    [self translatonAnimation:location];
    CAAnimation *animation= [_layer animationForKey:@"KCBasicAnimation_Translation"];
    if(animation){
        if (_layer.speed==0) {
            [self animationResume];
        }else{
            [self animationPause];
        }
    }else{
        //创建并开始动画
        [self translatonAnimation:location];
        
        [self rotationAnimation];
    }
    
}

#pragma mark 动画暂停
-(void)animationPause{
    //取得指定图层动画的媒体时间，后面参数用于指定子图层，这里不需要
    CFTimeInterval interval=[_layer convertTime:CACurrentMediaTime() fromLayer:nil];
    NSLog(@"CACurrentMediaTime = %f",CACurrentMediaTime());
    //设置时间偏移量，保证暂停时停留在旋转的位置
    [_layer setTimeOffset:interval];
    //速度设置为0，暂停动画
    _layer.speed=0;
}

#pragma mark 动画恢复
-(void)animationResume{
    NSLog(@"000000CACurrentMediaTime = %f",CACurrentMediaTime());

    //获得暂停的时间
    CFTimeInterval beginTime= CACurrentMediaTime()- _layer.timeOffset;
    
    NSLog(@"_layer.timeOffset = %f",_layer.timeOffset);
    //设置偏移量
    _layer.timeOffset=0;
    //设置开始时间
    _layer.beginTime=beginTime;
    //设置动画速度，开始运动
    _layer.speed=1.0;
}

#pragma mark - 动画代理方法
#pragma mark 动画开始
-(void)animationDidStart:(CAAnimation *)anim{
//    NSLog(@"animation(%@) start.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
//    NSLog(@"%@",[_layer animationForKey:@"KCBasicAnimation_Translation"]);//通过前面的设置的key获得动画
}
#pragma mark 动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    NSLog(@"animation(%@) stop.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    [CATransaction begin];
    //禁用隐式动画
    [CATransaction setDisableActions:YES];
    _layer.position=[[anim valueForKey:@"KCBasicAnimationLocation"] CGPointValue];
    [CATransaction commit];
}

-(void)BtnClicked{
    CABasicAnimation *strokeStartAnimation = nil;
    CGFloat tmp = _btn.layer.bounds.size.width;
    
    strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    strokeStartAnimation.duration = 1;
    
    strokeStartAnimation.toValue = @(tmp * 2);
    strokeStartAnimation.autoreverses = NO;
    strokeStartAnimation.repeatCount = 0.f;
    [strokeStartAnimation setValue:@(tmp * 2) forKey:@"KCBasicAnimationLocation"];
    strokeStartAnimation.delegate = self;
    [_btn.layer addAnimation:strokeStartAnimation forKey:@"widthDouble"];
    [_btn.layer setNeedsDisplay];
}
-(void)drawCustomLayer{
    SCALayer *layer=[[SCALayer alloc]init];
    layer.bounds=CGRectMake(0, 0, 185, 185);
    layer.position=CGPointMake(160,284);
    layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
    
    //显示图层
    [layer setNeedsDisplay];
//    WIDTH = layer.bounds.size.width;
    [self.view.layer addSublayer:layer];
}

#pragma mark 绘制图片

-(void)drawImga{
    CGPoint position= CGPointMake(160, 200);
    CGRect bounds=CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT);
    CGFloat cornerRadius=PHOTO_HEIGHT/2;
    CGFloat borderWidth=2;
    
    //阴影图层
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.bounds=bounds;
    layerShadow.position=position;
    layerShadow.cornerRadius=cornerRadius;
    layerShadow.shadowColor=[UIColor grayColor].CGColor;
    layerShadow.shadowOffset=CGSizeMake(2, 1);
    layerShadow.shadowOpacity=1;
    layerShadow.borderColor=[UIColor whiteColor].CGColor;
    layerShadow.borderWidth=borderWidth;
    [self.view.layer addSublayer:layerShadow];
    
    //容器图层
    CALayer *layer=[[CALayer alloc]init];
    layer.bounds=bounds;
    layer.position=position;
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.cornerRadius=cornerRadius;
    layer.masksToBounds=YES;
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.borderWidth=borderWidth;
    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    //阴影效果无法和masksToBounds同时使用，因为masksToBounds的目的就是剪切外边框，
    //而阴影效果刚好在外边框
    //    layer.shadowColor=[UIColor grayColor].CGColor;
    //    layer.shadowOffset=CGSizeMake(2, 2);
    //    layer.shadowOpacity=1;
    
    //设置图层代理
    layer.delegate=self;
    
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
    
    //调用图层setNeedDisplay,否则代理方法不会被调用
    [layer setNeedsDisplay];
}

#pragma mark 绘制图形、图像到图层，注意参数中的ctx是图层的图形上下文，其中绘图位置也是相对图层而言的
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//        NSLog(@"%@",layer);//这个图层正是上面定义的图层
//    CGContextSaveGState(ctx);
    //图形上下文形变，解决图片倒立的问题
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -PHOTO_HEIGHT);
    
    UIImage *image=[UIImage imageNamed:@"photo.png"];
    //注意这个位置是相对于图层而言的不是屏幕
    CGContextDrawImage(ctx, CGRectMake(0, 0, PHOTO_HEIGHT, PHOTO_HEIGHT), image.CGImage);
    //    CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    
//    CGContextRestoreGState(ctx);
}


#pragma mark 绘制图层
-(void)drawMyLayer{
    CGSize size=[UIScreen mainScreen].bounds.size;
    
    //获得根图层
    
    CALayer *layer=[[CALayer alloc]init];
    //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
    layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
    //设置中心点
    layer.position=CGPointMake(size.width/2, size.height/2);
    //设置大小
    layer.bounds=CGRectMake(0, 0, WIDTH,WIDTH);
    //设置圆角,当圆角半径等于矩形的一半时看起来就是一个圆形
    layer.cornerRadius=WIDTH/2;
    //设置阴影
    layer.shadowColor=[UIColor grayColor].CGColor;
    layer.shadowOffset=CGSizeMake(2, 2);
    layer.shadowOpacity=.9;
    
    //设置边框
    //    layer.borderColor=[UIColor whiteColor].CGColor;
    //    layer.borderWidth=1;
    //设置锚点
    //    layer.anchorPoint=CGPointZero;
    [self.view.layer addSublayer:layer];
    
}

#pragma mark 点击放大
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch=[touches anyObject];
//    CALayer *layer=self.view.layer.sublayers.lastObject;
//    CGFloat width=layer.bounds.size.width;
//    if (width==WIDTH) {
//        width=WIDTH*4;
//    }else{
//        width=WIDTH;
//    }
//    layer.bounds=CGRectMake(0, 0, width, width);
//    layer.position=[touch locationInView:self.view];
////    NSLog(@"%@",NSStringFromCGPoint(layer.position));
////    layer.cornerRadius=width/2;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
