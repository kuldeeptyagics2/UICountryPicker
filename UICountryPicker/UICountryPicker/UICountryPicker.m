//
//  UICountryPicker.m
//  
//
//  Created by Kuldeep Tyagi on 17/01/18.
//

#import "UICountryPicker.h"

#define KCellId             @"countryCellId"
#define KTagCountryCodeLbl  673

@interface UICountryPicker () <UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy)         CountryPickerCompletionHandler  handlerBlock;
@property (nonatomic, strong)       NSArray                         *tableViewDatasource;
@property (nonatomic, strong)       NSArray                         *datasource;
@property (strong, nonatomic)       UISearchController              *searchController;
@end

@implementation UICountryPicker

#pragma mark - Show Country picker
+(instancetype) showCountryPickerFromViewController:(UIViewController *) parentViewController
                                              handler:(CountryPickerCompletionHandler)handler  {
    @autoreleasepool    {
        if(parentViewController)    {
            UICountryPicker *countryPicker = [[UICountryPicker alloc] initWithHandler:handler];
            
            /**create a nav controller that helps to present picker modelly*/
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:countryPicker];
            
            [parentViewController presentViewController:navController
                                               animated:YES
                                             completion:nil];
            
            return countryPicker;
        }
    }
    return nil;
}

#pragma mark - Instance Methods
#pragma mark - VC Life Cycle Methods
-(instancetype) initWithHandler:(CountryPickerCompletionHandler) handler  {
    if(self = [super init]) {
        self.handlerBlock = handler;
        self.title = @"Choose Country Code";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Datasource and table view data source
    self.datasource             = [self setupDatasource];
    self.tableViewDatasource    = self.datasource;
    
    //Setup Navigation Bar
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                 target:self
                                                                                 action:@selector(hideCountryPicker)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    //Setup Searchbar controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate                                  = self;
    self.searchController.searchResultsUpdater                      = self;
    self.searchController.dimsBackgroundDuringPresentation          = NO;
    self.searchController.hidesNavigationBarDuringPresentation      = NO;
    self.tableView.tableHeaderView                                  = self.searchController.searchBar;
    self.definesPresentationContext                                 = YES;
    self.searchController.searchBar.searchBarStyle                  = UISearchBarStyleMinimal;
}

-(void) viewWillDisappear:(BOOL)animated    {
    [super viewWillDisappear:animated];
    
    //UISearchController seems to hang around even when you navigate to other scenes in your app.
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
}

-(void) dealloc {
    self.handlerBlock               = nil;
    self.searchController           = nil;
    self.tableViewDatasource        = nil;
    self.datasource                 = nil;
    
}

/**Hide country picker*/
-(void) hideCountryPicker   {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewDatasource count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:KCellId];
    if(!cell)   {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KCellId];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        /**Create label to show country code*/
        CGRect codeLblFrame             = CGRectMake(cell.frame.size.width - 10, 15, 60, 22);
        UILabel *countryCodeLbl         = [[UILabel alloc] initWithFrame: codeLblFrame];
        countryCodeLbl.font             = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        countryCodeLbl.textAlignment    = NSTextAlignmentRight;
        countryCodeLbl.textColor        = [UIColor colorWithRed:0.1765 green:0.4549 blue:1.0000 alpha:1.0];
        countryCodeLbl.tag              = KTagCountryCodeLbl;
        [cell addSubview:countryCodeLbl];
    }
    
    __weak UILabel *CodeLbl = [cell viewWithTag:KTagCountryCodeLbl];
    
    __weak NSDictionary *countryDict = [self.tableViewDatasource objectAtIndex:indexPath.row];
    NSString *imagePath     = [NSString stringWithFormat:@"CountryPicker.bundle/%@", [countryDict objectForKey:@"code"]];
    UIImage *image          = [UIImage imageNamed:imagePath];
    
    cell.imageView.image    = image;
    cell.textLabel.text     = [countryDict objectForKey:@"name"];
    CodeLbl.text            = [countryDict valueForKey:@"dial_code"];
    
    return cell;
}

#pragma mark Tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath   {
    if(self.handlerBlock)   {
        __weak NSDictionary *countryDict = [self.tableViewDatasource objectAtIndex:indexPath.row];
        
        self.handlerBlock([countryDict objectForKey:@"name"],
                          [countryDict objectForKey:@"code"],
                          [countryDict valueForKey:@"dial_code"]);
        
        countryDict = nil;
        
        [self hideCountryPicker];
    }
}

#pragma mark - UISearchController Delegates;
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController   {
    NSString *strippedString = [searchController.searchBar.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
    if(strippedString && strippedString.length > 0)  {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name CONTAINS[c] %@)", strippedString];
        self.tableViewDatasource = [self.datasource filteredArrayUsingPredicate:pred];
        [self.tableView reloadData];
    }
    else    {
        self.tableViewDatasource = self.datasource;
        [self.tableView reloadData];
    }
}

- (void)willDismissSearchController:(UISearchController *)searchController  {
    self.tableViewDatasource = self.datasource;
}

- (void)didDismissSearchController:(UISearchController *)searchController   {
    [self.tableView reloadData];
}

#pragma mark - setup Data Source
-(NSArray *) setupDatasource {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if(localError)
        return nil;

    return parsedObject;
}
@end
