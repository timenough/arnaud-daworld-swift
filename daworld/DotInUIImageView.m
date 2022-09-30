
#import "DotInUIImageView.h"

@implementation DotInUIImageView

-(void)colorizeDot:(UIImageView *)theView dotOpacity:(CGFloat)opacity dotSize:(CGFloat)diametre dotColor:(int)color_case strokeSize:(CGFloat)bordure{
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat Sred;
    CGFloat Sgreen;
    CGFloat Sblue;
    
    switch(color_case)
    {
        case 0:
            // MARRON FONCE
            red = 34.0/255.0;
            green = 31.0/255.0;
            blue = 26.0/255.0;
                // NOIR
                Sred = 70.0/255.0;
                Sgreen = 60.0/255.0;
                Sblue = 42.0/255.0;
            break;
        case 1:
            // VERT
            red = 98.0/255.0;
            green = 231.0/255.0;
            blue = 80.0/255.0;
                // VERT +FONCE
                Sred = 29.0/255.0;
                Sgreen = 65.0/255.0;
                Sblue = 31.0/255.0;
            break;
        case 2:
            // ROUGE
            red = 221.0/255.0;
            green = 79.0/255.0;
            blue = 74.0/255.0;
                // ROUGE +FONCE
                Sred = 138.0/255.0;
                Sgreen = 55.0/255.0;
                Sblue = 54.0/255.0;
            break;
        default:
            // BLANC
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 255.0/255.0;
                // NOIR
                Sred = 0.0/255.0;
                Sgreen = 0.0/255.0;
                Sblue = 0.0/255.0;
            break;
    }
    
    [self addDotToImageView:theView dotOpacity:opacity dotSize:diametre dotR:red dotV:green dotB:blue strokeSize:bordure strokeR:Sred strokeV:Sgreen strokeB:Sblue];
    
}

-(void)addDotToImageView:(UIImageView *)theView dotOpacity:(CGFloat)opacity dotSize:(CGFloat)diametre dotR:(CGFloat)red1 dotV:(CGFloat)green1 dotB:(CGFloat)blue1 strokeSize:(CGFloat)bordure strokeR:(CGFloat)red2 strokeV:(CGFloat)green2 strokeB:(CGFloat)blue2
{
    
    //// 1 = ON INITIALISE
    UIGraphicsBeginImageContext(theView.frame.size);
    
    //// 2 = ON DESSINE
    CGContextSetBlendMode(          UIGraphicsGetCurrentContext(),kCGBlendModeColorDodge);
    CGContextSetLineCap(            UIGraphicsGetCurrentContext(),kCGLineCapRound);
    CGContextSetLineWidth(          UIGraphicsGetCurrentContext(),bordure);
    CGContextSetRGBFillColor(       UIGraphicsGetCurrentContext(),red1,green1,blue1,opacity);
    CGContextSetRGBStrokeColor(     UIGraphicsGetCurrentContext(),red2,green2,blue2,.2);
    CGContextFillEllipseInRect(     UIGraphicsGetCurrentContext(),CGRectMake(bordure,bordure,diametre,diametre));
    CGContextStrokeEllipseInRect(   UIGraphicsGetCurrentContext(),CGRectMake(bordure,bordure,diametre,diametre));
    CGContextFillPath(              UIGraphicsGetCurrentContext());
    
    //// 3 = ON AFFECTE
    theView.image            = UIGraphicsGetImageFromCurrentImageContext();
    theView.alpha            = opacity;
    UIGraphicsEndImageContext();
    
}

@end