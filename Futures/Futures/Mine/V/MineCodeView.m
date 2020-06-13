//
//  MIneCodeView.m
//  futures
//
//  Created by Ssiswent on 2020/6/1.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "MineCodeView.h"

@interface MineCodeView()

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;

@end

@implementation MineCodeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialSetup];
}

- (void)initialSetup
{
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
    [_cancelBtn setBackgroundColor:[UIColor colorWithRed:144/255.0 green:153/255.0 blue:253/255.0 alpha:0.8]];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,CGRectGetWidth(_confirmBtn.frame),CGRectGetHeight(_confirmBtn.frame));
    gl.startPoint = CGPointMake(1, 1);
    gl.endPoint = CGPointMake(0, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:41/255.0 green:58/255.0 blue:255/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:144/255.0 green:153/255.0 blue:253/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [_confirmBtn.layer addSublayer:gl];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(codeImgViewClicked)];
    [_codeImgView addGestureRecognizer:tap];
}

- (void)codeImgViewClicked
{
    if([self.delegate respondsToSelector:@selector(MineCodeViewDidClickCodeImgView:)])
    {
        [self.delegate MineCodeViewDidClickCodeImgView:self];
    }
}

- (IBAction)cancelBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(MineCodeViewDidClickCancelBtn:)])
    {
        [self.delegate MineCodeViewDidClickCancelBtn:self];
    }
}

- (IBAction)confirmBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(MineCodeViewDidClickConfirmBtn:inputCode:)])
    {
        [self.delegate MineCodeViewDidClickConfirmBtn:self inputCode:_codeTextF.text];
    }
}
- (IBAction)changeBtnClicked:(id)sender {
    if([self.delegate respondsToSelector:@selector(MineCodeViewDidClickChangeBtn:)])
    {
        [self.delegate MineCodeViewDidClickChangeBtn:self];
    }
}

@end
