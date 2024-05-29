#import "HelpTableViewCell.h"

@interface HelpTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *helpItemImageView;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UILabel *helpNameLabel;
@property (weak, nonatomic) IBOutlet HelpItem *helpItem;

@end

@implementation HelpTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) configureCellWith:(HelpItem *) helpItem {
    self.helpItem = helpItem;
    self.helpButton.layer.cornerRadius = self.helpButton.frame.size.height / 2;
    [self.helpItemImageView setImage: [UIImage imageNamed:helpItem.imageName]];
    [self.helpButton setTitle:helpItem.actionButtonName forState:UIControlStateNormal];
    self.helpNameLabel.text = helpItem.name;
}

- (IBAction)helpButtonTapped:(id)sender {
    [self.delegate helpButtonTapped:self.helpItem];
}

@end
