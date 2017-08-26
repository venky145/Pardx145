//
//  PendingCell.m
//  Parodize
//
//  Created by VenkateshX Mandapati on 24/07/16.
//  Copyright © 2016 Parodize. All rights reserved.
//

#import "PendingCell.h"

@implementation PendingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:17];
    
        _mockImage = [[UIImageView alloc]init];
        _notifyButton = [[UIButton alloc]init];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_mockImage];
        [self.contentView addSubview:_notifyButton];
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    _mockImage.center=self.contentView.center;
    frame= CGRectMake(boundsX+5 ,7, 30, 30);
    _mockImage.frame = frame;
    
    _nameLabel.frame= CGRectMake(boundsX+40 ,2, contentRect.size.width - 90, 40);
    
    _notifyButton.frame= CGRectMake(CGRectGetMaxX(_nameLabel.frame)+5 ,7, 30, 30);
}
@end
