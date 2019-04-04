# FlowState
[![Version](https://img.shields.io/cocoapods/v/FlowState.svg?style=flat)](https://cocoapods.org/pods/FlowState)[![License](https://img.shields.io/cocoapods/l/FlowState.svg?style=flat)](https://cocoapods.org/pods/FlowState)[![Platform](https://img.shields.io/cocoapods/p/FlowState.svg?style=flat)](https://cocoapods.org/pods/FlowState)


`FlowState` is a lightweight framework used for creating swifty, composable Flow Coordinators. FlowState takes a more functional approach to the ViewController/Coordinator pattern. You can think of it as a mutation of the Promise pattern.

FlowState provides a flexible easy to use mechanic that can:

- Remove all business logic from View Controllers
- Make asynchronous requests
- Load data into view controllers without piping references around.
- Helps remove statefulness
- Make A/B testing a flow a breeze
- Make composable, rearrangable flows
- Split up networking / modeling / view logic 

### How does it work?

FlowState has two basic building blocks that go hand-in-hand. The `FlowStep` and the `FlowStepHandler`.  You can think of a `FlowStep` as both a promise and a task factory. The `FlowStepHandler` allows a `FlowStep` to complete, and manages the routing of information.

A `Flow` is made up of a list of `FlowStep` objects. They are linked together in a linked list stack. The first step is started, and once that step is completed by its `FlowStepHandler` the second step is started and so on.

A `FlowStep` can manage a View Controller, or a Network Request, or even a nested Flow. 

Both `FlowStep` and `FlowStepHandler` are generic classes that have two generic types: `Content` and `Result`.  `Content` can be thought of as the input of the step. The `Content` is automatically routed from the step into it's `FlowStepHandler`, which makes it easy to manage data flow. The `Result` can be thought of as the output of a step, this is the information the step is trying to collect before it continues. A step is completed when it is provided with it's `Result`.

#### FlowStep

Let's take a look at this example.

![Example](/IMG/BasicStep.jpg)

This example shows the lifecycle of a single step in a flow. The coordinator starts a `FlowStep`. The step's intent block allocates a `ViewController` which is displayed on screen. The `ViewController` owns a `FlowStepHandler`, which is returned to the `FlowStep` in the intent block.

When the user selects and option the `ViewController` calls `complete(option)` on it's `FlowStepHandler`. The handler then automatically forwards the complete call and the step is completed with the results routed back to the coordinator. The coordinator can do what is wishes with the results and the next step is started with `start()`.

What does this look like in code?


## Example


Lets create a simple flow for collecting some information from a user profile.

First, lets display what information we have by displaying the profile of the user.

A flow step has two main parts, `Content` which defines the content that the step displays and

`Result ` which defines the information that the step collects. Some steps don't collect information,

but instead an interaciton.



This first step will display a user profile view controller. The user profile view controller displays

information from a `UserProfile` struct. The profile view controller wants to refresh its contents

by making a network call to download the profile data when it is displayed. Additionally the

profile view controller has a button that allows the user to update their name.



The profile view controller then has two result actions, download and updateName. Each defined in

an enum `UserProfileAction`.



The profile view controller also has a `FlowStepHandler` that it owns called `results`.

The profile view controller uses the results to get its contents and also tells the intent of any user interaction.





```swift

/// Create a FlowStep that displays the profile view controller.

let displayStep = FlowStep(UserProfile.self, UserProfileAction.self, identifier: "Profile", { (step) in

/// This block is called each time the step begins.

/// Make a new Profile Display VC

let vc = UserProfileViewController()

/// Set the vc on the navigation controller step.

navigationController.setViewControllers([vc], animated: false)

/// Return the View Controller's FlowStepHandler `results`.

return vc.results

})

```



The displayStep has two outcomes, one will show a view controller that will edit the user name,

the other will download the new profile.



Let's create a step for downloading the new profile. This step does not have any content, but the result is

a new `UserProfile` object.



```swift



/// Create a step that downloads the user profile from the internet

let networkStep = FlowStep(Any.self, UserProfile.self, identifier: "User Profile Network", { (step) in



/// Show a loader View Controller

let loader = LoadingModalViewController()

navigationController.present(loader, animated: true, completion: nil)



/// Create step results for this step.

let stepResults = FlowStepHandler(Any.self, UserProfile.self)

/// Make an async network call.

UserProfile.getUser() { (newProfile) in

/// After the download has completed, call completion with the results.

stepResults.complete(newProfile)

}

return stepResults

}) { [unowned displayStep] (step, newProfile) in

if let newProfile = newProfile {

/// Set the new profilew on the display step, which automatically updates it's view controller.

displayStep.content = newProfile

}

/// Dismiss the loading modal.

navigationController.dismiss(animated: true, completion: nil)

}

```



Now lets create a step that allows the user to edit their name.

The EditNameViewController has a content type of a `String` and a result type of a new `String`



```swift

let editNameStep = FlowStep(String.self, String.self, identifier: "Edit Name", { (step) in

let vc = StringEntryViewController()

navigationController.pushViewController(vc, animated: true)

return vc.results

})

```



Next lets create a network call that updates the username and returns the updates User Profile:



```swift



/// Create a step that updates the user profile

let updateNameStep = FlowStep(String.self, UserProfile.self, identifier: "Update Profile Step", { (step) in



/// Show a loader View Controller

let loader = LoadingModalViewController()

navigationController.present(loader, animated: true, completion: nil)



/// Create step results for this step.

let stepResults = FlowStepHandler(Any.self, UserProfile.self)

/// Make an async network call that updates the user profile with the step's content.

UserProfile.updateName(step.content) { (newProfile) in

/// After the download has completed, call completion with the results.

stepResults.complete(newProfile)

}



return stepResults

}) { [unowned displayStep] (step, newProfile) in

if let newProfile = newProfile {

/// Set the new profilew on the display step, which automatically updates it's view controller.

displayStep.content = newProfile

}

/// Dismiss the loading modal.

navigationController.dismiss(animated: true, completion: nil)

/// Optionally you could pop the nav controller here to go back to the profile.

}

```



Now lets link the `editNameStep` to the `updateNameStep`

First we need to add a completion closure to the `editNameStep` which forwards it's results to the  `updateNameStep`.

Then we set the next step of `editNameStep` to be the `updateNameStep`.

```swift

editNameStep.setCompletion { (step, newName) in

guard let newName = newName else {

step.nextStep = nil

return

}

/// Forward the results of this step to the updateNameStep

updateNameStep.content = newName

step.nextStep = updateNameStep

}

```



Finally, now that we have all of our steps created lets set the branching logic on the step that manages the `UserProfileView`.



```swift

/// Set the display step completion block to switch between its results

displayStep.setCompletion { (step, action) in

guard let action = action else { return }

switch action {

case .editProfile:

/// Edit profile was pressed.

editTextStep.content = step.content

step.nextStep = editTextStep

case .downloadProfile:

/// Download profile was pressed.

step.nextStep = fakeNetworkStep

}

}

```



And thats it! You now have a composable flow. If you wanted to reorder the views, or make changes you can easily connect the flow steps in a different order without worrying about jumping into view controller code.





## Example Project

Need more?

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Requirements



## Installation



FlowState is available through [CocoaPods](https://cocoapods.org). To install

it, simply add the following line to your Podfile:



```ruby

pod 'FlowState'

```



## Author



buba447, buba447@gmail.com



## License



FlowState is available under the MIT license. See the LICENSE file for more info.
