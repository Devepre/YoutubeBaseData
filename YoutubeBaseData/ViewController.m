#import "ViewController.h"
#import "VideoManager.h"
#import "Video.h"
#import "VideoViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *ytVideos;
@property (assign) NSString *searchQuestion;

@end

@implementation ViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.ytVideos = [[NSMutableArray alloc] init];
    [self performYTTask];
}

- (void)performYTTask {
    VideoManager *videoManager = [[VideoManager alloc] init];
    
    [videoManager getVideosFor:self.searchQuestion andChannelID:nil
                 andMaxResults:20
               completionBlock:^(NSMutableArray *videoList) {
                   NSSortDescriptor *sortingDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate"
                                                                                     ascending:NO];
                   self.ytVideos = [[videoList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortingDescriptor]] mutableCopy];
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       NSLog(@"Reload sections");
                       [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                   });
               }];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ytVideos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UILabel *videoDescriptionLabel = (UILabel *)[cell viewWithTag:145];
    videoDescriptionLabel.text = [[self.ytVideos objectAtIndex:indexPath.row] videoDescription];
    
    UIImageView *thumbnailImage = [cell viewWithTag:144];
    UIImage *image = [[self.ytVideos objectAtIndex:indexPath.row] thumbnailImage];
    thumbnailImage.image = image;
    
    return cell;
}

#pragma mark <UITextFieldDelegate>
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *str = textField.text;
    self.searchQuestion = str;
    [self performYTTask];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVideoSegue"]) {
        if ([sender isKindOfClass:[UICollectionViewCell class]]) {
            UICollectionViewCell *cell = (UICollectionViewCell *)sender;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            if (indexPath) {
                NSInteger index = indexPath.row;
                VideoViewController *destinationController = (VideoViewController *)[segue destinationViewController];
                destinationController.video = [self.ytVideos objectAtIndex:index];
            }
        }
    }
}

@end
