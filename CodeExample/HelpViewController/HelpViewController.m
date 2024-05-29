#import "HelpViewController.h"
#import "HelpTableViewCell.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "HelpItem.h"
#import "GeneralService.h"
#import "LogbookViewController.h"

@interface HelpViewController () <UITableViewDelegate, UITableViewDataSource, HelpTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (weak, nonatomic) IBOutlet UIImageView            *avatarImg;
@property (weak, nonatomic) IBOutlet UIView                 *mainBackground;
@property (weak, nonatomic) IBOutlet UIButton               *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton               *settingsBtn;
@property (weak, nonatomic) IBOutlet UILabel                *userNameLbl;

@property (strong, nonatomic) TelematicsAppModel            *appModel;
@property (strong, nonatomic) NSArray<HelpItem*>             *helpItemsArray;

@end

@implementation HelpViewController

#pragma mark - ViewController's lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:[[Configurator sharedInstance].helpTabBarNumber intValue]];
    [tabBarItem3 setImage:[[UIImage imageNamed:@"help_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"help_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem3 setTitle:localizeString(@"support_title")];
    
    [self setupAppModel];
    [self generateDataSource];
    
    [self setupUserInfoAppearance];
    [self setupMainBackgroundAppearance];
    [self setupChatButtonAppearance];
    [self setupSettingsuttonAppearance];
    [self.tableView reloadData];
    [self.tableView setScrollEnabled:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self displayUserNavigationBarInfo];
    [self setupNavigationControllerAppearance];
}

#pragma mark - Appearance
- (void)setupUserInfoAppearance {
    UITapGestureRecognizer *avaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaTapDetect:)];
    self.avatarImg.userInteractionEnabled = YES;
    [self.avatarImg addGestureRecognizer:avaTap];
}

- (void)setupMainBackgroundAppearance {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    [[UIImage imageNamed:[Configurator sharedInstance].mainBackgroundImg] drawInRect:self.view.bounds];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
    self.mainBackground.layer.cornerRadius = 16;
    self.mainBackground.layer.masksToBounds = NO;
    self.mainBackground.layer.shadowOffset = CGSizeMake(0, 0);
    self.mainBackground.layer.shadowRadius = 2;
    self.mainBackground.layer.shadowOpacity = 0.1;
}

