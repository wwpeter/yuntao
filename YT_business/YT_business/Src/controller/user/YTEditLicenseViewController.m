#import "YTEditLicenseViewController.h"
#import "UIImage+HBClass.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"
#import "UIAlertView+TTBlock.h"
#import "YTLicenseImgModel.h"

@interface YTEditLicenseViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UIImageView *licenseImageView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *licenseImage;

@end

@implementation YTEditLicenseViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"营业执照";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    if (parserObject.success) {
        YTLicenseImgModel *licenseImgModel = (YTLicenseImgModel *)parserObject;
        [YTUsr usr].shop.code = licenseImgModel.licenseImg.url;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"营业执照修改成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
        wSelf(wSelf);
        [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
            __strong __typeof(wSelf) strongSelf = wSelf;
            if (buttonIndex == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
        [alert show];
       
    } else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}
#pragma mark - imagePicker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:picker.view];
    hud.labelText = @"正在处理图片...";
    [picker.view addSubview:hud];
    __block UIImage *image = info[UIImagePickerControllerOriginalImage];
    [hud showAnimated:YES whileExecutingBlock:^{
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        image = [image imageScaledWithMaxWidth:kDeviceCurrentWidth];
    } completionBlock:^{
        [hud removeFromSuperview];
        self.licenseImage = image;
        [picker dismissViewControllerAnimated:YES completion:NULL];
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

#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender {
    NSDictionary *licenseImg = @{@"licenseImg":UIImageJPEGRepresentation(self.licenseImage, 0.5)};
    self.requestParas = @{postingDataKey:@[licenseImg],
                          loadingKey : @(YES)};
    self.requestURL = updateLicenseImgURL;
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    _licenseImageView = [[UIImageView alloc] init];
    _licenseImageView.clipsToBounds = YES;
    _licenseImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_licenseImageView];
    [_licenseImageView sd_setImageWithURL:[NSURL URLWithString:[YTUsr usr].shop.code] placeholderImage:CCImageNamed(@"yt_register_licenseImage.png")];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_uploadImage.png"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(addLicensePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    UILabel *photoLabel = [[UILabel alloc] init];
    photoLabel.font = [UIFont systemFontOfSize:20];
    photoLabel.textColor = [UIColor whiteColor];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.numberOfLines = 1;
    photoLabel.text = @"更改营业执照";
    [self.view addSubview:photoLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 1;
    messageLabel.text = @"照片只用于对商户资质的审核,要求照片清晰完整";
    [self.view addSubview:messageLabel];
    
    [_licenseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
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
    if (licenseImage) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}
- (UIImagePickerController *)imagePicker
{
    if(!_imagePicker){
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

@end
