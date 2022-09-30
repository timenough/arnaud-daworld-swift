
@interface DotInUIImageView

-(void)colorizeDot:(UIImageView *)theView dotOpacity:(CGFloat)opacity dotSize:(CGFloat)diametre dotColor:(int)color_case strokeSize:(CGFloat)bordure;
-(void)addDotToImageView:(UIImageView *)theView dotOpacity:(CGFloat)opacity dotSize:(CGFloat)diametre dotR:(CGFloat)red1 dotV:(CGFloat)green1 dotB:(CGFloat)blue1 strokeSize:(CGFloat)bordure strokeR:(CGFloat)red2 strokeV:(CGFloat)green2 strokeB:(CGFloat)blue2;

@end