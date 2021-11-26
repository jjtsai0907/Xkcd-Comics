# Shortcut Code Challenge

This project is built upond a [guideline](https://github.com/shortcut/coding-assignment-mobile) provided by Shortcut for its recruitement process.


## Basic Info

- 32 commits
- SwiftUI
- MVVM design pattern
- Simple Unit Testing
- UserDefaults for storing data
- Third party library - Kingfisher 

## Features
As the time for this code challenge is limited, I have prioritized some features for a best MVP. 

- Finished:
  - Browse through the comics.
  - See the comic details.
  - Search for comics by the comic number.
  - Get the comic explanation.
  - Favorite the comics, which would be available offline too.
  
- Unfinished:
  - Search for comics by title/ text.
  - Send comics to others.
  - Get notifications when a new comic is published.
  - Support multiple form factors.

## New Stuff I learned
- UserDefaults: This is used to save data(comics).

## Thought Process/ Decisions
- When there is no more "Next" or "Previous" comic, it pops up an alert to inform users. I personally think that this way is more fun and interactive with users, instead of just disabling the buttons.
- UserDefaults is used instead of Firestore in order to store favourite comics and be able to access them offline.
- As I don't find an endpoint for comic explanation Json file, I have used an WebView in the app to display explanation.
- Regarding the UI design, I aim to provide a clean and simple app for reading comics. Therefore, I "hide" comics' details and explanation behind each comic. One can access them by simply tap on each comic image.
