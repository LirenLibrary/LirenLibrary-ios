//
//  BookScanListViewControllerTests.m
//  Liren-ios
//
//  Created by Yan on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "BookScanListViewControllerTests.h"

@implementation BookScanListViewControllerTests

- (void)setUp
{
    [super setUp];
    
    if (self.bookScanListViewController==nil) {
        BookScanListViewController *tmpBookScanListView = [[BookScanListViewController alloc]initWithNibName:@"BookScanListViewController" bundle:nil];
        self.bookScanListViewController = tmpBookScanListView;
        [tmpBookScanListView release];
        [self.bookScanListViewController viewDidLoad];
    }
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void) testShouldAddBookToList{
    Book *book = [self buildBookObject:@"9787111352211" bookname:nil];
    [self.bookScanListViewController addBook:book];
    [book release];
    
}

- (void) testShouldNotAddSameBookWithSameSNToList{
    Book *book = [self buildBookObject:@"9787111352211" bookname:nil];
    [self.bookScanListViewController addBook:book];
    [book release];
    Book *book2 = [self buildBookObject:@"9787111352211" bookname:nil];
    [self.bookScanListViewController addBook:book2];
    [book release];
}


- (void) testShouldDownloadFoundBookNameFromDouban{
    Book *book = [self buildBookObject:@"9787564129651" bookname:nil];
    [self.bookScanListViewController getBookDetail:book];
    //STAssertNotNil(book.bookName, @"Did not find the book Name");
    [book release];
}

- (void) testShouldInitEmptyBookListWhenViewControllerCreated{
    STAssertNotNil(self.bookScanListViewController.bookList, @"Havent init Book List Array");
    STAssertEquals([self.bookScanListViewController.bookList count],(NSUInteger)0,@"Book List must be init as empty Array List");
}

- (Book *) buildBookObject:(NSString *) sn bookname:(NSString *) bookname{
    Book *book = [[Book alloc]init];
    [book setBookName:bookname];
    [book setBookSN:sn];
    return book;
}

-(void)testShouldUpdateBookInfoWhenReturnValidResponse{
    Book *book=[self buildBookObject:@"" bookname:@""];
    NSString *response=@"{\"rating\":{\"max\":10,\"numRaters\":46,\"average\":\"7.7\",\"min\":0},\"subtitle\":\"超媒体和系统架构\",\"pubdate\":\"2011-10\",\"image\":\"http://img3.douban.com/mpic/s6946100.jpg\",\"binding\":\"\",\"images\":{\"small\":\"http://img3.douban.com/spic/s6946100.jpg\",\"large\":\"http://img3.douban.com/lpic/s6946100.jpg\",\"medium\":\"http://img3.douban.com/mpic/s6946100.jpg\"},\"alt\":\"http://book.douban.com/subject/6854551/\",\"id\":\"6854551\",\"title\":\"REST实战\",\"author_intro\":\"JimcWebber, ThoughtWorks公司的一位技术主管, 工作于可信赖的分布式系统.nSavascParastatidis, 微软公司的一位架构师, 工作于大规模的数据密集型和计算密集型应用.nIancRobinson, ThoughtWorks公司的首席咨询顾问, 帮助客户从奠基阶段到运营阶段创建可持续的面向服务开发能力.\",\"tags\":[{\"count\":137,\"name\":\"REST\",\"title\":\"REST\"},{\"count\":57,\"name\":\"Web开发\",\"title\":\"Web开发\"},{\"count\":40,\"name\":\"互联网\",\"title\":\"互联网\"},{\"count\":39,\"name\":\"架构\",\"title\":\"架构\"},{\"count\":19,\"name\":\"软件开发\",\"title\":\"软件开发\"},{\"count\":17,\"name\":\"REST实战\",\"title\":\"REST实战\"},{\"count\":16,\"name\":\"软件架构\",\"title\":\"软件架构\"},{\"count\":11,\"name\":\"Web\",\"title\":\"Web\"}],\"origin_title\":\"REST in Practice\",\"price\":\"78.00元\",\"translator\":[\"李锟\",\"俞黎敏\",\"马钧\",\"崔毅\"],\"pages\":\"388\",\"publisher\":\"东南大学出版社\",\"isbn10\":\"7564129654\",\"isbn13\":\"9787564129651\",\"alt_title\":\"REST in Practice\",\"url\":\"http://api.douban.com/v2/book/6854551\",\"author\":[\"Jim Webber\",\"Savas Parastatidis\",\"Ian Robinson\"],\"summary\":\"为何典型的企业项目无法像你为web所开发的项目那样运行得如此平滑？对于建造分布式和企业级的应用来说，rest架构风格真的提供了一个可行的替代选择吗？n在这本富有洞察力的书中，三位soa专家对于rest进行了讲求实际的解释，并且通过将web的指导原理应用到普通的企业计算问题中，向你展示了如何开发简单的、优雅的分布式超媒体系统。你将会学习到很多技术，并且随着一家典型的公司从最初的小企业逐渐成长为全球化的企业，使用这些web技术和模式来解决这家公司在成长过程中产生的各种需求。n为了应用集成而学习基本的web技术n使用http和web的基础架构来建造可伸缩的、具有容错性的企业应用n发现创建、读取、更新、删除（crud）模式，以便操作资源n建造rest风格的服务，在其中使用超媒体来为状态迁移建模并描述业务协议n学习如何使得基于web的解决方案变得安全和可互操作n使用atom联合格式为事件驱动的计算扩展集成模式，并且使用atompub来实现多方集成n理解语义网将会如何影响系统的设计\"}";
    NSData *data=[response dataUsingEncoding:NSUTF8StringEncoding];
    [self.bookScanListViewController getBookDetailCallback:nil withData:data withBook:book];
    
    STAssertTrue([book.bookName isEqualToString:@"REST实战"], @"The book name should be REST实战");
}

@end
