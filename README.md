#  SweatSketch: Sketch, Sweat, and Succeed
The “SweatSketch: Sketch, Sweat, and Succeed” is a lightweight app for taking gym notes regarding the workout program and weight-lifting results.

![UI_demo](https://github.com/aibar-pro/SweatSketch_Public/blob/b7a0a88470c2ad98e361dcafae8e0081bdbf6878/SweatSketch/Resources/AppDemos/SweatSketch_Demo_ActiveWorkout.gif)

I haven’t conducted any marketing research since this is a playground project. It covers only my needs as a sole user. I started this project in 2021 with an iOS14 target. When I resurrected it in early 2024, I decided not to update the target, whereas, in a corporate environment, you have to support the largest number of devices possible.

A workout contains exercises, which consist of actions. Actions have a type: sets-n-reps and timed. Sets-n-reps actions later will include weight type information: dumbbell, barbell, machine, body. The weight type input will streamline the result logging flow.

The app supports workout plans like the following one. 

> 10 min treadmill run
> 1x12, 1x10, 1x8 benchpress
> 3x12 incline dumbbell press
> (superset, 3 times) 3 min treadmill + 12 deadlift + max lat pulldowns + 5 burpees 

The user can add rest times between actions and exercises. It can be either default for the whole workout and automatically applied between each exercise and action or customized for each exercise.

Once the user has planned the workout, they press the big ‘Go’ button, and the app switches to workout executing mode. That mode allows ticking exercise actions as done, observing the rest or timed action timer, and, in future updates, logging lifted weights by their type. 
Active workout action is displayed on Dynamic Island and as a LiveActivity. Ultimately, I’ll add an Apple Watch part to manage the active workout. 

After finishing the workout, users will be able to check the fitness dashboard. It’s up in the air, but each entity has its UUID, allowing us to gather the required data.

## Technical Stack
- SwiftUI for the UI views layer with UIKit-based navigation
- CoreData and UserDefaults
- Combine
- ActivityKit

## App Navigation and Architecture
The application follows the MVVM-C approach except for omitting dedicated Model files duplicating CoreData entities.
A coordinator pattern is implemented for navigation between SwiftUI views. SwiftUI’s @app calls a UIViewControllerRepresentable of UIKit’s application root UINavigationController. ‘Application Coordinator’ appends child coordinators for every app screen. Using UIHostingController, I put SwiftUI views into stacks of UIViewControllers on UINavigationController. To switch modes, I use Combine.
Data is managed and passed through ViewModels, including temporary ViewModels for editing states. Nested ViewModels have nested NSManagedContexts, allowing scratchpad functionality and supporting undo-redo operations. UserDefaults stores information about an active workout to support state restoration.

## Miscellaneous Features
The app supports light and dark color schemes inherited from system preferences.

## Screenshot Gallery

<img src="./SweatSketch/Resources/AppDemos/SweatSketchDemo_1.png" alt="Carousel" width="300" height="auto">
<img src="./SweatSketch/Resources/AppDemos/SweatSketchDemo_2.png" alt="Workout Edit" width="300" height="auto">
<img src="./SweatSketch/Resources/AppDemos/SweatSketchDemo_3.png" alt="Exercise Edit" width="300" height="auto">
<img src="./SweatSketch/Resources/AppDemos/SweatSketchDemo_4.png" alt="Active Workout" width="300" height="auto">
<img src="./SweatSketch/Resources/AppDemos/SweatSketchDemo_5.png" alt="Activity" width="300" height="auto">
<img src="./SweatSketch/Resources/AppDemos/SweatSketchDemo_6.png" alt="Catalog" width="300" height="auto">
