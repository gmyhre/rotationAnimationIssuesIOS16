# rotationAnimationIssuesIOS16

UIView.setAnimationsEnabled(false) doesn't seem to turn off rotation animation in iOS 16.x
UIView.setAnimationsEnabled(false) does disable all animations in iOS 15.x and below.

iOS 15.x expected results after UIView.setAnimationsEnabled(false)

https://user-images.githubusercontent.com/274865/200950699-a4e97922-dc0e-4045-8a93-31c8bc29a745.mov

iOS 16.x unexpected rotation animation after UIView.setAnimationsEnabled(false)


https://user-images.githubusercontent.com/274865/200950849-24f877a3-89a1-4058-97b4-13de91718728.mov



