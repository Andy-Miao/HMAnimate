//
//  ViewController.m
//  HMAnimate
//
//  Created by humiao on 2019/4/9.
//  Copyright © 2019年 humiao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *addCartIV;

@property (nonatomic, strong) dispatch_source_t timer;

@property (weak, nonatomic) IBOutlet UIButton *shoppingBtn;
@end

static CGFloat const shoppingFrameAnimationDuration = .7f;
static CGFloat const shoppingRotationAnimationDuration = .1f;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 购物动画
    [self hm_setupShoppingIV];
    // 直播动画
    [self hm_initTimer];
}

//MARK:直播定时制作动画
- (void)hm_initTimer {
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        
        [self showliveAnimateFromView:self.shoppingBtn toView:self.view];
    });
    dispatch_resume(self.timer);
}

- (void)showliveAnimateFromView:(UIView *)fromView toView:(UIView *)toView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    CGRect liveFrame = [toView convertRect:fromView.frame toView:toView];
    CGPoint position = CGPointMake(fromView.layer.position.x, liveFrame.origin.y - 30);
    imageView.layer.position = position;
    NSArray *imgArr = @[@"heart_1",@"heart_2",@"heart_3",@"heart_4",@"heart_5"];
    NSInteger img = arc4random()%5;
    imageView.image = [UIImage imageNamed:imgArr[img]];
    [toView addSubview:imageView];
    
    imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    CGFloat duration = 3 + arc4random()%5;
    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimate.repeatCount = 1;
    positionAnimate.duration = duration;
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    
    UIBezierPath *sPath = [UIBezierPath bezierPath];
    [sPath moveToPoint:position];
    CGFloat sign = arc4random()%2 == 1 ? 1 : -1;
    CGFloat controlPointValue = (arc4random()%50 + arc4random()%100) * sign;
    [sPath addCurveToPoint:CGPointMake(position.x, position.y - 300) controlPoint1:CGPointMake(position.x - controlPointValue, position.y - 150) controlPoint2:CGPointMake(position.x + controlPointValue, position.y - 150)];
    positionAnimate.path = sPath.CGPath;
    [imageView.layer addAnimation:positionAnimate forKey:@"heartAnimated"];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = duration/2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10;
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [UIView animateWithDuration:duration animations:^{
        imageView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showliveAnimateFromView:self.shoppingBtn toView:self.view];
}


//MARK:创建购物视图
-(void)hm_setupShoppingIV
{
    self.addCartIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height+10, 30, 30)];
    self.addCartIV.hidden = true;
    [self.view addSubview:self.addCartIV];
    self.addCartIV.image = [UIImage imageNamed:@"heart_3"];
}

- (IBAction)shopping:(id)sender {
    
    self.addCartIV.hidden = false;
    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.addCartIV.layer.position.x-40, self.addCartIV.layer.position.y-40);//移动到起始点
    CGPathAddQuadCurveToPoint(path, NULL, 100, 100, self.view.frame.size.width, 0);
    keyframeAnimation.path = path;
    CGPathRelease(path);
    keyframeAnimation.duration = shoppingFrameAnimationDuration;
    [self.addCartIV.layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = shoppingRotationAnimationDuration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 50;
    
    [self.addCartIV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
