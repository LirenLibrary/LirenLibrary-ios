//
//  BookScanListViewController.m
//  Liren-ios
//
//  Created by Yan on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "BookScanListViewController.h"

#define DOUBAN_ISBN_URL @"http://api.douban.com/v2/book/isbn/"

@interface BookScanListViewController ()

@end

@implementation BookScanListViewController

@synthesize tableView=_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(self.bookList==nil){
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.bookList = tmpArray;   
        [tmpArray release];
    }
    
    if(self.queue==nil){
        NSOperationQueue *q=[[NSOperationQueue alloc] init];
        self.queue=q;
        [q release];
    }
    [self.queue setMaxConcurrentOperationCount:10];    
}

- (Book *) buildBookObject:(NSString *) sn bookname:(NSString *) bookname{
    Book *book = [[Book alloc]init];
    [book setBookName:bookname];
    [book setBookSN:sn];
    return book;
}

- (void)viewDidUnload{
    [self.bookList release];
    [self.queue release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBook:(Book *)book{
    Boolean find = false;
    for (Book *tmp in self.bookList) {
        if([[tmp bookSN] isEqualToString:[book bookSN]]){
            find = true;
            break;
        }
    }
    if(!find){
        [self.bookList addObject:book];
        [self getBookDetail:book];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.bookList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bookIdentifier = @"BookIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookIdentifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookIdentifier];
        [cell autorelease];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[self.bookList objectAtIndex:row]bookName];
    return cell;
}

- (void) getBookDetail:(Book *) book{
    NSURL *bookUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOUBAN_ISBN_URL,book.bookSN]];
    NSLog(@"Started to get book details: %@ ",bookUrl);
    
    NSURLRequest *request=[NSURLRequest requestWithURL:bookUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Get data from douban");
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if([json valueForKey:@"msg"]==nil){
                book.bookName = [json valueForKey:@"subtitle"];
                NSLog(@"Find Book:%@", book.bookName);
            }else{
                book.bookName = @"没找到";
                NSLog(@"Find Book:%@", book.bookName);
            }
            [self.tableView reloadData];
        });
        
    }];
}

@end
