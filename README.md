# Firebase Friend Request System
A very simple demo of how to create a friend system with friend requests in iOS. The project also contains the class FriendSystem, which can help you integrate a friend system into your project quickly and easily.

Here's how it works: Users can send others friend requests. As soon as another accepts a request, they both become friends.

## Usage
The project contains a demo of the system in action, so you should check it out to see how you can use it. To integrate it into your own project, just add the FriendSystem class to your own project. You also need to make sure that you have a simple User model class, or you can use the one in the demo.

This class assumes that you are using the suggested structure for users, in which they exist under a users tree as follows:
```
firebase {
  users {
    generatedUserId {
      email: "userEmail"
      otherProperty: "otherValue"
    }
  }
}
```

Depending on the properties your user has, you should change the `getUser` function and the `User` class to use your own properties. The rest will work without any modification.

The following are the most important functions the class has:

```
func getCurrentUser(completion: (User) -> Void)
func getUser(userID: String, completion: (User) -> Void)

func createAccount(email: String, password: String, completion: (success: Bool) -> Void)
func loginAccount(email: String, password: String, completion: (success: Bool) -> Void)
func logoutAccount()

func sendRequestToUser(userID: String)
func removeFriend(userID: String)
func acceptFriendRequest(userID: String)

var userList: [User]!
func addUserObserver(update: () -> Void)
func removeUserObserver()

var friendList = [User]()
func addFriendObserver(update: () -> Void)
func removeFriendObserver()

var requestList = [User]()
func addRequestObserver(update: () -> Void)
func removeRequestObserver()
```

## Demo
The demo was made with the MVC model, so all of the View Controller classes never have to import Firebase. All the data functions are written in the FriendSystem class, and the View Controller calls them to get access to the data. The demo has a signup/login page, and then another for viewing a list of all users, your friend requests, and your actual friends. You can test it by creating new accounts, sending friend requests to each other, and then accepting them.

## Contribute
Feel free to contribute with your own modifications. I made this very quickly, so it is very simple. If you have any improvements to make, or want to add any extra features, go ahead and make a pull request.