- (void)setupNavigationControllerAppearance {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Setup Models
- (void) setupAppModel {
    //INITIALIZE USER APP MODEL
    self.appModel = [TelematicsAppModel MR_findFirstByAttribute:@"current_user" withValue:@1];
}

- (void) generateDataSource {
    HelpItem *roadsideAssistantItem = [[HelpItem alloc] initWithType:RoadsideAssistance
                                                                name:@"Roadside\nAssistance"
                                                           imageName:@"roadsideAssistance"
                                                    actionButtonName:@"Call"
                                                              action:self.appModel.roadsideAssistPhone]
    ;
    HelpItem *emergencyServicesItem = [[HelpItem alloc] initWithType:EmergencyServices
                                                                name:@"Emergency\nServices"
                                                           imageName:@"emergencyServices"
                                                    actionButtonName:@"Call"
                                                              action:self.appModel.emergencyNumber];
    HelpItem *customerSupportItem = [[HelpItem alloc] initWithType:CustomerSupport
                                                                name:@"Customer\nSupport"
                                                           imageName:@"customerSupport"
                                                    actionButtonName:@"Chat"
                                                              action:self.appModel.customerSupportLink];
    HelpItem *makeAClaimItem = [[HelpItem alloc] initWithType:MakeAClaim
                                                                name:@"Make\na Claim"
                                                           imageName:@"makeAClaim"
                                                    actionButtonName:@"Submit"
                                                              action:self.appModel.makeAClaimLink];
    HelpItem *myPolicyDocumentsItem = [[HelpItem alloc] initWithType:MyPolicyDocuments
                                                                name:@"My Policy\nDocuments"
                                                           imageName:@"myPolicyDocuments"
                                                    actionButtonName:@"Log in"
                                                              action:self.appModel.myPolicyDocumentsLink];
    HelpItem *logbookItem = [[HelpItem alloc] initWithType:Logbook
                                                      name:@"Driver Logbook"
                                                 imageName:@"driverlogbook"
                                          actionButtonName:@"Request"
                                                    action:@""];
    self.helpItemsArray = [NSArray arrayWithObjects:roadsideAssistantItem,
                                                    emergencyServicesItem,
                                                    customerSupportItem,
                                                    makeAClaimItem,
                                                    myPolicyDocumentsItem,
                                                    logbookItem, nil];
}

- (void)setupChatButtonAppearance {
    self.chatBtn.hidden = NO;
}

- (void)setupSettingsuttonAppearance {
    self.settingsBtn.hidden = NO;
}

#pragma mark - UserInfo
- (void)displayUserNavigationBarInfo {
    self.userNameLbl.text = self.appModel.userFullName ? self.appModel.userFullName : @"";
    self.avatarImg.layer.cornerRadius = self.avatarImg.frame.size.width / 2.0;
    self.avatarImg.layer.masksToBounds = YES;
    self.avatarImg.contentMode = UIViewContentModeScaleAspectFill;
    if (self.appModel.userPhotoData != nil) {
        self.avatarImg.image = [UIImage imageWithData:self.appModel.userPhotoData];
    }
}

- (IBAction)avaTapDetect:(id)sender {
    ProfileViewController *profileVC = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateInitialViewController];
    profileVC.hideBackButton = YES;
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:profileVC animated:NO completion:nil];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.helpItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpTableViewCell"];
    [cell configureCellWith:self.helpItemsArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat height = cell.frame.size.height;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = tableView.frame;
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
    
    headerView.backgroundColor = [UIColor colorWithRed:222/255 green:224/255 blue:228/255 alpha:0.9];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, frame.size.width - 100, 25)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"Customer Support";
    [title setFont:[Font heavy24]];
    [title setTextColor:UIColor.darkGrayColor];
    [headerView addSubview:title];
    
    return headerView;
}

- (void)helpButtonTapped:(HelpItem *) helpItem {
    switch (helpItem.helpItemType) {
        case CustomerSupport:
            [self chatWithUser:self.appModel];
            break;
        case MakeAClaim:
            [self openLink:helpItem.action];
            break;
        case MyPolicyDocuments:
            [self openLink:helpItem.action];
            break;
        case RoadsideAssistance:
            [self callBy:helpItem.action];
            break;
        case EmergencyServices:
            [self callBy:helpItem.action];
            break;
        case Logbook:
            [self openLogbookVC];
            break;

    }
}

#pragma mark - Navigation
- (IBAction)chatOpenAction:(id)sender {
    [self chatWithUser:self.appModel];
}

- (IBAction)settingsBtnAction:(id)sender {
    SettingsViewController *settingsVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateInitialViewController];
    [self presentViewController:settingsVC animated:YES completion:nil];
}

- (void)becomeCustomerButtonTapped:(UIButton*)sender {
    [self chatWithUser:self.appModel];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    //[self dismissViewControllerAnimated:true completion:nil];
}

- (void) openLink: (NSString*)link {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", link]];
    if (url && url.scheme && url.host) {
        SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
        svc.delegate = self;
        svc.preferredControlTintColor = [Color officialMainAppColor];
        [self presentViewController:svc animated:YES completion:nil];
    } else {
        [GeneralService alert:@"Wrong URL" title:@"Sorry"];
    }
}

- (void) callBy: (NSString*)phone {
    if (phone == nil) {
        return;
    }
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phone];
    NSURL *phoneURL = [NSURL URLWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:nil];
}

- (void)openLogbookVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Help" bundle:nil];
    LogbookViewController *logbookVC = [storyboard instantiateViewControllerWithIdentifier:@"LogbookViewController"];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@""
                                       style:UIBarButtonItemStylePlain
                                       target:nil
                                       action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self.navigationController pushViewController:logbookVC animated:YES];
}

@end
