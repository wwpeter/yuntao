#import "BusinessRegisterSecondViewController.h"
#import "TopRedView.h"
#import "RGTextCodeView.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+HBClass.h"
#import "BusinessRegisterThirdViewController.h"

@interface BusinessRegisterSecondViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UIImageView *licenseImageView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *licenseImage;

@end

@implementation BusinessRegisterSecondViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        self.navigationItem.title = @"注册2/3";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"下一步", @"Next") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - imagePicker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:picker.view];
    [picker.view addSubview:hud];
    hud.labelText = @"正在处理图片...";
    __block UIImage *image = info[UIImagePickerControllerOriginalImage];
    [hud showAnimated:YES whileExecutingBlock:^{
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        if (width > kDeviceCurrentWidth) {
            CGFloat multiple = kDeviceCurrentWidth / width;
            height = height * multiple;
            width = kDeviceCurrentWidth;
            image = [image imageWithImage:image scaledToSize:CGSizeMake(width, height)];
        }
    } completionBlock:^{
        [hud removeFromSuperview];
            self.licenseImage = image;
            [picker dismissViewControllerAnimated:YES completion:^{}];
    }];
}
#pragma mark - UISheetViewDelegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0: {
                    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                } break;
                    
                case 1: {
                    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                } break;
                case 2:
                    return;
                default:
                    return;
            }
        } else {
            if (buttonIndex == 0 ) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else {
                return;
            }
        }
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
}

#pragma mark - Event response
- (void)addLicensePhoto:(id)senser
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self.view];
}
#pragma mark - Private methods

#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.view endEditing:YES];
    BusinessRegisterThirdViewController *registerThirdVC = [[BusinessRegisterThirdViewController alloc] init];
    [self.navigationController pushViewController:registerThirdVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    TopRedView *redView = [[TopRedView alloc] init];
    redView.index = 2;
    [self.view addSubview:redView];
    
    _licenseImageView = [[UIImageView alloc] initWithImage:CCImageNamed(@"yt_register_licenseImage.png")];
    [self.view addSubview:_licenseImageView];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_uploadImage.png"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(addLicensePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    UILabel *photoLabel = [[UILabel alloc] init];
    photoLabel.font = [UIFont systemFontOfSize:20];
    photoLabel.textColor = [UIColor whiteColor];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.numberOfLines = 1;
    photoLabel.text = @"上传营业执照";
    [self.view addSubview:photoLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 1;
    messageLabel.text = @"照片只用于对商户资质的审核,要求照片清晰完整";
    [self.view addSubview:messageLabel];

    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(10);
    }];
    [_licenseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(redView.bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(225);
    }];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_licenseImageView).offset(-20);
        make.centerX.mas_equalTo(_licenseImageView);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(photoBtn.bottom).offset(10);
    }];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(_licenseImageView.bottom).offset(12);
    }];
}
#pragma mark - Getters & Setters
- (void)setLicenseImage:(UIImage *)licenseImage
{
    _licenseImage = licenseImage;
    _licenseImageView.image = licenseImage;
    
}
- (UIImagePickerController *)imagePicker
{
    if(!_imagePicker){
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
