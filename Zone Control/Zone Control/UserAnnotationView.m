//
//  UserAnnotationView.m
//  Zone Control
//
//  Created by Scott Monroe on 4/5/13.
//  Copyright (c) 2013 Scott Monroe. All rights reserved.
//

#import "UserAnnotationView.h"
#import "UserMapItem.h"


static CGFloat kMaxViewWidth = 50.0;

static CGFloat kViewWidth = 30;
static CGFloat kViewLength = 30;

static CGFloat kLeftMargin = 0;
static CGFloat kRightMargin = 0;
static CGFloat kTopMargin = 0;
static CGFloat kBottomMargin = 0;
static CGFloat kRoundBoxLeft = 10.0;

@interface UserAnnotationView ()
@property (nonatomic, strong) UILabel *annotationLabel;
@property (nonatomic, strong) UIImageView *annotationImage;
@end

@implementation UserAnnotationView

// determine the MKAnnotationView based on the annotation info and reuseIdentifier
//
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        
        
        
        // add the annotation's label
        //_annotationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        UserMapItem *mapItem = (UserMapItem *)self.annotation;
        //self.annotationLabel.font = [UIFont systemFontOfSize:9.0];
        //self.annotationLabel.textColor = [UIColor whiteColor];
        //self.annotationLabel.text = mapItem.place;
        [self.annotationLabel sizeToFit];   // get the right vertical size
        
        // compute the optimum width of our annotation, based on the size of our annotation label
        CGFloat optimumWidth = self.annotationLabel.frame.size.width + kRightMargin + kLeftMargin;
        CGRect frame = self.frame;
        if (optimumWidth < kViewWidth)
            frame.size = CGSizeMake(kViewWidth, kViewLength);
        else if (optimumWidth > kMaxViewWidth)
            frame.size = CGSizeMake(kMaxViewWidth, kViewLength);
        else
            frame.size = CGSizeMake(optimumWidth, kViewLength);
        self.frame = frame;
        
        self.annotationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.annotationLabel.backgroundColor = [UIColor clearColor];
        CGRect newFrame = self.annotationLabel.frame;
        newFrame.origin.x = kLeftMargin;
        newFrame.origin.y = kTopMargin;
        newFrame.size.width = self.frame.size.width - kRightMargin - kLeftMargin;
        self.annotationLabel.frame = newFrame;
        [self addSubview:self.annotationLabel];
        
        // add the annotation's image
        // the annotation image snaps to the width and height of this view
        _annotationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:mapItem.imageName]];
        self.annotationImage.contentMode = UIViewContentModeScaleAspectFit;
        self.annotationImage.frame =
        CGRectMake(kLeftMargin,
                   self.annotationLabel.frame.origin.y + self.annotationLabel.frame.size.height + kTopMargin,
                   self.frame.size.width - kRightMargin - kLeftMargin,
                   self.frame.size.height - self.annotationLabel.frame.size.height - kTopMargin*2 - kBottomMargin);
        [self addSubview:self.annotationImage];
    }
    
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UserMapItem *mapItem = (UserMapItem *)self.annotation;
    if (mapItem != nil)
    {
        [[UIColor darkGrayColor] setFill];
        
        // draw the pointed shape
        UIBezierPath *pointShape = [UIBezierPath bezierPath];
        [pointShape moveToPoint:CGPointMake(14.0, 0.0)];
        [pointShape addLineToPoint:CGPointMake(0.0, 0.0)];
        [pointShape addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [pointShape fill];
        
        // draw the rounded box
        UIBezierPath *roundedRect =
        [UIBezierPath bezierPathWithRoundedRect:
         CGRectMake(kRoundBoxLeft, 0.0, self.frame.size.width - kRoundBoxLeft, self.frame.size.height) cornerRadius:3.0];
        roundedRect.lineWidth = 2.0;
        [roundedRect fill];
    }
}

@end

