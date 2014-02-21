//
//  TTHAddressSearchViewController.m
//  TimeToHome
//
//  Created by Maxwell Elliott on 12/27/13.
//
//

#import "TTHAddressSearchViewController.h"
#import "SPGooglePlacesAutocomplete.h"
#import "Location.h"

@interface TTHAddressSearchViewController ()

@end

@implementation TTHAddressSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!searchQuery) {
      searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyD8XVQrTkPYFBZkJNCFgsd_QYe9M2WCI8M"];
    }
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return autocompleteResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)saveHomeAddressAndRefreshTimes:(NSIndexPath *)indexPath
{
    Location *homeLocation = [Location grabUserHomeLocation];
    if (!homeLocation) {
        homeLocation = [[Location alloc] initWithEntity:[Location entity] insertIntoManagedObjectContext:[Location mainQueueContext]];
    }
    [homeLocation setIsHome: [[NSNumber alloc] initWithBool:YES]];
    SPGooglePlacesAutocompletePlace *place = autocompleteResults[indexPath.row];
    [homeLocation setAddress:place.name];
    [homeLocation save];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{
        SEL updateTImesForHomeAddressChangeSelector = NSSelectorFromString(@"updateTimesForHomeAddressChange:");
        [[self presentingViewController] performSelectorInBackground:updateTImesForHomeAddressChangeSelector withObject:nil];
    }];
}

- (void)saveWorkAddressAndRefreshTimes:(NSIndexPath *)indexPath
{
    Location *workLocation = [Location grabUserWorkLocation];
    if (!workLocation) {
        workLocation = [[Location alloc] initWithEntity:[Location entity] insertIntoManagedObjectContext:[Location mainQueueContext]];
    }
    [workLocation setIsWork: [[NSNumber alloc] initWithBool:YES]];
    SPGooglePlacesAutocompletePlace *place = autocompleteResults[indexPath.row];
    [workLocation setAddress:place.name];
    [workLocation save];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{
        SEL updateTimesForWorkAddressChangeSelector = NSSelectorFromString(@"updateTimesForWorkAddressChange:");
        [[self presentingViewController] performSelectorInBackground:updateTimesForWorkAddressChangeSelector withObject:nil];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.segueIdentifier isEqualToString:@"homeAddressSearchSegue"]) {
        [self saveHomeAddressAndRefreshTimes:indexPath];
    } else {
        [self saveWorkAddressAndRefreshTimes:indexPath];
    }
}


- (void)handleSearchForSearchString:(NSString *)searchString
{
    searchQuery.location = self.currentUserLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not contact Google! Please try again."
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

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForSearchString:searchString];
    return YES;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
