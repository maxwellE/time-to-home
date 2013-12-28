//
//  TTHAddressSearchViewController.m
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/27/13.
//
//

#import "TTHAddressSearchViewController.h"
#import "SPGooglePlacesAutocomplete.h"

@interface TTHAddressSearchViewController ()

@end

@implementation TTHAddressSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!searchQuery) {
      // NEED TO CHANGE THIS KEY
      searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAFsaDn7vyI8pS53zBgYRxu0HfRwYqH-9E"];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return autocompleteResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"autocompleteLocation";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"autocompleteLocation"];
    }
    SPGooglePlacesAutocompletePlace *place = autocompleteResults[indexPath.row];
    [[cell textLabel] setText:place.name];
    return cell;
}

- (void)handleSearchForSearchString:(NSString *)searchString
{
    searchQuery.location = self.currentUserLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            autocompleteResults = places;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForSearchString:searchString];
    return YES;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
