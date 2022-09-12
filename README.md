# GameOfThrones
This repository contains an iOS application that shows data from the Game Of Thrones universe.

Application fetches data from  [https://androidtestmobgen.docs.apiary.io ]() API.

The application has 4 scenes; 

* Splash Scene
 -	Fetches categories and stores them on the App.
* Categories
  - Shows category list to the user. Users can select any category to see related items.
* Items
 - Shows item list to the user. Items can be Books, Houses, and Characters. User can select an item to see it's details
* Details. 
 - Shows all fetched data for the selected item.

### Preview: 
![](https://media.giphy.com/media/8IvKCpzm7ohdVVKEa2/giphy.gif)


## Application Structure

The app has 4 basic structures. Scenes, Network layer, Persistency, and Utility files. The application was implemented using the Protocol Design Oriented approach with VIPER architecture.


### Scenes

Scenes include VIPER scenes as the name implies. Wireframes packages all VIPER flow in it. When View Controller initiated, Wireframes also initiated required Presenters and Interactors. All modules have protocols as Protocol Oriented Design suggests.

### Network Layer

Using the network layer the application can fetch data from API. On top of the network layer, we have ServiceProvider. Using ServiceProvider we can call services like CategoriesServices or GOTServices. We can have more services in the future and all of them can be called from ServiceProvider.


You can see an example API call below;

```swift
var serviceProvider: ServiceProvider<CategoriesSevice> = ServiceProvider<CategoriesSevice> = ServiceProvider<CategoriesSevice>()

serviceProvider.request(service: .categories, decodeType: CategoriesResponse.self) {
  [weak self] result in
  guard let self = self else { return }
  switch result {
  case .success(let response):
    Logger.log.verbose("Categories fetched successfully, categories:", context: response)
    completion(.success(itemArray))
  case .failure(let err):
    Logger.log.error("Failed to fetch categories, error:", context: err)
    completion(.failure(err))
  }
}

```

### Persistency Layer

Using Persistency Layer the application can store fetched data in its Database. Game of Thrones application uses Core Data to store data on the database. 

On top of the Persistency Layer, we have CategoryStore, it is managing the category entity on Core Data. Using CategoryStore we can save and get categories from the database. 

CategoryStore uses CoreDataStack to interact with Core Data and does desired database actions. 

Sample usage of persistency layer;


```swift
let coreDataStack: CoreDataStack = CoreDataStack()
let categoryStore = CategoryStore(
  managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)

let categoryItems: [CategoryItem] = [
  CategoryItem(name: "Books", type: 1),
  CategoryItem(name: "Houses", type: 2),
  CategoryItem(name: "Charachters", type: 2),
]

categoryStore.saveCategories(categories: categoryItems)

```
**Note:** CoreDataStack is passed to CategoryStore with a parameter. Which allows us to inject dependencies on unit tests.

### Utility Layer
This layer has common utility functions and extensions. Also, Logger is in this layer. 