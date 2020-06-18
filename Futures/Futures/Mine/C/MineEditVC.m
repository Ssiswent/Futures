//
//  MineEditVC.m
//  futures
//
//  Created by Ssiswent on 2020/5/25.
//  Copyright © 2020 Francis. All rights reserved.
//

#import "MineEditVC.h"
#import "UIImage+OriginalImage.h"

#import "MineInformationNameView.h"
#import "MineInformationSignatureView.h"

#import "MineUserModel.h"

#import <TZImagePickerController.h>

#import "MineInformationCell.h"

#import "CustomTBC.h"

@interface MineEditVC ()<UITableViewDataSource, UITableViewDelegate, MineInformationNameViewDelegate, MineInformationSignatureViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@property (weak, nonatomic) IBOutlet UITableView *mineEditTableView;

@property (weak, nonatomic)UIView *coverView;
@property (weak, nonatomic)MineInformationNameView *mineInformationNameView;
@property (weak, nonatomic)MineInformationSignatureView *mineInformationSignatureView;

@property (copy, nonatomic)NSString *originName;
@property (copy, nonatomic)NSString *originSignature;
@property (copy, nonatomic)NSString *changedName;
@property (copy, nonatomic)NSString *changedSignature;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (copy, nonatomic)  NSString *saveURL;

@end

@implementation MineEditVC

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

NSString *MineInformationCellID = @"MineInformationCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑资料";
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    [self.mineEditTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineInformationCell class]) bundle:nil] forCellReuseIdentifier:MineInformationCellID];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage originalImageWithName:@"ic_back"] style:0 target:self action:@selector(backBtnClicked)];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.mineEditTableView.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    
    [self setAvatarImg];
    [self setLayer];
    
    //启用右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [CustomTBC setTabBarHidden:YES TabBarVC:self.tabBarController];
}

- (void)setAvatarImg
{
    [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:_user.head]
                      placeholderImage:[UIImage imageNamed:@"head"]];
}

- (void)setLayer
{
    _avatarImgView.layer.cornerRadius = CGRectGetWidth(_avatarImgView.frame)/2;
    _avatarImgView.layer.masksToBounds = YES;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cameraBtnClicked:(id)sender {
    [self changeAvatar];
}

- (void)changeAvatar
{
    //UIAlertControllerStyleAlert
    //UIAlertControllerStyleActionSheet
    //1.创建控制器
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //2.创建按钮
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮要执行的方法
        [self takePhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮要执行的方法
        [self pushTZImagePickerController];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮要执行的方法
    }];
    
    UIColor *alertTextColor = [UIColor colorWithHexString:@"#293AFF"];
    [action1 setValue:alertTextColor forKey:@"titleTextColor"];
    [action2 setValue:alertTextColor forKey:@"titleTextColor"];
    [action3 setValue:[UIColor colorWithHexString:@"#333333"] forKey:@"titleTextColor"];
    
    
    //3.添加按钮
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    
    //4.显示弹窗(相当于show)
    //这种方法，开头必须是控制器
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

//获取照片
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.avatarImgView.image = photo;
    [self uploadImg:photo];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.naviBgColor = [UIColor colorWithHexString:@"#293AFF"];
    imagePickerVc.navigationBar.translucent = NO;
    
    imagePickerVc.isSelectOriginalPhoto = YES;
//    imagePickerVc.needShowStatusBar = NO;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    
    //     imagePickerVc.photoWidth = 1600;
    //     imagePickerVc.photoPreviewMaxWidth = 1600;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    //     imagePickerVc.minImagesCount = 3;
    //     imagePickerVc.alwaysEnableDoneBtn = YES;
    
    //裁剪
    imagePickerVc.allowCrop = YES;
    //圆形裁剪
    imagePickerVc.needCircleCrop = YES;
    //    // 设置竖屏下的裁剪尺寸
    //    NSInteger left = 30;
    //    NSInteger widthHeight = self.view.tz_width - 2 * left;
    //    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    //    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    //    imagePickerVc.scaleAspectFillCrop = YES;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    WEAKSELF
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *selectedImg = photos[0];
        weakSelf.avatarImgView.image = selectedImg;
        [self uploadImg:selectedImg];
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//上传图片:resopnse是地址
-(void)uploadImg:(UIImage *)img{
    WEAKSELF
    NSDictionary *dict = @{
        @"file" : img
    };
    [NetworkTool.shared postReturnString:@"http://image.yysc.online/upload" fileName:@"testImg" image:img viewcontroller:self params:dict success:^(id _Nonnull resopnse) {
        self.saveURL = resopnse;
        [self setUserHead];
    } failture:^(NSError * _Nonnull error) {
        [Toast makeText:weakSelf.view Message:@"上传图片失败" afterHideTime:DELAYTiME];
    }];
}

#pragma mark - InformationDelegate

- (void)mineInformationNameViewDidClickCancelBtn:(MineInformationNameView *)mineInformationNameView
{
    [self removeCoverView:mineInformationNameView];
}

- (void)mineInformationNameViewDidClickConfirmBtn:(MineInformationNameView *)mineInformationNameView changedName:(NSString *)changedName
{
    _changedName = changedName;
    [self setUser];
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    [self.mineEditTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self removeCoverView:mineInformationNameView];
}

- (void)mineInformationSignatureViewDidClickCancelBtn:(MineInformationSignatureView *)mineInformationSignatureView
{
    [self removeCoverView:mineInformationSignatureView];
}

- (void)mineInformationSignatureViewDidClickConfirmBtn:(MineInformationSignatureView *)mineInformationSignatureView changedSignature:(NSString *)changedSignature
{
    _changedSignature = changedSignature;
    [self setUser];
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:1]];
    [self.mineEditTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self removeCoverView:mineInformationSignatureView];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineInformationCell *informationCell = [tableView dequeueReusableCellWithIdentifier:MineInformationCellID];
    informationCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0)
    {
        
        informationCell.leftLabel.text = @"更换相册封面";
    }
    else
    {
        if(indexPath.row == 0)
        {
            informationCell.leftLabel.text = @"昵称";
            informationCell.rightLabel.text = _user.nickName;
            if(_changedName)
            {
                informationCell.rightLabel.text = _changedName;
            }
        }
        else
        {
            informationCell.leftLabel.text = @"个性标签";
            informationCell.rightLabel.text = _user.signature;
            if(_changedSignature)
            {
                informationCell.rightLabel.text = _changedSignature;
            }
        }
    }
    return informationCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *headerView = UIView.new;
        headerView.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        [self changeAvatar];
    }
    else
    {
        if(indexPath.row == 0)
        {
            MineInformationNameView *mineInformationNameView = [[NSBundle mainBundle]loadNibNamed:@"MineInformationNameView" owner:nil options:nil].firstObject;
            mineInformationNameView.delegate = self;
            [self addCoverView:mineInformationNameView];
        }
        else if(indexPath.row == 1)
        {
            MineInformationSignatureView *mineInformationSignatureView = [[NSBundle mainBundle]loadNibNamed:@"MineInformationSignatureView" owner:nil options:nil].firstObject;
            mineInformationSignatureView.delegate = self;
            [self addCoverView:mineInformationSignatureView];
        }
    }
}

