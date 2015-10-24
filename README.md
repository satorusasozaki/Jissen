# Jissen
Twitter API training assignment by [Hiroki](https://github.com/hirokihori)

How the app looks like does not matter. Care about coding style and things like class structures. It is also recommended to use helper methods using Util class, when needed. The working log might be on [my blog](http://satorusasozaki.com/)

### 1.1 Twitter API
Make an app using [Twitter API](https://dev.twitter.com/overview/documentation)

* Search tweets by using Twitter API
* Use `UISearchBar`
* Display results on a table view
* Use `RefreshControl` to refresh the table view
* Display **5 letters** from each tweet and "..." on each cell
* Display a tweet detail when the cell gets clicked (push or modal)
* Nothing happens when a cell with less than 5 letters gets clicked
* Fetch **20 tweets** once

### 1.2 TableView Infinite scrolling
* Add an **infinite scrolling function** to the table view

### 1.3 NSUserDefaults

* Store searched texts using `NSUserDefaults`
* Add a `NavigationBar` with a button in the upper right corner
* Display the search history view by clicking the button (modal or push)
* Display the word searched by an user on each cell in the view

### 1.4 Core Data

* Replace the search history part with **Core Data**
* Display the searched text and the date when it was searched

### 1.5 Cocoapods

* Use **Cocoapods** to the app
* Decide which pod to use. e.g. `MBProgressHUD`, `PureLayout`, etc...

### 1.6 TestFlight

* Use **TestFlight** to distribute the app to others

### 1.7 AutoLayout

* Use **AutoLayout** so that you don't have to write like `CGRectMake()`
* Write code which does not depend on a device