- (void)removeCoverView:(UIView *)view
{
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        if([view isKindOfClass:[MineInformationNameView class]])
        {
            self.mineInformationNameView.alpha = 0;
            CGRect frame = self.mineInformationNameView.frame;
            frame.size = CGSizeMake(0, 0);
            self.mineInformationNameView.frame = frame;
        }
        else
        {
            self.mineInformationSignatureView.alpha = 0;
            CGRect frame = self.mineInformationSignatureView.frame;
            frame.size = CGSizeMake(0, 0);
            self.mineInformationSignatureView.frame = frame;
        }
    }completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}

- (void)addCoverView:(UIView *)view
{
    UIView *coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    view.alpha = 0;
    view.center = coverView.center;
    CGRect frame = view.frame;
    frame.size = CGSizeMake(0, 0);
    view.frame = frame;
    [coverView addSubview:view];
    if([view isKindOfClass:[MineInformationNameView class]])
    {
        _mineInformationNameView = (MineInformationNameView *)view;
    }
    else
    {
        _mineInformationSignatureView = (MineInformationSignatureView *)view;
    }
    
    _coverView = coverView;
    
    NSArray *array = [UIApplication sharedApplication].windows;
    UIWindow *keyWindow = [array objectAtIndex:0];
    [keyWindow addSubview:_coverView];
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        if([view isKindOfClass:[MineInformationNameView class]])
        {
            self.mineInformationNameView.alpha = 1;
            CGRect frame = self.mineInformationNameView.frame;
            frame.size = CGSizeMake(340, 181);
            self.mineInformationNameView.frame = frame;
        }
        else
        {
            self.mineInformationSignatureView.alpha = 1;
            CGRect frame = self.mineInformationSignatureView.frame;
            frame.size = CGSizeMake(340, 181);
            self.mineInformationSignatureView.frame = frame;
        }
    }];
}

-(void)setUser{
    WEAKSELF
    NSString *changeSignature;
    NSString *changedName;
    if(_changedName == nil)
    {
        changedName = _user.nickName;
    }
    else
    {
        changedName = _changedName;
    }
    if(_changedSignature == nil)
    {
        changeSignature = _user.signature;
    }
    else
    {
        changeSignature = _changedSignature;
    }
    NSDictionary *dic = @{@"id":_user.userId,@"nickName":changedName,@"signature":changeSignature};
    [ENDNetWorkManager putWithPathUrl:@"/user/personal/updateUser" parameters:dic queryParams:nil Header:nil success:^(BOOL success, id result) {
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"上传用户资料失败" afterHideTime:DELAYTiME];
    }];
}

-(void)setUserHead{
    WEAKSELF
    NSDictionary *dic = @{@"id":_user.userId,@"head":self.saveURL};
    [ENDNetWorkManager putWithPathUrl:@"/user/personal/updateUser" parameters:dic queryParams:nil Header:nil success:^(BOOL success, id result) {
    } failure:^(BOOL failuer, NSError *error) {
        NSLog(@"%@",error.description);
        [Toast makeText:weakSelf.view Message:@"上传用户头像失败" afterHideTime:DELAYTiME];
    }];
}

@end
